 #!/bin/bash

# get the current path
SCRIPTPATH=$( cd $(dirname $0) ; pwd -P )

## Dir structure

HPX_PATH=$SCRIPTPATH/hpx
HPX_SOURCE_PATH=$HPX_PATH/source
HPX_BUILD_PATH=$HPX_PATH/build
HPX_INSTALL_PATH=$HPX_PATH/install

PERIDEM_PATH=$SCRIPTPATH/peridem
PERIDEM_SOURCE_PATH=$PERIDEM_PATH/source
PERIDEM_BUILD_PATH=$PERIDEM_PATH/build

show_path()
{
	echo "SCRIPTPATH=$SCRIPTPATH"
	echo "HPX_SOURCE_PATH=$HPX_SOURCE_PATH"
	echo "HPX_BUILD_PATH=$HPX_BUILD_PATH"
	echo "HPX_INSTALL_PATH=$HPX_INSTALL_PATH"

	echo "PERIDEM_PATH=$PERIDEM_PATH"
	echo "PERIDEM_SOURCE_PATH=$PERIDEM_SOURCE_PATH"
	echo "PERIDEM_BUILD_PATH=$PERIDEM_BUILD_PATH"
}

#exit 1

# not using
release_vs_debug()
{
	# build type
	if [ "$1" = "" ]; then
		echo "Build Type Not Specified"
		exit -1
	fi

	if [ "$1" != "Debug" ] && [ "$1" != "Release" ] && [ "$1" != "RelWithDebInfo" ]; then
		echo "Build Type Is Not Correct"
		exit -1
	fi
}


install_dependencies()
{
	# For ubuntu
	sudo apt-get install g++ cmake gmsh libboost-all-dev libvtk7-dev libyaml-cpp-dev libhwloc-dev libjemalloc-dev checkinstall apt-file 
	# libboost-all-dev is overkill, but just libboost-dev is not enough
	# clangd is language server, optional
	# clangd moved to snap, classical, too slow
	#sudo snap install clangd --classic

	# using standard installation instead
	sudo apt-get install clangd-10
	sudo update-alternatives --install /usr/bin/clangd clangd /usr/bin/clangd-9 100



	# apt-file figures out which package to install for missing .so file
	# then use `apt-file search filename.so`
	sudo apt-file update

	# ubuntu 20.04 libopenmpi-dev bug
	if [ ! -f /usr/lib/x86_64-linux-gnu/openmpi/lib/openmpi/libmpi.so ]; then
		#cd /usr/lib/x86_64-linux-gnu/openmpi/lib/
		#sudo ln -s libmpi.so.* libmpi.so
		#sudo ln -s libmpi_cxx.so.* libmpi_cxx.so

		sudo apt-get install --reinstall libopenmpi-dev
	fi


}

install_hpx()
{
	if [ ! -d "$HPX_SOURCE_PATH" ]; then
		echo 'Getting HPX source'
		git clone https://github.com/STEllAR-GROUP/hpx.git $HPX_SOURCE_PATH
		cd $HPX_SOURCE_PATH
		git checkout 1.3.0
	fi
	cd ..

	if [ ! -d "$HPX_BUILD_PATH" ]; then
		mkdir -p "$HPX_BUILD_PATH"

		cd "$HPX_BUILD_PATH"


		cmake -DCMAKE_BUILD_TYPE=$1   \
			-DCMAKE_CXX_COMPILER=g++ \
			-DCMAKE_C_COMPILER=gcc \
			-DHPX_WITH_THREAD_IDLE_RATES=ON \
			-DHPX_WITH_MALLOC=jemalloc \
			-DHPX_WITH_EXAMPLES=OFF \
			-DHPX_WITH_NETWORKING=OFF \
			-DCMAKE_INSTALL_PREFIX=$HPX_INSTALL_PATH \
			$HPX_SOURCE_PATH
	fi

	cd "$HPX_BUILD_PATH"

	echo 'Building HPX...'
	start=$SECONDS
	make -j10 -l8
	#make -j8 -l6
	duration=$(( SECONDS - start ))
	echo 'Installing HPX...'
	make install
	#checkinstall # creates a .deb file and installs it. Can be used to uninstall.

	echo "Building HPX took $duration seconds."
}

get_peridem()
{

	if [ ! -d "$PERIDEM_SOURCE_PATH" ]; then
		git clone git@github.com:prashjha/PeriDEM.git $PERIDEM_SOURCE_PATH
	fi
}

build_peridem()
{
	if [ ! -d "$PERIDEM_BUILD_PATH" ]; then
		mkdir -p "$PERIDEM_BUILD_PATH"

		cd "$PERIDEM_BUILD_PATH"
		# add when building in mac
		# -DYAML_CPP_DIR="/usr/local" \
		# To generate .json file to be used by clang
		#-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
		cmake -DCMAKE_BUILD_TYPE=Release   \
			-DHPX_DIR="$HPX_INSTALL_PATH/lib/cmake/HPX" \
			-DCMAKE_EXPORT_COMPILE_COMMANDS=1 \
			$PERIDEM_SOURCE_PATH
	fi

	#exit 1

	cd "$PERIDEM_BUILD_PATH"
	start=$SECONDS

	# for ubuntu 20.04, use `-lpthread` instead of `-pthread` with GNU compiler. 
	# In CMakeLists.txt file, use:
	# set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -pthread")
	make -j5
	#make
	#make -j10 -l8
	duration=$(( SECONDS - start ))
	echo "Building PeriDEM took $duration seconds."

	cp $PERIDEM_BUILD_PATH/*.json $PERIDEM_SOURCE_PATH
}

# # Run NLMech
# $PERIDEM_PATH/NLMech

clean_peridem()
{
 # delete build files
 if [ $PERIDEM_BUILD_PATH/NLMech ]; then
     rm -rf $PERIDEM_BUILD_PATH
 fi
}

usage()
{
    echo "usage: $0 [[[-d install-dependencies ] [-x install-hpx] [-g get-peridem] [-b build-peridem] [-c clean-peridem-build]] | [-a first-install-all] | [-h help] [-p show-path]]"
}

if [ $# == 0 ]; then
	usage
	exit 1
fi

while [ "$1" != "" ]; do
	case $1 in
		-d | --install-dependencies )
			install_dependencies
			;;
		-x | --install-hpx )    
			install_hpx
			;;
		-g | --get-peridem )
			get_peridem
			;;
		-b | --build-peridem )
			build_peridem
			;;
		-c | --clean-peridem-build )
			clean_peridem
			;;
		-a | --first-install-all )
			install_dependencies
			install_hpx
			get_peridem
			build_peridem
			show_path
			;;
		-h | --help )
			usage
			exit
			;;
		-p | --show-path )
			show_path
			exit
			;;
		* )         
	    		usage
			exit 1
	esac
	# replace $2 by $1 and so on
	shift
done

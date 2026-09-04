# Install Cocalc notebook locally

No need to install sage or sagemath.

Follow the instruction to install the cocalc-docker. It is just one
line long code. It will download,
extract and install. I had to use sudo to get it to work since I
installed docker using sudo (`sudo apt-get install docker.io`. 
To open it in browser, make sure to use `https://localhost` instead of
`http://localhost`.

I had create account (fake email id are ok, since they are local)

To start and stop cocalc, use 
`sudo docker start cocalc`
`sudo docker stop cocalc`

To view equations in latex rendering, use the function `view()`. To
print out the latex code of it, use the function `latex()`.

To define variables in a latex-friendly way so that the view command
prints it right, use

u_th_x = var('u_th_x', latex_name = 'u_{\\theta}(x)'}

Later, do `view(u_th_x)` to see it rendered correctly.



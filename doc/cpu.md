# CPU frequency scaling

* Use the utilty `s-tui` (`pip3 install s-tui --user`) along with `stress` (`sudo apt-get install stress`) to load your system and observe how temperature works with frequency.
* See the current `scaling_governor` using
```
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```
Note: the asterisk implies that we are printing out the rule for _all_ the cpu's.
If it is `powersave` (which is the default), the frequency stays at the lowest possible frequencies.

* You can manually change the current `scaling_governor` by directly editing the file with the one of the profiles 
[see](https://wiki.archlinux.org/index.php/CPU_frequency_scaling)
[see](https://www.kernel.org/doc/Documentation/cpu-freq/governors.txt)

`performance` 	Run the CPU at the maximum frequency.
`powersave` 	Run the CPU at the minimum frequency.
`userspace` 	Run the CPU at user specified frequencies.
`ondemand` 	Scales the frequency dynamically according to current load. Jumps to the highest frequency and then possibly back off as the idle time increases.
`conservative` 	Scales the frequency dynamically according to current load. Scales the frequency more gradually than ondemand.
`schedutil` 	Scheduler-driven CPU frequency selection [2], [3]. 

For examplie, issue
```
echo "performance" | sudo tee /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

**Caution:** raising the frequency increases the CPU temperature significantly and affects the remaining time on battery.

* Alternatively, you can edit the `scaling_governor` variable using the tool `cpupower`. On Ubuntu, this package can be installed using
```
sudo apt-get install linux-tools-<kernel_version>-generic
```
where `<kernel_version>` is the version of the current linux kernel (see `uname -a`).
Then, you can change the profile using
```
cpupower frequency-set -g ondemand
````


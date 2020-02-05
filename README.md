# freebsd-cpuset
Bash script to balance FreeBSD interrupts using the cpuset tool

For multiprocessor (SMP) systems, FreeBSD has the cpuset command to adjust which CPUs a process will use.

When working with firewalls and routers, using all of the CPUs of the system does not necessarily translate into better performance. Various tests have proven that assigning specific irq from NICs improves packets per second and bandwidth performance.

The following scripts include a wrapper for cpuset, a parallelized iperf3 script, and a python implementation to parse FreeBSD netstat output for further graphing.

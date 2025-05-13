# 📘 Linux Runlevels: A Complete Guide

## 🔹 What is a Runlevel?

A **runlevel** in Linux defines the state of the machine after boot. Each runlevel corresponds to a specific mode of operation and determines which services and processes are running. Runlevels are part of the traditional **SysV-style init system** (used in older distributions like RHEL 6 and CentOS 6).

---

## 🔹 Common Runlevels

| Runlevel | Description                          |
|----------|--------------------------------------|
| 0        | Halt (Shutdown)                      |
| 1        | Single-user mode (Maintenance mode)  |
| 2        | Multi-user, no networking (Debian)   |
| 3        | Full multi-user mode (No GUI)        |
| 4        | Undefined/Custom (Rarely used)       |
| 5        | Full multi-user mode with GUI        |
| 6        | Reboot                               |

> **Note**: Runlevels may vary slightly between distributions.  
> Red Hat-based systems typically use runlevels 3 and 5, while Debian uses 2 as the default.

---

## 🔹 Viewing the Current Runlevel

```bash
runlevel
```

Example Output:


```
N 5
```

- N indicates no previous runlevel (usually at boot).

- 5 is the current runlevel.

## 🔹 Changing Runlevels

- Temporarily (until next reboot):
```
init 3   # Switch to runlevel 3
```

or

```
telinit 3
```
## Permanently (older SysV systems):

## Edit /etc/inittab and set the default runlevel:

```
id:3:initdefault:

```

Changes require a reboot to take effect.


.

🔹 Systemd Equivalent (Modern Linux)
Modern Linux systems (RHEL 7+, CentOS 7+, Ubuntu 16.04+) use systemd instead of traditional runlevels.

# Target equivalents:
|Runlevel|	systemd Target     |
|--------|---------------------|
| 0      | poweroff.target     |
| 1	     | rescue.target       |
| 3	     | multi-user.target   |
| 5	     | graphical.target    |
| 6	     |reboot.target        |



# View current target: 
  ```
   systemctl get-default
  ```

# Change default target:

```
   sudo systemctl set-default multi-user.target
```

# Switch to target without reboot:

```
   sudo systemctl isolate multi-user.target
```

#🔹 Summary
- Runlevels define the mode of operation in traditional init systems.

- Runlevel 3 = no GUI, Runlevel 5 = GUI.

- Modern systems use systemd targets instead of runlevels.

- Use systemctl to manage targets on systemd-based systems.


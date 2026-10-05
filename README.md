# Linux System Information & Health Check

A beginner-friendly Bash project for monitoring basic Linux system information and health status.

This project collects information about the Linux system, CPU, memory, disk, and network connectivity, then displays the results in the terminal and records important health information in a log file.

## Project Goals

The main goals of this project are:

- Learn how Bash scripts interact with Linux.
- Collect basic Linux system information.
- Monitor CPU, memory, disk, and network status.
- Practice Bash variables, functions, conditions, pipes, and command substitution.
- Practice basic error handling.
- Implement simple logging.
- Build a small Linux project suitable for a beginner portfolio.

## Features

The script provides:

- Hostname information
- Operating system information
- Kernel information
- System uptime
- CPU information
- Memory usage and status
- Disk usage and status
- Network interface information
- Network connectivity check
- Overall system health status
- Basic error handling
- Timestamped logging


## Architecture

The project follows this simple flow:

User
  ↓
Bash Script
  ↓
Linux Commands
  ↓
Linux Kernel / System Resources
  ↓
System Information
  ↓
Health Analysis
  ↓
Terminal Output + Log File

The Bash script acts as an automation layer between the user and the Linux system.

It does not directly manage the Linux kernel. Instead, it executes Linux commands that obtain information from the operating system and system resources.

## Technologies

- Linux
- Ubuntu
- Bash
- WSL2
- Git
- GitHub

## Project Structure

```text
linux-system-health-check/
├── system_health.sh
├── logs/
│   └── system_health.log
├── .gitignore
└── README.md

## How to Run

Clone or download the project, then enter the project directory:

```bash
cd linux-system-health-check


## Linux Concepts Learned

This project reinforces several Linux and Bash concepts:

- Linux filesystem
- `/etc/os-release`
- Linux kernel information
- System uptime
- CPU information
- Memory management
- Disk usage
- Network interfaces
- Loopback interface
- IP address
- Network connectivity
- Bash variables
- Command substitution
- Functions
- Pipes
- Redirection
- Exit status
- Conditional statements
- File tests
- Permissions
- Executable files
- Logging
- Basic error handling


## What I Learned

Through this project, I learned that Bash can be used to automate Linux system administration tasks.

I learned how to:

- Read information provided by Linux commands.
- Store command output in Bash variables.
- Process command output using pipes and tools such as `grep`, `awk`, `cut`, and `tr`.
- Use functions to organize a Bash script.
- Use conditions to determine system health.
- Check command success or failure using exit status.
- Create and manage log files.
- Work with Linux file permissions.
- Structure a small Linux automation project.


## Possible Improvements

Future improvements could include:

- CPU usage monitoring
- More accurate network connectivity checks
- DNS resolution checks
- Multiple disk and mount point monitoring
- Configurable warning and critical thresholds
- Colored terminal output
- Log rotation
- Command-line options
- Configuration file support
- Service monitoring
- Automated periodic execution using cron or systemd
- Exporting health information to JSON
- Sending alerts when the system becomes unhealthy

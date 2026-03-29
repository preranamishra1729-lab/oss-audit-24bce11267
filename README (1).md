# OSS Audit — Git
### Open Source Software Capstone Project | VITyarthi

---

## Project Overview

This repository contains the shell scripts and supporting materials for **The Open Source Audit** capstone project. The audited software is **Git** — a distributed version control system originally written by Linus Torvalds in 2005 and released under the GNU General Public License version 2 (GPL v2).

---

## Repository Structure

```
oss-audit-[rollnumber]/
├── script1_system_identity.sh        # System welcome screen with OS info
├── script2_package_inspector.sh      # FOSS package install checker
├── script3_disk_permission_auditor.sh # Directory permissions and disk usage
├── script4_log_analyzer.sh           # Log file keyword counter and reporter
├── script5_manifesto_generator.sh    # Interactive open-source manifesto writer
└── README.md                         # This file
```

---

## Script Descriptions

### Script 1 — System Identity Report
Displays a formatted welcome screen showing the Linux distribution, kernel version, current user, home directory, system uptime, current date and time, and the open-source license that governs the running OS (GPL v2 for the Linux kernel).

**Concepts used:** variables, `echo`, command substitution `$()`, `/etc/os-release`, `uname`, `whoami`, `uptime`, `date`.

---

### Script 2 — FOSS Package Inspector
Checks whether a specified package (default: `git`) is installed on the system. Works on both RPM-based (Fedora, RHEL, Rocky) and Debian-based (Ubuntu, Debian) systems. Displays version, license, and summary, then uses a `case` statement to print a one-line philosophy note about the package.

**Concepts used:** `if-then-else`, `case` statement, `rpm -qi`, `dpkg -l`, `apt-cache show`, `command -v`, pipe with `grep`, command-line arguments (`$1`).

---

### Script 3 — Disk and Permission Auditor
Loops through a list of standard system directories (`/etc`, `/var/log`, `/home`, `/usr/bin`, `/tmp`, `/usr/share`, `/var/lib`) and reports permissions, owner, and disk usage for each. Then audits Git-specific paths such as `/etc/gitconfig`, `~/.gitconfig`, and the git binary.

**Concepts used:** `for` loop over an array, `ls -ld`, `du -sh`, `awk`, `cut`, `-d` directory test, `-e` existence test.

---

### Script 4 — Log File Analyzer
Reads a log file line by line and counts occurrences of a keyword (default: `error`). Includes a do-while-style retry loop if the file is not found or is empty (up to 3 attempts). Displays the last 5 matching lines.

**Concepts used:** `while IFS= read -r` loop, `if-then-else`, counter variables `$((COUNT + 1))`, command-line arguments (`$1`, `$2`), `grep -i`, `tail`, `wc -l`, input redirection `< file`.

---

### Script 5 — Open Source Manifesto Generator
Interactively asks the user three questions, then composes a personalised open-source philosophy statement and saves it to a `.txt` file named `manifesto_<username>.txt`. Also demonstrates the alias concept via comments.

**Concepts used:** `read -p` for interactive input, string interpolation inside double quotes, writing to a file with `>` and `>>`, `date`, `whoami`, `cat`, alias concept (demonstrated via comment).

---

## How to Run the Scripts on Linux

### Prerequisites

Make sure you are on a Linux system (physical, VM, or WSL). Git should be installed:

```bash
# Debian / Ubuntu
sudo apt update && sudo apt install git -y

# Fedora / RHEL / Rocky Linux
sudo dnf install git -y
```

### Step 1 — Clone the repository

```bash
git clone https://github.com/<your-username>/oss-audit-[rollnumber].git
cd oss-audit-[rollnumber]
```

### Step 2 — Make all scripts executable

```bash
chmod +x script1_system_identity.sh
chmod +x script2_package_inspector.sh
chmod +x script3_disk_permission_auditor.sh
chmod +x script4_log_analyzer.sh
chmod +x script5_manifesto_generator.sh
```

### Step 3 — Run each script

```bash
# Script 1: System Identity Report (no arguments needed)
./script1_system_identity.sh

# Script 2: Package Inspector (default package = git)
./script2_package_inspector.sh
# Or inspect a different package:
./script2_package_inspector.sh firefox

# Script 3: Disk and Permission Auditor (no arguments needed)
./script3_disk_permission_auditor.sh

# Script 4: Log File Analyzer
./script4_log_analyzer.sh /var/log/syslog error
# On systems without /var/log/syslog, try:
./script4_log_analyzer.sh /var/log/auth.log warning

# Script 5: Manifesto Generator (interactive — follow the prompts)
./script5_manifesto_generator.sh
```

---

## Dependencies

| Script | Dependencies |
|--------|-------------|
| Script 1 | `bash`, `uname`, `whoami`, `uptime`, `date`, `/etc/os-release` |
| Script 2 | `bash`, `rpm` or `dpkg`/`apt-cache`, `grep`, `command` |
| Script 3 | `bash`, `ls`, `du`, `awk`, `cut`, `which` |
| Script 4 | `bash`, `grep`, `tail`, `wc` |
| Script 5 | `bash`, `read`, `date`, `whoami`, `cat` |

All dependencies are standard and available by default on any Linux distribution.

---

## Audited Software

**Git** — Distributed Version Control System
- **License:** GNU General Public License v2 (GPL v2)
- **Author:** Linus Torvalds (initial release 2005)
- **Homepage:** https://git-scm.com
- **Source:** https://github.com/git/git

---

## Academic Integrity

All shell scripts in this repository are original work written for the OSS NGMC capstone project. Each script is commented to demonstrate understanding of the shell constructs used.

#!/bin/bash
# =============================================================================
# Script 1: System Identity Report
# Course  : Open Source Software (OSS NGMC)
# Purpose : Display a welcome screen with key system information and
#           identify the open-source license that governs the OS kernel.
# =============================================================================

# --- Student / project variables ---
STUDENT_NAME="Student"            # Replace with your name
SOFTWARE_CHOICE="Git"             # Chosen OSS project for the audit

# --- Gather system information using command substitution ---
KERNEL=$(uname -r)                # Running kernel version (e.g. 5.15.0-91-generic)
DISTRO=$(grep PRETTY_NAME /etc/os-release 2>/dev/null | cut -d= -f2 | tr -d '"')
# Fallback: if os-release is missing, use uname
[ -z "$DISTRO" ] && DISTRO=$(uname -o)

USER_NAME=$(whoami)               # Currently logged-in username
HOME_DIR=$HOME                    # Home directory of the current user
UPTIME=$(uptime -p)               # Human-readable uptime (e.g. "up 2 hours, 5 minutes")
DATETIME=$(date '+%A, %d %B %Y  %H:%M:%S')   # Full date and time

# The Linux kernel is released under GPL v2 — a copyleft free-software license
OS_LICENSE="GNU General Public License version 2 (GPL v2)"

# --- Display the welcome banner ---
echo "========================================================"
echo "       Open Source Audit — System Identity Report       "
echo "========================================================"
echo ""
echo "  Student      : $STUDENT_NAME"
echo "  OSS Project  : $SOFTWARE_CHOICE"
echo ""
echo "--------------------------------------------------------"
echo "  SYSTEM INFORMATION"
echo "--------------------------------------------------------"
echo "  Distribution : $DISTRO"
echo "  Kernel       : $KERNEL"
echo "  User         : $USER_NAME"
echo "  Home Dir     : $HOME_DIR"
echo "  Uptime       : $UPTIME"
echo "  Date & Time  : $DATETIME"
echo ""
echo "--------------------------------------------------------"
echo "  LICENSE NOTE"
echo "--------------------------------------------------------"
echo "  The operating system kernel (Linux) running on this"
echo "  machine is covered by the:"
echo "  $OS_LICENSE"
echo ""
echo "  This means the kernel source code is freely available,"
echo "  and any modifications distributed must also be shared"
echo "  under the same license — this is called 'copyleft'."
echo "========================================================"

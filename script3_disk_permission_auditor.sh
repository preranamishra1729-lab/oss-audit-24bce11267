#!/bin/bash
# =============================================================================
# Script 3: Disk and Permission Auditor
# Course  : Open Source Software (OSS NGMC)
# Purpose : Loop through important system directories, report disk usage and
#           permissions for each, then specifically audit Git's config directory.
# Concepts: for loop, arrays, ls -ld, du -sh, awk, cut, conditional checks.
# =============================================================================

# --- List of standard system directories to audit ---
# These are the key locations in the Linux Filesystem Hierarchy Standard (FHS)
DIRS=("/etc" "/var/log" "/home" "/usr/bin" "/tmp" "/usr/share" "/var/lib")

# --- Git-specific directories to check at the end ---
# Git stores global config at ~/.gitconfig and system config at /etc/gitconfig
GIT_DIRS=("/etc/gitconfig" "$HOME/.gitconfig" "$HOME/.git" "/usr/share/git-core")

echo "========================================================"
echo "       Disk and Permission Auditor — OSS Audit Tool    "
echo "========================================================"
echo "  Run by : $(whoami)  |  Date : $(date '+%d %B %Y %H:%M')"
echo ""
echo "--------------------------------------------------------"
echo "  PART 1 — Standard System Directory Audit"
echo "--------------------------------------------------------"
printf "  %-20s %-25s %s\n" "DIRECTORY" "PERMISSIONS / OWNER" "SIZE"
printf "  %-20s %-25s %s\n" "---------" "-------------------" "----"

# --- Loop over each directory and report permissions and size ---
for DIR in "${DIRS[@]}"; do
    if [ -d "$DIR" ]; then
        # ls -ld: 'l' = long format, 'd' = directory itself (not its contents)
        # awk extracts: field 1 (permissions), field 3 (owner), field 4 (group)
        PERMS=$(ls -ld "$DIR" | awk '{print $1, $3":"$4}')

        # du -sh: 's' = summarise (single total), 'h' = human-readable (KB/MB/GB)
        # cut -f1 extracts just the size (du outputs size<TAB>path)
        SIZE=$(du -sh "$DIR" 2>/dev/null | cut -f1)

        printf "  %-20s %-25s %s\n" "$DIR" "$PERMS" "$SIZE"
    else
        printf "  %-20s %s\n" "$DIR" "[does not exist on this system]"
    fi
done

echo ""
echo "--------------------------------------------------------"
echo "  PART 2 — Git Configuration Directory Audit"
echo "--------------------------------------------------------"
echo "  Git (our audited OSS project) stores its configuration"
echo "  in these locations. Checking each now..."
echo ""

# --- Check each Git-related path ---
for GDIR in "${GIT_DIRS[@]}"; do
    if [ -e "$GDIR" ]; then
        # -e covers both files and directories
        if [ -d "$GDIR" ]; then
            TYPE="directory"
            SIZE=$(du -sh "$GDIR" 2>/dev/null | cut -f1)
        else
            TYPE="file"
            SIZE=$(du -sh "$GDIR" 2>/dev/null | cut -f1)
        fi

        # Get permissions and owner
        PERMS=$(ls -ld "$GDIR" | awk '{print $1, $3":"$4}')

        echo "  Path  : $GDIR  [$TYPE]"
        echo "  Perms : $PERMS"
        echo "  Size  : $SIZE"
        echo ""
    else
        echo "  Path  : $GDIR  [NOT FOUND — may not be configured yet]"
        echo ""
    fi
done

echo "--------------------------------------------------------"
echo "  PART 3 — Git Binary Location"
echo "--------------------------------------------------------"

# --- Show where the git binary lives and its permissions ---
GIT_BIN=$(which git 2>/dev/null)

if [ -n "$GIT_BIN" ]; then
    echo "  Git binary found at : $GIT_BIN"
    # Get the actual file permissions of the git binary
    BIN_PERMS=$(ls -l "$GIT_BIN" | awk '{print $1, $3":"$4}')
    echo "  Binary permissions  : $BIN_PERMS"
    echo "  Git version         : $(git --version 2>/dev/null)"
else
    echo "  Git binary NOT found in PATH."
    echo "  Install with: sudo apt install git  OR  sudo dnf install git"
fi

echo "========================================================"
echo "  Audit complete. Review permissions above for any"
echo "  unexpected world-writable (o+w) entries."
echo "========================================================"

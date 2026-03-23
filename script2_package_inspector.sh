#!/bin/bash
# =============================================================================
# Script 2: FOSS Package Inspector
# Course  : Open Source Software (OSS NGMC)
# Purpose : Check if a given FOSS package is installed, display its version
#           and license details, then print a philosophy note via a case
#           statement. Works on both RPM-based and Debian-based systems.
# Usage   : ./script2_package_inspector.sh [package-name]
#           Default package is 'git' (the audited software).
# =============================================================================

# --- Accept an optional package name as a command-line argument ---
# If none supplied, default to 'git' (our audited project)
PACKAGE=${1:-git}

echo "========================================================"
echo "       FOSS Package Inspector — OSS Audit Tool         "
echo "========================================================"
echo "  Inspecting package : $PACKAGE"
echo "--------------------------------------------------------"

# --- Detect the package manager available on this system ---
# RPM-based distros: Fedora, RHEL, CentOS, Rocky Linux
# DEB-based distros: Ubuntu, Debian, Linux Mint
if command -v rpm &>/dev/null; then
    PKG_MANAGER="rpm"
elif command -v dpkg &>/dev/null; then
    PKG_MANAGER="dpkg"
else
    PKG_MANAGER="unknown"
fi

echo "  Package manager    : $PKG_MANAGER"
echo ""

# --- Check whether the package is installed, then show details ---
if [ "$PKG_MANAGER" = "rpm" ]; then
    # rpm -q exits 0 if installed, non-zero if not
    if rpm -q "$PACKAGE" &>/dev/null; then
        echo "  STATUS : $PACKAGE is INSTALLED."
        echo ""
        echo "  Package details (from rpm -qi):"
        echo "  --------------------------------"
        # Extract only the Version, License, and Summary fields
        rpm -qi "$PACKAGE" | grep -E "^Version|^License|^Summary" | \
            while IFS= read -r line; do echo "    $line"; done
    else
        echo "  STATUS : $PACKAGE is NOT installed on this system."
        echo "  Tip    : Install it with:  sudo dnf install $PACKAGE"
    fi

elif [ "$PKG_MANAGER" = "dpkg" ]; then
    # dpkg -l filters; check status field starts with 'ii' (installed)
    if dpkg -l "$PACKAGE" 2>/dev/null | grep -q "^ii"; then
        echo "  STATUS : $PACKAGE is INSTALLED."
        echo ""
        echo "  Package details (from dpkg -l + apt-cache show):"
        echo "  --------------------------------------------------"
        dpkg -l "$PACKAGE" | grep "^ii" | awk '{print "    Version : "$3}'
        # apt-cache show gives richer info including license description
        if command -v apt-cache &>/dev/null; then
            apt-cache show "$PACKAGE" 2>/dev/null | \
                grep -E "^Version|^Section|^Homepage" | \
                while IFS= read -r line; do echo "    $line"; done
        fi
    else
        echo "  STATUS : $PACKAGE is NOT installed on this system."
        echo "  Tip    : Install it with:  sudo apt install $PACKAGE"
    fi

else
    # Fallback: try 'which' to at least see if the binary is on PATH
    if which "$PACKAGE" &>/dev/null; then
        echo "  STATUS : Binary '$PACKAGE' found at $(which $PACKAGE)"
        echo "           (Package manager unavailable for deeper inspection)"
    else
        echo "  STATUS : Cannot determine — no known package manager found."
    fi
fi

echo ""
echo "--------------------------------------------------------"
echo "  OPEN SOURCE PHILOSOPHY NOTE"
echo "--------------------------------------------------------"

# --- case statement: print a one-line philosophy note per package ---
case "$PACKAGE" in
    git)
        echo "  Git: Linus Torvalds built this when a proprietary tool"
        echo "  failed him — a reminder that freedom to control your own"
        echo "  tools is not a luxury, it is a necessity."
        ;;
    httpd | apache2)
        echo "  Apache HTTP Server: the web server that built the open"
        echo "  internet, proving that community collaboration can power"
        echo "  infrastructure used by billions."
        ;;
    mysql | mariadb)
        echo "  MySQL / MariaDB: open source at the heart of millions of"
        echo "  applications — and a case study in dual-licensing tensions."
        ;;
    vlc)
        echo "  VLC: built by students who simply wanted to stream video"
        echo "  — open source born from a genuine, practical need."
        ;;
    firefox)
        echo "  Firefox: a nonprofit's answer to proprietary browser"
        echo "  monopoly — proof that mission-driven open source matters."
        ;;
    python3 | python)
        echo "  Python: a language shaped entirely by its community,"
        echo "  showing how openness accelerates innovation."
        ;;
    libreoffice)
        echo "  LibreOffice: born from a fork when the community felt"
        echo "  stewardship was at risk — open source governance in action."
        ;;
    kernel | linux)
        echo "  Linux Kernel: the foundation everything else runs on,"
        echo "  and the world's largest collaborative software project."
        ;;
    *)
        echo "  $PACKAGE: every open-source project is a gift —"
        echo "  someone built this and chose to share it freely."
        ;;
esac

echo "========================================================"

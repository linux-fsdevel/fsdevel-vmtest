#!/bin/bash
# Shared preamble for vfs-ci test runner scripts.

# Detect distro — gives us $ID ("fedora", "debian", …), $VERSION_ID, etc.
. /etc/os-release

echo "vfs-ci: running on ${ID} ${VERSION_ID} ($(uname -r))"

busctl call org.freedesktop.systemd1 /org/freedesktop/systemd1 org.freedesktop.systemd1.Manager SetShowStatus s no || true

# Known-flaky or expected-failing tests per suite.
XFS_EXCLUDE="-e xfs/017 xfs/018 xfs/176 xfs/556 xfs/620"
OVL_EXCLUDE="-e generic/091 generic/103 generic/263 generic/760 ${XFS_EXCLUDE}"
SELFTESTS_DENYLIST=(filesystems:file_stressor filelock:ofdlocks)

case "$ID" in
    debian)
	    # Quota tools on Debian are too old. We need >=4.11
	    XFS_EXCLUDE+=" -x quota"
	    OVL_EXCLUDE+=" -x quota"
        ;;
    fedora)
        ;;
esac

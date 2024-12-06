#!/sbin/sh
#
#
# This file and its contents are supplied under the terms of the
# Common Development and Distribution License ("CDDL"), version 1.0.
# You may only use this file in accordance with the terms of version
# 1.0 of the CDDL.
#
# A full copy of the text of the CDDL should have accompanied this
# source.  A copy of the CDDL is also available via the Internet at
# http://www.illumos.org/license/CDDL.
#

#
# Copyright 2024 Hans Rosenfeld
#

. /lib/svc/share/ipf_include.sh
. /lib/svc/share/smf_include.sh

AWK=/usr/bin/awk
PKILL=/usr/bin/pkill
SVCS=/usr/bin/svcs
SVCPROP=/usr/bin/svcprop

BLOCKLISTD=/usr/sbin/blocklistd

args="-r"

val=$(${SVCPROP} -p config/control_program ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -C ${val}"

val=$(${SVCPROP} -p config/config_file ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -c ${val}"

val=$(${SVCPROP} -p config/db_file ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -D ${val}"

val=$(${SVCPROP} -p config/sockpaths_file ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -P ${val}"

val=$(${SVCPROP} -p config/rulename ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -R ${val}"

val=$(${SVCPROP} -p config/sockpaths ${SMF_FMRI})
[ "${val}" != "none" ] && args="${args} -s ${val//:/ -s }"

val=$(${SVCPROP} -p config/timeout ${SMF_FMRI})
[ "${val}" != "0" ] && args="${args} -t ${val}"


case "${SMF_METHOD}" in
    start)
	${BLOCKLISTD} ${args}
	;;

    *)
	echo "Usage: $0 { start }"
	exit ${SMF_ERR_FATAL}
	;;

esac
exit $?

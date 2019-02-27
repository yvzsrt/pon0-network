#!/bin/bash

# This script is inspired by Huawei CNI Genie script (launch.sh) that does something 
# similar but a lot more than what we are doing here.
#---------------------------------------------------------------------

# Make sure to have mounted /host/opt/cni/bin /host/etc/cni/net.d
# Make sure CNI_GENIE_NETWORK_CONFIG config map env is set.

# Ensure all variables are defined.
set -u

TMP_CONF='/pon0.conf.tmp'
TMP_CONF2='/pon1.conf.tmp'
TMP_CONF3='/pon2.conf.tmp'
TMP_CONF4='/pon3.conf.tmp'


# If specified, overwrite the network configuration file.
if [ "${CNI_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF <<EOF
${CNI_NETWORK_CONFIG:-}
EOF
fi

if [ "${CNI_PON1_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF2 <<EOF
${CNI_PON1_NETWORK_CONFIG:-}
EOF
fi

if [ "${CNI_PON2_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF3 <<EOF
${CNI_PON2_NETWORK_CONFIG:-}
EOF
fi

if [ "${CNI_PON3_NETWORK_CONFIG:-}" != "" ]; then
cat >$TMP_CONF4 <<EOF
${CNI_PON3_NETWORK_CONFIG:-}
EOF
fi


# Move the temporary CNI config into place.
FILENAME=${CNI_CONF_NAME:-20-pon0.conf}
mv $TMP_CONF /host/etc/cni/net.d/${FILENAME}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${FILENAME})"

FILENAME2=${CNI_CONF_NAME2:-25-pon1.conf}
mv $TMP_CONF2 /host/etc/cni/net.d/${FILENAME2}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${FILENAME2})"

FILENAME3=${CNI_CONF_NAME3:-35-pon2.conf}
mv $TMP_CONF3 /host/etc/cni/net.d/${FILENAME3}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${FILENAME3})"

FILENAME4=${CNI_CONF_NAME4:-45-pon3.conf}
mv $TMP_CONF4 /host/etc/cni/net.d/${FILENAME4}
echo "Wrote CNI config: $(cat /host/etc/cni/net.d/${FILENAME4})"


# Unless told otherwise, sleep forever.
# This prevents Kubernetes from restarting the pod repeatedly.
should_sleep=${SLEEP:-"true"}
echo "Done configuring CNI.  Sleep=$should_sleep"
while [ "$should_sleep" == "true"  ]; do
        sleep 10;
done

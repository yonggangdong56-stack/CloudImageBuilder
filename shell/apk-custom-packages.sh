#!/bin/bash
# Stable MT3600BE proxy package set (OpenWrt 25.12 APK)
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-store"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-adguardhome"
# SmartDNS and OpenClash language packages are not included here because they are absent from the 25.12 ImageBuilder index.
# dae/daed is added separately only after a matching ARM64 APK is verified.

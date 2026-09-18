#!/bin/bash
# Stable MT3600BE proxy package set
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-openclash"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-store"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-app-adguardhome"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-adguardhome-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-smartdns-zh-cn"
CUSTOM_PACKAGES="$CUSTOM_PACKAGES luci-i18n-openclash-zh-cn"
# dae/daed is added separately only after a matching ARM64 APK is verified.

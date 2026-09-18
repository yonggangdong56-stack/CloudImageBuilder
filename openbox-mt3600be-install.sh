#!/bin/sh
# Optional Open-Box installer for GL-MT3600BE / ImmortalWrt 25.12 ARM64.
# Installs Open-Box outside the base firmware; does not modify OpenClash settings.
set -eu
umask 022
[ "$(id -u)" = 0 ] || { echo "请用 root 运行" >&2; exit 1; }
[ -r /etc/openwrt_release ] || { echo "仅支持 OpenWrt/ImmortalWrt" >&2; exit 1; }
[ "$(uname -m)" = aarch64 ] || { echo "本脚本仅支持 ARM64" >&2; exit 1; }
command -v curl >/dev/null 2>&1 || { echo "缺少 curl，请先安装 curl" >&2; exit 1; }

# Prefer external storage when mounted; otherwise use /opt and require enough space.
TARGET=/opt
for p in /mnt/sda1 /mnt/mmcblk0p1 /mnt/usb /media/sda1; do
  if [ -d "$p" ] && [ "$(df -Pk "$p" | awk 'NR==2{print $4}')" -ge 512000 ]; then
    TARGET="$p/openbox-opt"
    mkdir -p "$TARGET"
    break
  fi
done
mkdir -p "$TARGET"
FREE=$(df -Pk "$TARGET" | awk 'NR==2{print $4}')
[ "$FREE" -ge 512000 ] || { echo "可用空间不足 512MB，请插入并挂载 USB 存储" >&2; exit 1; }

# Open-Box expects /opt/open-box. Use a symlink only when /opt is empty or absent.
if [ "$TARGET" != /opt ]; then
  if [ -e /opt/open-box ] && [ ! -L /opt/open-box ]; then
    echo "/opt/open-box 已存在，请先卸载旧版" >&2; exit 1
  fi
  mkdir -p "$TARGET"
  [ -e /opt ] || mkdir -p /opt
  [ -L /opt/open-box ] || ln -s "$TARGET" /opt/open-box
fi

BASE=https://github.com/liandu2024/Open-Box/releases/download/v0.1.202
TMP="$TARGET/.openbox-download.$$"
mkdir -p "$TMP"
trap 'rm -rf "$TMP"' EXIT
ASSET=open-box-v0.1.202-linux-arm64.tar.gz
curl -fL --connect-timeout 15 -o "$TMP/$ASSET" "$BASE/$ASSET"
curl -fL --connect-timeout 15 -o "$TMP/$ASSET.sha256" "$BASE/$ASSET.sha256"
(cd "$TMP" && sha256sum -c "$ASSET.sha256")
mkdir -p /opt/open-box
# Official archive layout is installed exactly as released.
tar -xzf "$TMP/$ASSET" -C /opt/open-box --strip-components=0
chown -R 0:0 /opt/open-box
chmod +x /opt/open-box/bin/sing-box /opt/open-box/node/bin/node 2>/dev/null || true
cp /opt/open-box/openwrt/initd/openbox /etc/init.d/openbox
cp /opt/open-box/openwrt/initd/openbox-panel /etc/init.d/openbox-panel
chmod +x /etc/init.d/openbox /etc/init.d/openbox-panel
/etc/init.d/openbox-panel enable
/etc/init.d/openbox enable
/etc/init.d/openbox-panel start
printf '%s\n' "Open-Box 已安装： http://$(uci -q get network.lan.ipaddr 2>/dev/null || echo 192.168.8.1):2026"
printf '%s\n' "首次打开面板后设置密码；OpenClash 不会被修改。"

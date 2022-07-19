#!/bin/bash
#=================================================
# Description: DIY script
# Lisence: MIT
# Author: P3TERX
# Blog: https://p3terx.com
#=================================================
# Modify default IP
sed -i 's/192.168.1.1/192.168.50.1/g' package/base-files/files/bin/config_generate

# Add date version
export DATE_VERSION=$(date -d "$(rdate -n -4 -p pool.ntp.org)" +'%Y-%m-%d')
sed -i "s/%C/%C (${DATE_VERSION})/g" package/base-files/files/etc/openwrt_release

# Fix mt76 wireless driver
pushd package/kernel/mt76
sed -i '/mt7662u_rom_patch.bin/a\\techo mt76-usb disable_usb_sg=1 > $\(1\)\/etc\/modules.d\/mt76-usb' Makefile
popd

# Rename hostname to OpenWrt
pushd package/base-files/files/bin
sed -i 's/ImmortalWrt/OpenWrt/g' config_generate
popd

# Change default shell to zsh
sed -i 's/\/bin\/ash/\/usr\/bin\/zsh/g' package/base-files/files/etc/passwd

# Modify default IP
sed -i "s/timezone='UTC'/timezone='UTC+3'/" package/base-files/files/bin/config_generate
sed -i "/timezone='UTC+3'/a \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ \ set system.@system[-1].zonename='Europe/Istanbul'" package/base-files/files/bin/config_generate

echo "src-git small https://github.com/kenzok8/small" >> feeds.conf.default
echo "src-git others https://github.com/kenzok8/openwrt-packages" >> feeds.conf.default

mkdir package/hermes
git clone https://github.com/vernesong/OpenClash package/hermes/luci-app-openclash
./scripts/feeds update -a
./scripts/feeds install -a

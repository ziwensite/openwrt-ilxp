#!/bin/bash
#=================================================
# Description: Build OpenWrt using GitHub Actions 
# Lisence: MIT
# 参考以下资料：
# Frome: https://github.com/kiddin9/
# Frome: https://github.com/P3TERX/Actions-OpenWrt
# Frome: https://github.com/Lienol/openwrt-actions
# Frome: https://github.com/svenstaro/upload-release-action
# By YAOF 2020 https://www.yaoft.org
# https://github.com/onewrt
#=================================================

# Add a feed source
#sed -i '$a src-git custom https://github.com/kiddin9/openwrt-packages.git;master' feeds.conf.default
#echo 'src-git iwrt https://github.com/kiddin9/openwrt-packages' >>feeds.conf.default
#echo 'src-git passwall https://github.com/xiaorouji/openwrt-passwall' >>feeds.conf.default
#注释掉默认的
#sed -i 's/src-git lienol/#src-git lienol/g' feeds.conf.default
#sed -i 's/src-git other/#src-git other/g' feeds.conf.default
#升级安装feed
#./scripts/feeds update -a
#./scripts/feeds install -a -p custom
#./scripts/feeds install -a
#cd feeds/custom; git pull; cd -

#清除lean库里几个造成编译不成功的软件
#rm -Rf feeds/luci/applications
rm -Rf feeds/luci/applications/luci-app-unblockmusic
rm -Rf feeds/luci/applications/luci-app-vlmcsd
rm -Rf feeds/luci/applications/luci-app-wol
rm -Rf feeds/luci/themes/luci-theme-argon


#克隆lean的luci应用
#svn co https://github.com/coolsnowwolf/luci/trunk/applications package/lean/applications

#克隆immortalwrt的ipv6-helper
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/ipv6-helper  package/diy/ipv6-helper
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06/package/emortal/autocore package/diy/autocore
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06/package/emortal/automount package/diy/automount
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06/package/emortal/autosamba package/diy/autosamba
svn co https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06/package/emortal/ipv6-helper package/diy/ipv6-helper


rm -Rf package/kernel/mt76  #必须清楚，否则编译不成功

#eqos和ikoolproxy和clash，用我自己的
rm -Rf package/lean/applications/luci-app-eqos
git clone https://github.com/yaof2/luci-app-eqos.git package/diy/luci-app-eqos
git clone https://github.com/yaof2/luci-app-ikoolproxy.git package/diy/luci-app-ikoolproxy


#svn co https://github.com/coolsnowwolf/luci/trunk/applications/luci-app-turboacc package/diy/luci-app-turboacc
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/dnsforwarder package/diy/dnsforwarder
#svn co https://github.com/coolsnowwolf/packages/trunk/net/dnsproxy package/diy/dnsproxy


#清除自带的软件库，luci会崩溃
rm -Rf feeds/packages/net/nft-qos
rm -Rf feeds/luci/transplant/luci-app-nft-qos
rm -Rf feeds/luci/transplant/luci-app-nft-qos

#mosdns（编译不成功，转战smartdns）
#svn co https://github.com/QiuSimons/openwrt-mos/branches/v3_EOL/luci-app-mosdns package/diy/luci-app-mosdns
#svn co https://github.com/QiuSimons/openwrt-mos/branches/v3_EOL/mosdns package/diy/mosdns

#svn co https://github.com/sbwml/luci-app-mosdns/trunk/luci-app-mosdns package/diy/luci-app-mosdns
#svn co https://github.com/sbwml/luci-app-mosdns/trunk/mosdns package/diy/mosdns
#svn co https://github.com/sbwml/v2ray-geodata package/diy/v2ray-geodata


#rm -Rf feeds/other/luci-app-adguardhome
#svn export --force https://github.com/immortalwrt/luci/openwrt-18.06/applications/applications/luci-app-adguardhome package/diy/luci-app-adguardhome
#svn export --force https://github.com/immortalwrt/packages/trunk/net/adguardhome package/diy/adguardhome


#svn export --force https://github.com/x-wrt/packages/trunk/net/nft-qos  package/diy/nft-qos
#svn export --force https://github.com/x-wrt/luci/trunk/applications/luci-app-nft-qos package/diy/luci-app-nft-qos无法使用

# 修内核
sed -i 's/4.9/4.14/g' target/linux/x86/Makefile
#sed -i 's/4.19/4.19/g' target/linux/x86/Makefile

# 修改登陆地址
sed -i 's/192.168.1.1/192.168.8.1/g' package/base-files/files/bin/config_generate
# 关闭禁止解析IPv6 DNS 记录
sed -i '/option filter_aaaa 1/d' package/network/services/dnsmasq/files/dhcp.conf


#openclash
#sed -i '$a src-git openclash https://github.com/vernesong/OpenClash.git' feeds.conf.default
#svn export --force https://github.com/vernesong/OpenClash/trunk/luci-app-openclash package/diy/luci-app-openclash
#svn export --force https://github.com/openwrt/packages/branches/openwrt-21.02/libs/libcap  package/diy/libcap
#svn export --force https://github.com/openwrt/packages/branches/openwrt-21.02/lang/ruby  package/diy/ruby
# 添加内核
#wget https://github.com/vernesong/OpenClash/releases/download/Clash/clash-linux-amd64.tar.gz&&tar -zxvf *.tar.gz
#chmod 0755 clash
#rm -rf *.tar.gz&&mkdir -p package/base-files/files/etc/openclash/core&&mv clash package/base-files/files/etc/openclash/core

#修改网络连接数
sed -i 's/net.netfilter.nf_conntrack_max=65535/net.netfilter.nf_conntrack_max=105535/g' package/kernel/linux/files/sysctl-nf-conntrack.conf

#添加adguardhome带核心安装。
#git clone https://github.com/rufengsuixing/luci-app-adguardhome.git  package/diy/luci-app-adguardhome
#sed -i '/resolvfile=/d' package/diy/luci-app-adguardhome/root/etc/init.d/AdGuardHome
#sed -i 's/DEPENDS:=/DEPENDS:=+AdGuardHome /g' package/diy/luci-app-adguardhome/Ma

#kiddin9大神
#svn co  https://github.com/kiddin9/openwrt-bypass/luci-app-bypass package/diy/luci-app-bypass
#git clone --depth 1 https://github.com/kiddin9/luci-app-dnsfilter package/diy/luci-app-dnsfilter

#pymumu大神（18.06是lede的branch）
git clone -b lede https://github.com/pymumu/luci-app-smartdns.git package/diy/luci-app-smartdns
git clone https://github.com/pymumu/openwrt-smartdns.git package/diy/smartdns

#svn co  https://github.com/jerrykuku/luci-app-ttnode package/diy/luci-app-ttnode

#argon主题
git clone -b 18.06 https://github.com/jerrykuku/luci-theme-argon.git package/diy/luci-theme-argon

#重启计划
svn co https://github.com/sirpdboy/diy/trunk/luci-app-rebootschedule package/diy/luci-app-rebootschedule

#增加固件源码来源（只适合luci18系列，即E和N以及D系列.lienol源码只能用lean的，lean的只能用immortalwrt）
rm -Rf feeds/other/lean/autocore
#svn co https://github.com/coolsnowwolf/lede/trunk/package/lean/autocore package/diy/autocore
#sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:固件源码%></td><td><a href="https://github.com/lienol/openwrt"><%:感谢Lienol大神对OpenWrt的开源贡献！%></a></td></tr>' package/diy/autocore/files/x86/index.htm

svn export --force https://github.com/immortalwrt/immortalwrt/branches/openwrt-18.06/package/emortal/autocore package/diy/autocore
sed -i '/Load Average/i\\t\t<tr><td width="33%"><%:固件源码%></td><td><a href="https://github.com/lienol/openwrt"><%:感谢Lienol大神对OpenWrt的开源贡献！%></a></td></tr>' package/diy/autocore/files/generic/index.htm
  

#git clone https://github.com/destan19/OpenAppFilter.git package/diy/OpenAppFilter

# 京东签到 By Jerrykuku
git clone --depth 1 https://github.com/jerrykuku/node-request.git package/new/node-request
git clone --depth 1 https://github.com/jerrykuku/luci-app-jd-dailybonus.git package/new/luci-app-jd-dailybonus

# 网易云音乐解锁
#git clone -b js --depth 1 https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/new/UnblockNeteaseMusic
git clone https://github.com/UnblockNeteaseMusic/luci-app-unblockneteasemusic.git package/new/UnblockNeteaseMusic

#管控
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-webrestriction package/diy/luci-app-control-webrestriction
#svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-timewol package/diy/luci-app-control-timewol无法运行
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-control-weburl package/diy/luci-app-control-weburl
svn export --force https://github.com/Lienol/openwrt-package/trunk/luci-app-timecontrol package/diy/luci-app-timecontrol



#svn co https://github.com/brvphoenix/wrtbwmon/trunk/wrtbwmon package/wrtbwmon
#svn co https://github.com/brvphoenix/luci-app-wrtbwmon/trunk/luci-app-wrtbwmon package/luci-app-wrtbwmon

#svn export --force https://github.com/kiddin9/openwrt-packages/branches/luci18/luci-app-openclash package/diy/luci-app-openclash
#svn export --force https://github.com/kiddin9/openwrt-packages/ruby  package/diy/ruby 
#svn export --force https://github.com/kiddin9/openwrt-packages/ruby-yaml package/diy/ruby-yaml

svn co https://github.com/kiddin9/openwrt-packages/trunk/r8101  package/diy/r8101
svn co https://github.com/kiddin9/openwrt-packages/trunk/r8101  package/diy/r8125
svn co https://github.com/kiddin9/openwrt-packages/trunk/r8168  package/diy/r8168 
svn co https://github.com/kiddin9/openwrt-packages/trunk/rtl8821cu package/diy/rtl8821cu
svn co https://github.com/kiddin9/openwrt-packages/trunk/rtl88x2bu  package/diy/rtl88x2bu 


#克隆passwall
svn export --force https://github.com/xiaorouji/openwrt-passwall/branches/luci package/diy/
sed -i '$a src-git diy https://github.com/xiaorouji/openwrt-passwall' feeds.conf.default

./scripts/feeds update -a
./scripts/feeds install -a
./scripts/feeds install -a


# 内核显示增加自己个性名称(21.3.2 %y : 年份的最后两位数字)
date=`date +%y.%m.%d`
sed -i "s/DISTRIB_DESCRIPTION.*/DISTRIB_DESCRIPTION='YAOF N%C From Lienol Openwrt %V'/g" package/base-files/files/etc/openwrt_release
sed -i "s/# REVISION:=x/REVISION:= $date/g" include/version.mk

#!/bin/bash

# 添加 nikki feed（提供 luci-app-nikki）
grep -qF 'src-git nikki' feeds.conf.default || \
  echo "src-git nikki https://github.com/nikkinikki-org/OpenWrt-nikki.git;main" >> feeds.conf.default

# 更新 feeds
./scripts/feeds update -a

# 克隆自定义包：晶晨宝盒（安装到 eMMC / 在线升级 / 在线更新内核）
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/luci-app-amlogic || true

# HomeProxy：使用 VIKINGYFY/packages 的源码（覆盖 feeds 自带版本）
rm -rf /tmp/viking-packages package/luci-app-homeproxy
git clone --depth=1 https://github.com/VIKINGYFY/packages /tmp/viking-packages
cp -r /tmp/viking-packages/luci-app-homeproxy package/luci-app-homeproxy
rm -rf /tmp/viking-packages

# 安装 feeds
./scripts/feeds install -a

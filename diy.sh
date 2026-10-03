#!/bin/bash
set -e

# 更新 feeds
./scripts/feeds update -a

# 克隆自定义包：晶晨宝盒（安装到 eMMC / 在线升级 / 在线更新内核）
git clone --depth=1 https://github.com/ophub/luci-app-amlogic package/luci-app-amlogic || true

# HomeProxy：使用 VIKINGYFY/packages 的源码（覆盖 feeds 自带版本）
# homeproxy 要求 sing-box>=1.14.0，软件源自带的太旧，所以 sing-box 也一起换成 VIKINGYFY 的版本
rm -rf /tmp/viking-packages package/luci-app-homeproxy package/sing-box
git clone --depth=1 https://github.com/VIKINGYFY/packages /tmp/viking-packages
cp -r /tmp/viking-packages/luci-app-homeproxy package/luci-app-homeproxy
cp -r /tmp/viking-packages/sing-box package/sing-box
rm -rf /tmp/viking-packages

# HomeProxy 补丁集：redirect/tproxy 改造 + 防火墙去重 + 原子回滚 + cn_ip 免重启
# 补丁集放在 $GITHUB_WORKSPACE/homeproxy-rt/（随构建包一起上传）
HP_RT="$GITHUB_WORKSPACE/homeproxy-rt"
if [ -d "$HP_RT" ]; then
  echo "Applying HomeProxy patch set from $HP_RT ..."
  sh "$HP_RT/apply-patches.sh" package/luci-app-homeproxy
else
  echo "WARNING: homeproxy-rt patch set not found at $HP_RT, building unpatched HomeProxy" >&2
fi

# 安装 feeds
./scripts/feeds install -a

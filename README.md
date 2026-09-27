# N1 ImmortalWrt 固件（VIKINGYFY 源码，主路由 PPPoE 版）

用 GitHub Actions 自动编译、打包斐讯 N1 固件。源码：VIKINGYFY/immortalwrt（`owrt` 分支，多平台通用）。

## 默认配置

- 模式：主路由，WAN 口 PPPoE 拨号（首次开机后在 LuCI「网络 → 接口 → WAN → 编辑」里填宽带账号密码）
- LAN：192.168.1.1，DHCP 服务器已开启
- IPv6：已开启（DHCPv6 / RA）
- 无线：已关闭（N1 本来也不用 WiFi）
- 自带插件：luci-app-amlogic（晶晨宝盒：安装到 eMMC、在线升级固件、在线更新内核）、luci-app-filemanager（文件管理）、luci-app-nikki、luci-app-homeproxy（源码取自 VIKINGYFY/packages，非 feeds 自带版本）
- 打包：ophub 工具，板型 s905d，内核 ophub/kernel 的 flippy 6.12.y（和你现在用的一致）
- 默认账户 root，密码 password

## 使用步骤

1. 在 GitHub 新建一个**公开**仓库（private 仓库的 Actions 有时长限制，公开仓库免费无限）。
2. 把本目录下**所有文件**（含 `.github`、`.config` 等隐藏文件/目录）原样上传到仓库根目录，保持目录结构。
3. 修改 `files/etc/config/amlogic` 里 `amlogic_firmware_repo` 的值，改成你这个仓库的地址（格式 `https://github.com/你的用户名/你的仓库名`），否则以后「在线升级」找不到固件。
4. 去仓库 **Settings → Actions → General**：
   - 确认 Actions 已启用；
   - **Workflow permissions** 选 **Read and write permissions**（否则发布 Release 会失败）。
5. 去仓库 **Actions** 页面，左侧选「Build VIKINGYFY-ImmortalWrt for N1」，点 **Run workflow** 手动触发。之后每周日会自动编一次。
6. 编译约需 1～3 小时（GitHub 服务器）。完成后去 **Releases** 页面下载 `*.img.gz`。

## 刷机

1. 用 Rufus（或 balenaEtcher）把 `.img.gz` 解压后的 `.img` 写入 U 盘。
2. N1 插 U 盘通电从 U 盘启动。
3. 浏览器进 192.168.1.1（root / password），先在 WAN 接口填好宽带账号密码确认能拨号上网。
4. 用「晶晨宝盒」把系统安装到 eMMC（可选）。

## 文件说明

| 文件 | 作用 |
|---|---|
| `.github/workflows/N1.yml` | Actions 自动编译+打包流程 |
| `.config` | 编译配置（目标 armsr/armv8，只输出 rootfs tar.gz） |
| `diy.sh` | 添加 nikki 软件源、克隆晶晨宝盒 |
| `files/` | 刷进固件的默认配置文件（网络/DHCP/防火墙/晶晨宝盒等） |

## 注意

- WAN 和 LAN 共用 N1 唯一的 eth0 口（单臂），这是 N1 做主路由的常规接法。
- PPPoE 拨号另需要 `ppp`、`ppp-mod-pppoe`，已编进固件。
- 想加减插件：改 `.config` 里 `CONFIG_PACKAGE_luci-app-xxx=y` 的行，重新触发 workflow 即可。

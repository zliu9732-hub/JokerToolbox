#!/bin/bash

# ==========================================
# 颜色定义
# ==========================================
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[0;33m'
BLUE='\033[0;34m'
PURPLE='\033[0;35m'
NC='\033[0m' 

# ==========================================
# 自动创建桌面快捷方式 & 下载专属高清图标 (JPG版)
# ==========================================
DECK_DESKTOP="/home/deck/Desktop"
SHORTCUT_PATH="${DECK_DESKTOP}/周克儿工具箱.desktop"
ICON_DIR="/home/deck/.jokertoolbox"
ICON_PATH="${ICON_DIR}/icon.jpg"

if [ -d "$DECK_DESKTOP" ]; then
    mkdir -p "$ICON_DIR"
    if [ ! -f "$ICON_PATH" ]; then
        curl -sL "https://raw.githubusercontent.com/zliu9732-hub/JokerToolbox/main/icon.jpg" -o "$ICON_PATH"
    fi

    if [ ! -f "$SHORTCUT_PATH" ]; then
        cat << TEXT > "$SHORTCUT_PATH"
[Desktop Entry]
Name=周克儿工具箱
Comment=周克儿出品 Steam Deck 实用工具箱
Exec=bash -c "curl -sL https://ourl.cn/CFmKpd | bash"
Icon=${ICON_PATH}
Terminal=true
Type=Application
Categories=Utility;
TEXT
        chmod +x "$SHORTCUT_PATH"
    fi
fi

# ==========================================
# 免责声明弹窗
# ==========================================
show_disclaimer() {
    clear
    echo -e "${RED}==================================================${NC}"
    echo -e "${RED}                ⚠️ 免 责 声 明 ⚠️                ${NC}"
    echo -e "${RED}==================================================${NC}"
    echo -e "${YELLOW}1. 本工具箱由【周克儿】制作，仅供技术交流与便利使用。${NC}"
    echo -e "${YELLOW}2. 本工具涉及系统底层修改（如解锁只读、双系统引导修复等），${NC}"
    echo -e "${YELLOW}   操作均具有潜在风险，请在执行前自行备份重要数据。${NC}"
    echo -e "${YELLOW}3. 凡因用户自身误操作、掌机硬件老化故障、官方系统更新${NC}"
    echo -e "${YELLOW}   不兼容等任何第三方原因导致的设备损坏、数据丢失、${NC}"
    echo -e "${YELLOW}   系统崩溃或经济损失，本工具及作者不承担任何法律${NC}"
    echo -e "${YELLOW}   及经济赔偿责任。${NC}"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${GREEN}👉 凡运行、使用本工具箱者，即视为您已完全知晓并自愿${NC}"
    echo -e "${GREEN}   接受本声明的所有条款。如有异议，请立即关闭本窗口。${NC}"
    echo -e "${RED}==================================================${NC}"
    echo -n "如果您已阅读并同意上述声明，请按任意键进入工具箱..."
    read -n 1 < /dev/tty
}

# ==========================================
# 主菜单界面
# ==========================================
show_menu() {
    clear
    echo -e "${BLUE}==================================================${NC}"
    echo -e "${GREEN}               欢迎使用 周克儿工具箱 v0.3          ${NC}"
    echo -e "${BLUE}==================================================${NC}"
    echo -e "${YELLOW}  1.${NC} 🚀 一键网络加速 (含 Flatpak 国内源优化)"
    echo -e "${YELLOW}  2.${NC} 🛠️  修复双系统引导"
    echo -e "${YELLOW}  3.${NC} 🔓 解除系统只读锁定"
    echo -e "${YELLOW}  4.${NC} 🧹 深度清理着色器缓存"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${YELLOW}  5.${NC} 📂 高速下载【百度网盘】 (Flatpak完全体)"
    echo -e "${YELLOW}  6.${NC} 🖥️  高速下载【RustDesk】"
    echo -e "${YELLOW}  7.${NC} 🔑 一键修改系统密码 (自动备份到桌面)"
    echo -e "${YELLOW}  Q.${NC} 🚪 退出工具箱"
    echo -e "${BLUE}==================================================${NC}"
    echo -n "请输入选项 [1-7 或 Q]: "
}

# ==========================================
# 执行流程控制
# ==========================================
show_disclaimer

while true; do
    show_menu
    read choice < /dev/tty
    case $choice in
        1)
            echo -e "\n${GREEN}[开始执行] 正在配置系统网络双重加速...${NC}"
            sudo steamos-readonly disable
            sudo sed -i '/githubusercontent/d' /etc/hosts
            echo "185.199.108.133 raw.githubusercontent.com" | sudo tee -a /etc/hosts > /dev/null
            echo "185.199.109.133 raw.githubusercontent.com" | sudo tee -a /etc/hosts > /dev/null
            sudo steamos-readonly enable
            
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
            flatpak update --appstream -y > /dev/null 2>&1
            
            echo -e "${GREEN}✓ 双重加速配置完成！GitHub 与 Flatpak 商店下载已全面提速。${NC}"
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;
            
        2)
            echo -e "\n${GREEN}[开始执行] 正在检测并修复双系统引导...${NC}"
            if [ -d "/boot/efi" ]; then
                echo -e "${YELLOW}正在重新向主板写入 SteamOS 启动项...${NC}"
                sudo efibootmgr -c -d /dev/nvme0n1 -p 1 -L "SteamOS" -l "\\EFI\\steamos\\steamcl.efi" > /dev/null 2>&1
                echo -e "${GREEN}✓ 引导修复成功！重新启动掌机按住减号音量键即可看到 SteamOS 选项。${NC}"
            else
                echo -e "${RED}❌ 错误：未检测到标准的 EFI 分区，请确保在 SteamOS 桌面模式下运行！${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;
            
        3)
            echo -e "\n${GREEN}[开始执行] 系统只读权限管理...${NC}"
            echo -e "${PURPLE}1)${NC} 一键【解除锁定】"
            echo -e "${PURPLE}2)${NC} 一键【恢复锁定】"
            echo -n "请选择操作 [1-2]: "
            read ro_choice < /dev/tty
            if [ "$ro_choice" = "1" ]; then
                sudo steamos-readonly disable
                sudo pacman-key --init > /dev/null 2>&1
                sudo pacman-key --populate archlinux > /dev/null 2>&1
                echo -e "${GREEN}✓ 系统已完美解锁！现在你可以自由折腾底层软件了。${NC}"
            elif [ "$ro_choice" = "2" ]; then
                sudo steamos-readonly enable
                echo -e "${GREEN}✓ 系统已重新恢复只读锁定。${NC}"
            else
                echo -e "${RED}无效输入。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;
            
        4)
            echo -e "\n${GREEN}[开始执行] 深度清理着色器缓存...${NC}"
            SHADER_DIR="/home/deck/.local/share/Steam/steamapps/shadercache"
            if [ -d "$SHADER_DIR" ]; then
                CACHE_SIZE=$(du -sh "$SHADER_DIR" | awk '{print $1}')
                echo -e "${YELLOW}检测到当前着色器缓存共占用：${NC}${RED}$CACHE_SIZE${NC}"
                echo -n "确定要彻底清空它们来释放空间吗？(y/n): "
                read confirm < /dev/tty
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    echo -e "${YELLOW}正在强力粉碎缓存垃圾...${NC}"
                    rm -rf "$SHADER_DIR"/*
                    echo -e "${GREEN}✓ 清理完毕！成功为你腾出 $CACHE_SIZE 的宝贵空间！${NC}"
                else
                    echo -e "${YELLOW}已取消清理。${NC}"
                fi
            else
                echo -e "${RED}❌ 未找到着色器缓存目录。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;

        5)
            echo -e "\n${GREEN}[开始执行] 正在通过 Flatpak 官方通道部署百度网盘...${NC}"
            echo -e "${YELLOW}正在配置上海交通大学 Flatpak 国内高速镜像源...${NC}"
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            flatpak remote-modify flathub --url=https://mirror.sjtu.edu.cn/flathub
            
            echo -e "${YELLOW}正在强行拉取并同步最新的国内仓软件商品清单...${NC}"
            flatpak update --appstream -y
            
            echo -e "${YELLOW}正在从国内高速仓安全拉取最新的百度网盘，请稍候...${NC}"
            flatpak install flathub com.baidu.BaiduNetdisk --user --noninteractive -y
            
            if [ $? -eq 0 ]; then
                echo -e "${YELLOW}安装成功！正在为您自动提取并创建桌面快捷方式...${NC}"
                SYS_DESKTOP="/var/lib/flatpak/exports/share/applications/com.baidu.BaiduNetdisk.desktop"
                USER_DESKTOP="/home/deck/.local/share/flatpak/exports/share/applications/com.baidu.BaiduNetdisk.desktop"
                
                if [ -f "$USER_DESKTOP" ]; then
                    cp "$USER_DESKTOP" /home/deck/Desktop/百度网盘.desktop
                elif [ -f "$SYS_DESKTOP" ]; then
                    cp "$SYS_DESKTOP" /home/deck/Desktop/百度网盘.desktop
                else
                    cat << TEXT > /home/deck/Desktop/百度网盘.desktop
[Desktop Entry]
Name=百度网盘
Comment=Baidu Netdisk Flatpak
Exec=flatpak run com.baidu.BaiduNetdisk
Icon=network-workgroup
Terminal=false
Type=Application
Categories=Network;
TEXT
                fi
                chmod +x /home/deck/Desktop/百度网盘.desktop
                echo -e "${GREEN}✓ 百度网盘（原生沙盒版）已完美落地！已发送到【掌机桌面】！${NC}"
            else
                echo -e "${RED}❌ 安装失败，请检查掌机网络是否可以正常上网。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;

        6)
            echo -e "\n${GREEN}[开始执行] 正在通过国内高速通道下载 RustDesk...${NC}"
            echo -e "${YELLOW}提示: 正在从123云盘抽取数据，请稍候...${NC}"
            
            RUSTDESK_LINK="https://1846467258.cdn.123clouddisk.com/1846467258/%E8%A7%86%E9%A2%91/rustdesk-1.4.8-x86_64.AppImage"
            curl -L -o /home/deck/Desktop/远程协助.AppImage "$RUSTDESK_LINK"
            
            if [ $? -eq 0 ] && [ -f "/home/deck/Desktop/远程协助.AppImage" ]; then
                chmod +x /home/deck/Desktop/远程协助.AppImage
                
                echo -e "${YELLOW}正在自动配置周克儿专属高清、零延迟自建服务器通道...${NC}"
                mkdir -p /home/deck/.config/rustdesk
                cat << CONFIG_EOF > /home/deck/.config/rustdesk/RustDesk.toml
id-server = '293035.xyz:48845'
relay-server = '293035.xyz:48846'
api-server = 'http://293035.xyz:48843'
key = '2Vx42GidjDLgp0kT5akymxN3BjXSOLH0QQuhe2TAS4g='
custom-rendezvous-server = '293035.xyz:48845'
CONFIG_EOF
                
                echo -e "${GREEN}✓ 下载完成！服务器参数已自动注入，直接打开把ID发给客服即可！${NC}"
            else
                echo -e "${RED}❌ 下载失败，请检查123云盘直链是否有效。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;

        7)
            echo -e "\n${GREEN}[开始执行] 正在准备修改系统密码...${NC}"
            echo -e "${YELLOW}提示: 建议设置简单的纯数字或英文（例如：123456），方便以后输入。${NC}"
            echo -n "请输入您想设置的新密码: "
            
            # 使用标准的 read 接收买家输入的自定义密码
            read new_pwd < /dev/tty
            
            if [ -z "$new_pwd" ]; then
                echo -e "${RED}❌ 密码不能为空，已取消修改。${NC}"
            else
                echo -e "${YELLOW}正在通过系统底层强行重置并注入新密码...${NC}"
                # 📌 核心底层逻辑：使用 chpasswd 强行暴力重写 deck 用户的系统密码
                echo "deck:$new_pwd" | sudo chpasswd
                
                if [ $? -eq 0 ]; then
                    # 📌 核心联动需求：自动在桌面创建或覆盖密码备份文本
                    PWD_FILE="/home/deck/Desktop/密码.txt"
                    cat << PWD_EOF > "$PWD_FILE"
==================================================
        周克儿工具箱 - 您的系统密码备份
==================================================
您的 Steam Deck 系统密码 (sudo 密码) 已成功修改为：

👉  $new_pwd

提示：以后在工具箱运行需要最高权限的功能（如解锁只读），
或者在 Linux 终端使用 sudo 命令时，请输入上面这个密码。
（注：在 Linux 终端里输入密码时，屏幕上不会显示任何东西，
这是正常保护机制，输完直接按回车即可！）
==================================================
PWD_EOF
                    echo -e "${GREEN}✓ 系统密码已成功修改为：$new_pwd ${NC}"
                    echo -e "${GREEN}✓ 贴心防护包已落地：【掌机桌面】->【密码.txt】已同步更新！${NC}"
                else
                    echo -e "${RED}❌ 密码修改失败，请确保您在 SteamOS 官方系统环境下运行。${NC}"
                fi
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1 < /dev/tty
            ;;
            
        q|Q)
            echo -e "\n${YELLOW}感谢使用周克儿工具箱，祝您游戏愉快！再见。${NC}\n"
            exit 0
            ;;
            
        *)
            echo -e "\n${RED}输入错误，请输入 1-7 的数字或 Q！${NC}"
            sleep 1
            ;;
    esac
done

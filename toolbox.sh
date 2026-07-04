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
    echo -e "${YELLOW}  1.${NC} 🚀 一键网络加速"
    echo -e "${YELLOW}  2.${NC} 🛠️  修复双系统引导"
    echo -e "${YELLOW}  3.${NC} 🔓 解除系统只读锁定"
    echo -e "${YELLOW}  4.${NC} 🧹 深度清理着色器缓存"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${YELLOW}  5.${NC} 📂 高速下载【百度网盘】"
    echo -e "${YELLOW}  6.${NC} 🖥️  高速下载【RustDesk】"
    echo -e "${YELLOW}  Q.${NC} 🚪 退出工具箱"
    echo -e "${BLUE}==================================================${NC}"
    echo -n "请输入选项 [1-6 或 Q]: "
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
            echo -e "\n${GREEN}[开始执行] 正在配置网络加速...${NC}"
            sudo steamos-readonly disable
            sudo sed -i '/githubusercontent/d' /etc/hosts
            echo "185.199.108.133 raw.githubusercontent.com" | sudo tee -a /etc/hosts > /dev/null
            echo "185.199.109.133 raw.githubusercontent.com" | sudo tee -a /etc/hosts > /dev/null
            sudo steamos-readonly enable
            echo -e "${GREEN}✓ GitHub Hosts 加速节点已注入！后续下载脚本将大幅提速。${NC}"
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
                echo -e "${YELLOW}正在初始化系统的软件包密钥(Pacman Keys)...${NC}"
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
            echo -e "\n${GREEN}[开始执行] 正在通过国内高速通道下载百度网盘...${NC}"
            echo -e "${YELLOW}提示: 正在从123云盘极速抽取官方数据，请稍候...${NC}"
            
            BAIDU_LINK="https://1846467258.cdn.123clouddisk.com/1846467258/%E8%A7%86%E9%A2%91/baidunetdisk_8.5.2_amd64.deb"
            
            mkdir -p /tmp/joker_baidu
            curl -L -o /tmp/joker_baidu/baidu.deb "$BAIDU_LINK"
            
            if [ $? -eq 0 ] && [ -f "/tmp/joker_baidu/baidu.deb" ]; then
                echo -e "${YELLOW}正在在买家个人目录部署免安装绿色版环境...${NC}"
                TARGET_DIR="/home/deck/.local/share/baidunetdisk"
                mkdir -p "$TARGET_DIR"
                rm -rf "$TARGET_DIR"/*
                cd "$TARGET_DIR"
                
                bsdtar -xf /tmp/joker_baidu/baidu.deb
                
                # 📌 终极绝杀：强力补齐对 image_7.png 里看到的 data.tar.bz2 格式的完美支持！
                if [ -f "data.tar.bz2" ]; then
                    bsdtar -xf data.tar.bz2
                elif [ -f "data.tar.zst" ]; then
                    bsdtar -xf data.tar.zst
                elif [ -f "data.tar.xz" ]; then
                    bsdtar -xf data.tar.xz
                elif [ -f "data.tar.gz" ]; then
                    bsdtar -xf data.tar.gz
                fi
                
                if [ -f "${TARGET_DIR}/opt/baidunetdisk/baidunetdisk" ]; then
                    chmod +x "${TARGET_DIR}/opt/baidunetdisk/baidunetdisk"
                fi
                
                cat << TEXT > /home/deck/Desktop/百度网盘.desktop
[Desktop Entry]
Name=百度网盘
Exec="${TARGET_DIR}/opt/baidunetdisk/baidunetdisk" --no-sandbox
Icon=network-workgroup
Terminal=false
Type=Application
Categories=Network;
TEXT
                chmod +x /home/deck/Desktop/百度网盘.desktop
                rm -rf /tmp/joker_baidu
                echo -e "${GREEN}✓ 百度网盘已完美转换为绿色版，并发送到【掌机桌面】！${NC}"
            else
                echo -e "${RED}❌ 下载失败，请检查123云盘的 deb 直链是否有效。${NC}"
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
            
        q|Q)
            echo -e "\n${YELLOW}感谢使用周克儿工具箱，祝您游戏愉快！再见。${NC}\n"
            exit 0
            ;;
            
        *)
            echo -e "\n${RED}输入错误，请输入 1-6 的数字或 Q！${NC}"
            sleep 1
            ;;
    esac
done

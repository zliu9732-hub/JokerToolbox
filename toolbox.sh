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
# 主菜单界面
# ==========================================
show_menu() {
    clear
    echo -e "${BLUE}==================================================${NC}"
    echo -e "${GREEN}          欢迎使用 周克儿 终极技术工具箱 v0.2     ${NC}"
    echo -e "${BLUE}==================================================${NC}"
    echo -e "${YELLOW}  1.${NC} 🚀 一键网络加速 (优化 GitHub & 脚本下载速度)"
    echo -e "${YELLOW}  2.${NC} 🛠️  修复双系统引导 (专治 Windows 更新后找不到 SteamOS)"
    echo -e "${YELLOW}  3.${NC} 🔓 解除系统只读锁定 (开启 Arch Linux 软件安装权限)"
    echo -e "${YELLOW}  4.${NC} 🧹 深度清理着色器缓存 (一键释放十几G固态硬盘空间)"
    echo -e "${BLUE}--------------------------------------------------${NC}"
    echo -e "${YELLOW}  5.${NC} 📂 一键安装【百度网盘】(方便下载游戏网盘资源)"
    echo -e "${YELLOW}  6.${NC} 🖥️  一键安装【RustDesk】(远程协助神器，方便连线调试)"
    echo -e "${YELLOW}  Q.${NC} 🚪 退出工具箱"
    echo -e "${BLUE}==================================================${NC}"
    echo -n "请输入选项 [1-6 或 Q]: "
}

# ==========================================
# 核心功能实现
# ==========================================
while true; do
    show_menu
    read choice
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
            read -n 1
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
            read -n 1
            ;;
            
        3)
            echo -e "\n${GREEN}[开始执行] 系统只读权限管理...${NC}"
            echo -e "${PURPLE}1)${NC} 一键【解除锁定】(解锁后可使用 pacman 安装各种 Arch Linux 软件)"
            echo -e "${PURPLE}2)${NC} 一键【恢复锁定】(让系统回归官方原生安全状态)"
            echo -n "请选择操作 [1-2]: "
            read ro_choice
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
                echo -e "${RED}无效输入. ${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1
            ;;
            
        4)
            echo -e "\n${GREEN}[开始执行] 深度清理着色器缓存...${NC}"
            SHADER_DIR="/home/deck/.local/share/Steam/steamapps/shadercache"
            if [ -d "$SHADER_DIR" ]; then
                CACHE_SIZE=$(du -sh "$SHADER_DIR" | awk '{print $1}')
                echo -e "${YELLOW}检测到当前着色器缓存（Shader Cache）共占用：${NC}${RED}$CACHE_SIZE${NC}"
                echo -n "确定要彻底清空它们来释放固态硬盘空间吗？(y/n): "
                read confirm
                if [[ "$confirm" == "y" || "$confirm" == "Y" ]]; then
                    echo -e "${YELLOW}正在强力粉碎缓存垃圾...${NC}"
                    rm -rf "$SHADER_DIR"/*
                    echo -e "${GREEN}✓ 清理完毕！成功为你腾出 $CACHE_SIZE 的宝贵空间！${NC}"
                else
                    echo -e "${YELLOW}已取消清理。${NC}"
                fi
            else
                echo -e "${RED}❌ 未找到着色器缓存目录，可能你已经清理过，或者使用的是不产生缓存的系统版本。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1
            ;;

        5)
            echo -e "\n${GREEN}[开始执行] 正在安装百度网盘...${NC}"
            echo -e "${YELLOW}提示: 正在从 Flathub 官方源下载并部署百度网盘，这可能需要一点时间，请保持网络畅通...${NC}"
            flatpak install -y flathub com.baidu.BaiduNetdisk
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ 百度网盘安装成功！你可以在应用菜单的「Internet (互联网)」分类里找到它。${NC}"
            else
                echo -e "${RED}❌ 安装失败，请检查网络连接是否正常，或重试。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1
            ;;

        6)
            echo -e "\n${GREEN}[开始执行] 正在安装 RustDesk 远程协助工具...${NC}"
            echo -e "${YELLOW}提示: 正在下载远程协助组件，部署完成后打开即可将 ID 发给技术客服进行远程连线...${NC}"
            flatpak install -y flathub com.rustdesk.RustDesk
            if [ $? -eq 0 ]; then
                echo -e "${GREEN}✓ RustDesk 安装成功！已成功创建桌面快捷方式与应用菜单图标。${NC}"
            else
                echo -e "${RED}❌ 安装失败，请检查网络连接是否正常，或重试。${NC}"
            fi
            echo -e "${YELLOW}按任意键返回主菜单...${NC}"
            read -n 1
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

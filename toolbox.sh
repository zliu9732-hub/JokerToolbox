#!/bin/bash

# 定义颜色
GREEN='\033[0;32m'
BLUE='\033[0;34m'
RED='\033[0;31m'
NC='\033[0m'

# 1. 查看系统信息
show_system_info() {
    clear
    echo -e "${BLUE}=========================================${NC}"
    echo -e "           Steam Deck 系统信息           "
    echo -e "${BLUE}=========================================${NC}"
    
    # 智能检查是否在 Steam 掌机上
    if [ -f /etc/os-release ] && grep -q "steamdeck" /etc/os-release; then
        echo -e "  设备类型: ${GREEN}检测到 Steam Deck 掌机${NC}"
        echo "  系统版本: $(grep "VERSION_ID" /etc/os-release | cut -d= -f2 | tr -d '"')"
    else
        echo -e "  设备类型: 非 Steam Deck 设备 (当前为 Mac 开发机)"
    fi
    
    echo "  当前用户: $(whoami)"
    echo "  内核版本: $(uname -r)"
    echo -e "${BLUE}=========================================${NC}"
    read -p "按回车键返回主菜单..."
}

# 2. 模拟安装百度网盘
install_baidu() {
    clear
    echo "正在通过 Flatpak 为 Steam Deck 安装【百度网盘】..."
    echo "提示：由于当前是 Mac 开发环境，实际安装指令将在 SteamOS 上生效。"
    echo "模拟执行: flatpak install --user -y flathub com.baidu.BaiduNetdisk"
    echo -e "${GREEN}模拟环境：预载包加载成功！${NC}"
    read -p "按回车键返回..."
}

# 3. 模拟安装 RustDesk
install_rustdesk() {
    clear
    echo "正在通过 Flatpak 为 Steam Deck 安装远程工具【RustDesk】..."
    echo "模拟执行: flatpak install --user -y flathub com.rustdesk.RustDesk"
    echo -e "${GREEN}模拟环境：功能逻辑正常！${NC}"
    read -p "按回车键返回..."
}

# 主菜单
main_menu() {
    while true; do
        clear
        echo "========================================="
        echo "          闲鱼周克儿工具箱 v0.1          "
        echo "========================================="
        echo ""
        echo " 1. 查看系统信息"
        echo " 2. 安装百度网盘 (开发中)"
        echo " 3. 安装 RustDesk (开发中)"
        echo " 4. 设置"
        echo " 0. 退出"
        echo ""
        echo "========================================="
        echo ""
        read -p "请输入：" choice

        case $choice in
            1) show_system_info ;;
            2) install_baidu ;;
            3) install_rustdesk ;;
            4) 
                clear
                echo "设置功能开发中..."
                read -p "按回车返回..."
                ;;
            0)
                echo "退出工具箱，感谢使用！"
                exit 0
                ;;
            *)
                echo -e "${RED}无效输入！${NC}"
                sleep 1
                ;;
        esac
    done
}

# 启动
main_menu



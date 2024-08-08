#!/bin/bash

# Print the welcome message
echo "-------自己使用-------"


# Function to show the menu
show_menu() {
    echo "请选择一个选项，请用root用户操作："
    echo "1. 一键挖矿"
    echo "2. 查看挖矿状态"
    echo "3. 显示钱包"
    echo "4. 停止挖矿"
    echo "5. 退出"
    echo -n "输入选项 [1-5]: "
}

# Function to start mining
start_mining() {
    echo "开始一键挖矿..."
    read -p "请输入线程数: " threads
    read -p "请输入GAS费用: " gas
    read -p "请选择RPC节点（1：默认，2：自定义）" rpc_choice
    case $rpc_choice in
        1)
            rpc_node="http://api.mainnet-beta.solana.com"
            ;;
        2)
            read -p "请输入自定义RPC节点: " rpc_node
            ;;
        *)
            echo "无效的选项，请重试..."
            exit 1
            ;;
    esac
    apt update -y
    apt install screen -y
    pkill -9 screen
    screen -wipe

    # Start mining in the background and redirect output to ~/output.log
    screen -S ore ore --rpc "$rpc_node" --keypair ~/.config/solana/id.json --priority-fee "$gas" mine --threads "$threads"
}



# Function to check mining status
check_mining_status() {
    echo "查看挖矿状态..."
    screen -r ore
}

# Function to claim rewards
claim_rewards() {
    echo "钱包地址..."
    solana-keygen pubkey /root/.config/solana/id.json
}


# Function to stop mining
stop_mining() {
    echo "停止挖矿..."
    pkill -9 screen
	screen -wipe
}

# Main loop
while true; do
    show_menu
    read -r CHOICE
    case $CHOICE in
        1)
            start_mining
            ;;
        2)
            check_mining_status
            ;;

        3)
            claim_rewards
            ;;
        4)
            stop_mining
            ;;
        5)
            echo "退出脚本..."
            break
            ;;
        *)
            echo "无效的选项，请重试..."
            ;;
    esac
done
clear

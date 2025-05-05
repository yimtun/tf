#!/bin/bash

# 导出为 JSON 格式
echo "Exporting outputs to JSON..."
terraform output -json > outputs.json
echo "JSON outputs saved to outputs.json"

# 检查是否安装了 yq
if command -v yq &> /dev/null; then
    # 导出为 YAML 格式
    echo "Exporting outputs to YAML..."
    terraform output -json | yq -P > outputs.yaml
    echo "YAML outputs saved to outputs.yaml"
else
    echo "yq is not installed. Installing yq..."
    # 对于 macOS
    if [[ "$OSTYPE" == "darwin"* ]]; then
        brew install yq
    # 对于 Linux
    elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
        wget https://github.com/mikefarah/yq/releases/latest/download/yq_linux_amd64 -O /usr/local/bin/yq
        chmod +x /usr/local/bin/yq
    fi
    
    # 安装后再次尝试导出 YAML
    echo "Exporting outputs to YAML..."
    terraform output -json | yq -P > outputs.yaml
    echo "YAML outputs saved to outputs.yaml"
fi 
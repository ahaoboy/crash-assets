#!/bin/bash

mihomo_files=(
    "mihomo-1.19.15-windows-64.zip"
    "mihomo-1.19.15-windows-32.zip"
)
mihomo_tag="v1.19.15"
mihomo_url="https://github.com/MetaCubeX/mihomo/releases/download/$mihomo_tag"

for file in "${mihomo_files[@]}"; do
    echo "Downloading $file..."
    curl -L -O "$mihomo_url/$file"
    if [ $? -eq 0 ]; then
        echo "Downloaded $file successfully."
    else
        echo "Failed to download $file."
    fi
done


zashboard_tag="v1.107.0"
zashboard_url="https://github.com/Zephyruso/zashboard/releases/download/$zashboard_tag/dist.zip"
curl -L -o zashboard.zip "$zashboard_url"


metacubexd_tag="v1.194.0"
metacubexd_url="https://github.com/MetaCubeX/metacubexd/releases/download/$metacubexd_tag/compressed-dist.tgz"
curl -L -o metacubexd.tgz "$metacubexd_url"


yacd_tag="v0.3.8"
yacd_url="https://github.com/haishanh/yacd/releases/download/$yacd_tag/yacd.tar.xz"
curl -L -o yacd.tar.xz "$yacd_url"


echo "All downloads completed."
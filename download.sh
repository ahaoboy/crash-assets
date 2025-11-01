#!/bin/bash

mihomo_files=(
    "mihomo-windows-amd64-v1.19.15.zip"
    "mihomo-linux-amd64-v1.19.15.gz"
    "mihomo-linux-arm64-v1.19.15.gz"
    "mihomo-darwin-arm64-v1.19.15.gz"
    "mihomo-darwin-amd64-v1.19.15.gz"
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

for gzfile in *.gz; do
  [ -e "$gzfile" ] || continue

  base="${gzfile%.gz}"

  gunzip -c "$gzfile" > "$base"

  tar -czf "${base}.tgz" "$base"

  rm -f "$base"
done


geo_files=(
    "geoip.metadb"
    "geoip.dat"
    "geosite.dat"
)
geo_tag="latest"
geo_url="https://github.com/meta-rules-dat/meta-rules-dat/releases/download/$geo_tag"

for file in "${geo_files[@]}"; do
    echo "Downloading $file..."
    curl -L -O "$geo_url/$file"
    if [ $? -eq 0 ]; then
        echo "Downloaded $file successfully."
    else
        echo "Failed to download $file."
    fi
done


echo "All downloads completed."
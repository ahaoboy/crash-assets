#!/bin/bash

# Function to download a file with error checking
download() {
    local url="$1"
    local output="$2"
    echo "Downloading $output from $url..."
    curl -L -o "$output" "$url"
    if [ $? -eq 0 ]; then
        echo "Downloaded $output successfully."
    else
        echo "Failed to download $output."
    fi
}

# Function to process compressed files: decompress and recompress to .tar.xz
process_compressed() {
    local file="$1"
    local ext="${file##*.}"
    local base="${file%.*}"
    local temp_dir="./tmp"
    mkdir -p $temp_dir

    case "$ext" in
        zip)
            unzip "$file" -d "$temp_dir"
            ;;
        gz)
            if [[ "$file" == *.tar.gz ]]; then
                tar -xzf "$file" -C "$temp_dir"
                base="${file%.*.*}"  # Remove .tar.gz
            else
                gunzip -c "$file" > "$temp_dir/$base"
            fi
            ;;
        tgz)
            tar -xzf "$file" -C "$temp_dir"
            base="${file%.*}"  # Remove .tgz
            ;;
        *)
            rm -rf "$temp_dir"
            return
            ;;
    esac

    # Recompress to .tar.xz
    (cd "$temp_dir" && tar -cJf "../${base}.tar.xz" .)
    rm -rf "$temp_dir" "$file"
}

# Function to compress single files to .tar.xz
compress_single() {
    local file="$1"
    tar -cJf "${file}.tar.xz" "$file"
    rm "$file"
}

# Mihomo files
mihomo_files=(
    "mihomo-windows-amd64-v1.19.15.zip"
    "mihomo-linux-amd64-v1.19.15.gz"
    "mihomo-linux-arm64-v1.19.15.gz"
    "mihomo-linux-armv5-v1.19.15.gz"
    "mihomo-darwin-arm64-v1.19.15.gz"
    "mihomo-darwin-amd64-v1.19.15.gz"
)
mihomo_tag="v1.19.15"
mihomo_url="https://github.com/MetaCubeX/mihomo/releases/download/$mihomo_tag"

for file in "${mihomo_files[@]}"; do
    download "$mihomo_url/$file" "$file"
done

clash_files=(
    "clash-linux-386.tar.gz"
    "clash-linux-amd64.tar.gz"
    "clash-linux-arm64.tar.gz"
    "clash-linux-armv5.tar.gz"
    "clash-linux-armv7.tar.gz"
)

for file in "${clash_files[@]}"; do
    clash_url="https://github.com/juewuy/ShellCrash/raw/refs/heads/dev/bin/clash/$file"
    download "$clash_url" "$file"
done

# Zashboard
zashboard_tag="v1.107.0"
zashboard_url="https://github.com/Zephyruso/zashboard/releases/download/$zashboard_tag/dist.zip"
download "$zashboard_url" "zashboard.zip"

# Metacubexd
metacubexd_tag="v1.194.0"
metacubexd_url="https://github.com/MetaCubeX/metacubexd/releases/download/$metacubexd_tag/compressed-dist.tgz"
download "$metacubexd_url" "metacubexd.tgz"

# Yacd (already .tar.xz, no post-processing needed)
yacd_tag="v0.3.8"
yacd_url="https://github.com/haishanh/yacd/releases/download/$yacd_tag/yacd.tar.xz"
download "$yacd_url" "yacd.tar.xz"

# Geo files
geo_files=(
    "geoip.metadb"
    "geoip.dat"
    "geosite.dat"
)
geo_tag="latest"
geo_url="https://github.com/MetaCubeX/meta-rules-dat/releases/download/$geo_tag"

for file in "${geo_files[@]}"; do
    download "$geo_url/$file" "$file"
done

# Post-process compressed files
for file in *.zip *.gz *.tgz *.tar.gz; do
    [ -e "$file" ] || continue
    process_compressed "$file"
done

# Compress single files
for file in *.dat *.metadb; do
    [ -e "$file" ] || continue
    compress_single "$file"
done

echo "All downloads and processing completed."
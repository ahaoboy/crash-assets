#!/bin/bash

# Function to download a file with error checking
download() {
    local url="$1"
    local output="$2"
    echo "Downloading $output from $url..."
    curl -q -sS -L -o "$output" "$url"
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
            unzip -q "$file" -d "$temp_dir"
            ;;
        gz)
            if [[ "$file" == *.tar.gz ]]; then
                tar -xzf "$file" -C "$temp_dir"
                base="${file%.*.*}"  # Remove .tar.gz
            else
                gunzip -q -c "$file" > "$temp_dir/$base"
            fi
            ;;
        tgz)
            tar -xzf "$file" -C "$temp_dir"
            base="${file%.*}"  # Remove .tgz
            ;;
        xz)
            if [[ "$file" == *.tar.xz ]]; then
                tar -xf "$file" -C "$temp_dir"
                base="${file%.*.*}"
            else
              echo not support $file
            fi
            ;;
        *)
            rm -rf "$temp_dir"
            return
            ;;
    esac

    # Recompress to .tar.xz
    cd "$temp_dir"
    tar -czf "../${base}.tar.gz" .
    cd ..
    rm -rf "$temp_dir" "$file"
}

# Function to compress single files to .tar.xz
compress_single() {
    local file="$1"
    tar -czf "${file}.tar.gz" "$file"
    rm "$file"
}

# Mihomo files
mihomo_files=(
    "mihomo-windows-amd64-v1.19.16.zip"
    "mihomo-linux-amd64-v1.19.16.gz"
    "mihomo-linux-arm64-v1.19.16.gz"
    "mihomo-linux-armv5-v1.19.16.gz"
    "mihomo-darwin-arm64-v1.19.16.gz"
    "mihomo-darwin-amd64-v1.19.16.gz"
)
mihomo_tag="v1.19.16"
mihomo_url="https://github.com/MetaCubeX/mihomo/releases/download/$mihomo_tag"

for file in "${mihomo_files[@]}"; do
    download "$mihomo_url/$file" "$file"
done

# singbox files
singbox_files=(
  "sing-box-1.12.12-linux-arm64.tar.gz"
  "sing-box-1.12.12-linux-amd64.tar.gz"
  "sing-box-1.12.12-windows-amd64.zip"
  "sing-box-1.12.12-linux-armv5.tar.gz"
)
singbox_tag="v1.12.12"
singbox_url="https://github.com/SagerNet/sing-box/releases/download/$singbox_tag"

for file in "${singbox_files[@]}"; do
    download "$singbox_url/$file" "$file"
done


# crash files
crash_files=(
    "crash-aarch64-apple-darwin.tar.gz"
    "crash-aarch64-linux-android.tar.gz"
    "crash-aarch64-unknown-linux-gnu.tar.gz"
    "crash-aarch64-unknown-linux-musl.tar.gz"
    "crash-x86_64-apple-darwin.tar.gz"
    "crash-x86_64-pc-windows-msvc.zip"
    "crash-x86_64-pc-windows-gnu.zip"
    "crash-x86_64-unknown-linux-gnu.tar.gz"
    "crash-x86_64-unknown-linux-musl.tar.gz"
)
crash_tag="nightly"
crash_url="https://github.com/ahaoboy/crash/releases/download/${crash_tag}"

for file in "${crash_files[@]}"; do
    download "$crash_url/$file" "$file"
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
    "country.mmdb"
)
geo_tag="latest"
geo_url="https://github.com/MetaCubeX/meta-rules-dat/releases/download/$geo_tag"

for file in "${geo_files[@]}"; do
    download "$geo_url/$file" "$file"
done

# Post-process compressed files
for file in *.zip mihomo*.gz *.tgz *.xz; do
    [ -e "$file" ] || continue
    process_compressed "$file"
done

# Compress single files
for file in *.dat *.metadb *.mmdb; do
    [ -e "$file" ] || continue
    compress_single "$file"
done

echo "All downloads and processing completed."

ls -lh .

for tar_file in clash*.tar.gz crash*.tar.gz mihomo*.tar.gz sing-box*.tar.gz; do
    [ -e "$tar_file" ] || continue

    echo "upx start $tar_file"

    temp_dir=$(mktemp -d)
    if [ ! -d "$temp_dir" ]; then
        echo "mktemp error"
        continue
    fi

    tar -xzf "$tar_file" -C "$temp_dir" 2>/dev/null
    if [ $? -ne 0 ]; then
        echo "tar error"
        rm -rf "$temp_dir"
        continue
    fi

    file_count=$(find "$temp_dir" -maxdepth 1 -type f | wc -l)

    if [ "$file_count" -eq 1 ]; then
        inner_file=$(find "$temp_dir" -maxdepth 1 -type f -printf "%f\n")

        echo upx "$temp_dir/$inner_file"
        chmod +x "$temp_dir/$inner_file"
        before_size=$(stat -c %s "$temp_dir/$inner_file")
        strip "$temp_dir/$inner_file" >/dev/null 2>&1
        upx "$temp_dir/$inner_file" --best --lzma >/dev/null 2>&1
        if [ $? -ne 0 ]; then
            echo "UPX error: $inner_file"
            ls -l "$temp_dir/$inner_file"
            rm -rf "$temp_dir"
            continue
        else
          after_size=$(stat -c %s "$temp_dir/$inner_file")

          before_human=$(numfmt --to=iec --suffix=B "$before_size")
          after_human=$(numfmt --to=iec --suffix=B "$after_size")

          echo "Before UPX: $before_human, After UPX: $after_human"
          echo "$tar_file upx completed"
        fi

        tar -czf "$tar_file" -C "$temp_dir" "$inner_file" 2>/dev/null
    else
        echo "skip $tar_file"
    fi

    rm -rf "$temp_dir"
done

echo "All upx completed."

ls -lh

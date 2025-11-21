targets=(
  "aarch64-apple-darwin"
  "x86_64-pc-windows-msvc"
  "x86_64-pc-windows-gnu"
  "x86_64-unknown-linux-gnu"
  "x86_64-unknown-linux-musl"
  "aarch64-unknown-linux-gnu"
  "aarch64-unknown-linux-musl"
)

geo=(
    "geoip.metadb.tar.gz"
    # "geoip.dat.tar.gz"
    # "geosite.dat.tar.gz"
)

ui=(
  "metacubexd.tar.gz"
)


REPO="https://github.com/ahaoboy/crash-assets"
RELEASE="https://github.com/ahaoboy/crash-assets/releases/download/nightly"
build() {
    local target="$1"
    echo "build $target"

    CONFIG_DIR="$target/crash_config"
    mkdir -p "./$CONFIG_DIR"

    ei $REPO --name crash --target $target --dir "./$target"
    ei $REPO --name mihomo --target $target --alias Mihomo --dir "./$CONFIG_DIR"

    for name in "${geo[@]}"; do
        url="$RELEASE/$name"
        ei $url --dir "./$CONFIG_DIR"
    done

    for name in "${ui[@]}"; do
        url="$RELEASE/$name"
        local base="${name%.tar.gz}"
        ei $url --dir "./$CONFIG_DIR" --alias Metacubexd
    done

    cd "$target"
    tar -cJf "../crash-full-${target}.tar.xz" .
    cd ..
    rm -rf "./$target"
}

for target in "${targets[@]}"; do
    build $target
done

ls -lh *.xz

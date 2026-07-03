https://github.com/ahaoboy/crash

https://github.com/ahaoboy/crash-ui

https://github.com/MetaCubeX/mihomo

https://github.com/SagerNet/sing-box

https://github.com/MetaCubeX/metacubexd

### crash

```bash

curl -fsSL https://cdn.jsdelivr.net/gh/ahaoboy/crash-assets@main/install.sh | sh -s -- --proxy jsdelivr
curl -fsSL https://gh-proxy.com/https://github.com/ahaoboy/crash-assets/blob/main/install.sh | sh -s -- --proxy gh-proxy

```

### crash-full

**tar needs to support the xz format.**

```bash

ei ahaoboy/crash-assets --name crash-full --dir ~/.crash

# Needs to support extracting tar.xz files.
curl -fsSL https://cdn.jsdelivr.net/gh/ahaoboy/crash-assets@main/install-full.sh | sh -s -- --proxy jsdelivr --dir ~/.crash

curl -fsSL https://gh-proxy.com/https://github.com/ahaoboy/crash-assets/blob/main/install-full.sh | sh -s -- --proxy gh-proxy

ei https://github.com/ahaoboy/crash-assets/blob/main/crash-full-x86_64-pc-windows-msvc.tar.xz
```

### router
```bash
ei ahaoboy/crash-assets --name crash-full --proxy jsdelivr --dir /jffs
```


### dev

```bash
git clone https://github.com/ahaoboy/crash-assets.git --branch dev --depth=1
```
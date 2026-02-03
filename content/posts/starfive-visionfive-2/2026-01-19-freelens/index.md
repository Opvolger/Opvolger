---
date: 2026-01-18
author: Bas Magré
categories: ["RISC-V"]
tags: ["starfive-visionfive-2", "RISC-V"]
title: StarFive VisionFive 2 Lite - FreeLens
draft: true
---
## Build FreeLens for RISCV

```bash
# On the risc-v machine:
# needed for build (I have Debian)
sudo apt install build-essential python3-setuptools libnss3 
# clone project
git clone https://github.com/freelensapp/freelens.git
cd freelens
# Prerequisites
# install nvm
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
# use unofficial RISC-V build
export NVM_NODEJS_ORG_MIRROR=https://unofficial-builds.nodejs.org/download/release
# instal node
nvm install node
# install pnpm
corepack install
# build the app
corepack enable pnpm
pnpm i
```

### Steps with `pnpm i`

remove the `  - electron-winstaller` in pnpm-workspace.yaml . We don't want a windows installer. It will give problems with 7z.exe download.

update file `node_modules/.pnpm/electron@39.2.7/node_modules/@electron/get/dist/cjs/artifact-utils.js`. electron has no riscv64 release. We have to do this in the run op `pnpm i` but before the `../node_modules/electron postinstall$ node install.js` step.

I did this with 2 windows. It downloads electron@39.2.7 and after that, try to download it. We need to change the javascript before the download.

```bash
sed -i -e 's|electron/electron/releases|riscv-forks/electron-riscv-releases/releases|g'  node_modules/.pnpm/electron@39.2.7/node_modules/@electron/get/dist/cjs/artifact-utils.js && \
sed -i -e 's|electron-v39.2.7-linux-arm64.zip|electron-v39.2.7-linux-riscv64.zip|g' node_modules/.pnpm/electron@39.2.7/node_modules/electron/checksums.json && \
sed -i -e 's|445465a43bd2ffaec09877f4ed46385065632a4683c2806cc6211cc73c110024|136804dbd04f1c6b9a6047c4e7bb648876214ff453b62fb3bdc81505b6f5aab2|g' node_modules/.pnpm/electron@39.2.7/node_modules/electron/checksums.json
```

### Steps with `pnpm build`

Turborepo is used in building FreeLens, but there is no native build. So we need to build it, and change/add some stuff in the node_modules so it will run.

Build turborepo for RISC-V

```bash
# we need capnp
sudo apt install capnproto libprotobuf-dev protobuf-compiler binutils-dev lld
# install rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
# clone project
git clone https://github.com/vercel/turborepo.git
# compile project
cd turborepo
git checkout v2.7.2
cargo build --profile release-turborepo -p turbo --target riscv64gc-unknown-linux-gnu
```

Build lightningcss for RISC-V

```bash
sudo apt install yarnpkg
sudo ln -s /usr/bin/yarnpkg /usr/bin/yarn
git clone https://github.com/parcel-bundler/lightningcss.git
cd lightningcss
git checkout v1.30.2
export NODE_OPTIONS=--max-old-space-size=1536
yarn install
yarn build-release
# yarn napi build --bin lightningcss --release --features cli --target riscv64gc-unknown-linux-gnu
```

save file `../package.json`

```json
{
  "name": "lightningcss-linux-riscv64-gnu",
  "version": "1.30.2",
  "license": "MPL-2.0",
  "description": "A CSS parser, transformer, and minifier written in Rust",
  "main": "lightningcss.linux-riscv64-gnu.node",
  "browserslist": "last 2 versions, not dead",
  "publishConfig": {
    "access": "public"
  },
  "funding": {
    "type": "opencollective",
    "url": "https://opencollective.com/parcel"
  },
  "repository": {
    "type": "git",
    "url": "https://github.com/parcel-bundler/lightningcss.git"
  },
  "engines": {
    "node": ">= 12.0.0"
  },
  "files": [
    "lightningcss.linux-riscv64-gnu.node"
  ],
  "resolutions": {
    "lightningcss": "link:."
  },
  "os": [
    "linux"
  ],
  "cpu": [
    "riscv64"
  ],
  "libc": [
    "glibc"
  ]
}
```

TODO:

Misschien CSS_TRANSFORMER_WASM gebruiken

```ini
@freelensapp/tooltip:build: built modules 9.97 KiB (javascript) 1.22 KiB (css/mini-extract) [built]
@freelensapp/tooltip:build:   ./index.ts + 10 modules 9.97 KiB [not cacheable] [built] [code generated]
@freelensapp/tooltip:build:   css ../../../node_modules/.pnpm/css-loader@6.11.0_webpack@5.104.1/node_modules/css-loader/dist/cjs.js??ruleSet[1].rules[1].use[1]!../../../node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/cjs.js??ruleSet[1].rules[1].use[2]!../../../node_modules/.pnpm/sass-loader@16.0.6_sass@1.97.2_webpack@5.104.1/node_modules/sass-loader/dist/cjs.js??ruleSet[1].rules[1].use[3]!./src/tooltip.scss 1.22 KiB [built] [code generated]
@freelensapp/tooltip:build: 
@freelensapp/tooltip:build: ERROR in ./src/tooltip.scss (./src/tooltip.scss.webpack[javascript/auto]!=!../../../node_modules/.pnpm/css-loader@6.11.0_webpack@5.104.1/node_modules/css-loader/dist/cjs.js??ruleSet[1].rules[1].use[1]!../../../node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/cjs.js??ruleSet[1].rules[1].use[2]!../../../node_modules/.pnpm/sass-loader@16.0.6_sass@1.97.2_webpack@5.104.1/node_modules/sass-loader/dist/cjs.js??ruleSet[1].rules[1].use[3]!./src/tooltip.scss)
@freelensapp/tooltip:build: Module Error (from ../../../node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/cjs.js):
@freelensapp/tooltip:build: Loading PostCSS "@tailwindcss/postcss" plugin failed: Cannot find module '../lightningcss.linux-riscv64-gnu.node'
@freelensapp/tooltip:build: Require stack:
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/lightningcss@1.30.2/node_modules/lightningcss/node/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/@tailwindcss+node@4.1.18/node_modules/@tailwindcss/node/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/@tailwindcss+postcss@4.1.18/node_modules/@tailwindcss/postcss/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/utils.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/cjs.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/loader-runner@4.3.1/node_modules/loader-runner/lib/loadLoader.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/loader-runner@4.3.1/node_modules/loader-runner/lib/LoaderRunner.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/NormalModuleFactory.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/Compiler.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/webpack.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/lib/webpack-cli.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/lib/bootstrap.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/bin/cli.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/bin/webpack.js
@freelensapp/tooltip:build: 
@freelensapp/tooltip:build: (@/home/opvolger/freelens/packages/ui-components/tooltip/src/tooltip.scss)
@freelensapp/tooltip:build: Error: Loading PostCSS "@tailwindcss/postcss" plugin failed: Cannot find module '../lightningcss.linux-riscv64-gnu.node'
@freelensapp/tooltip:build: Require stack:
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/lightningcss@1.30.2/node_modules/lightningcss/node/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/@tailwindcss+node@4.1.18/node_modules/@tailwindcss/node/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/@tailwindcss+postcss@4.1.18/node_modules/@tailwindcss/postcss/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/utils.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/postcss-loader@8.2.0_postcss@8.5.6_typescript@5.9.3_webpack@5.104.1/node_modules/postcss-loader/dist/cjs.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/loader-runner@4.3.1/node_modules/loader-runner/lib/loadLoader.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/loader-runner@4.3.1/node_modules/loader-runner/lib/LoaderRunner.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/NormalModuleFactory.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/Compiler.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/webpack.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/lib/index.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/lib/webpack-cli.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/lib/bootstrap.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack-cli@6.0.1_webpack-dev-server@5.2.3_webpack@5.104.1/node_modules/webpack-cli/bin/cli.js
@freelensapp/tooltip:build: - /home/opvolger/freelens/node_modules/.pnpm/webpack@5.104.1_webpack-cli@6.0.1/node_modules/webpack/bin/webpack.js
```

Now we have the turborepo and lightningcss for RISC-V. Back to freelens

We need to update `node_modules/.pnpm/turbo@2.7.2/node_modules/turbo/bin/turbo` and add the binary we had build.

We need to add lightningcss bin for RISC-V

```bash
#turborepo
sed -i -e 's|arm64|riscv64|g'  node_modules/.pnpm/turbo@2.7.2/node_modules/turbo/bin/turbo
mkdir -p node_modules/.pnpm/turbo@2.7.2/node_modules/turbo-linux-riscv64/bin
cp ../turborepo/target/riscv64gc-unknown-linux-gnu/release-turborepo/turbo node_modules/.pnpm/turbo@2.7.2/node_modules/turbo-linux-riscv64/bin/turbo
#lightningcss
mkdir -p node_modules/.pnpm/lightningcss-linux-riscv64-gnu@1.30.2/node_modules/lightningcss-linux-riscv64-gnu
mkdir -p node_modules/.pnpm/lightningcss@1.30.2/node_modules/lightningcss-linux-riscv64-gnu
cp ../lightningcss/lightningcss node_modules/.pnpm/lightningcss-linux-riscv64-gnu@1.30.2/node_modules/lightningcss-linux-riscv64-gnu/lightningcss.linux-riscv64-gnu.node
cp ../lightningcss/lightningcss node_modules/.pnpm/lightningcss@1.30.2/node_modules/lightningcss-linux-riscv64-gnu/lightningcss.linux-riscv64-gnu.node
cp ../lightningcss/lightningcss node_modules/.pnpm/lightningcss.linux-riscv64-gnu.node
cp ../lightningcss/lightningcss node_modules/.pnpm/lightningcss-linux-riscv64-gnu@1.30.2/node_modules/lightningcss-linux-riscv64-gnu/lightningcss.linux-riscv64-gnu.node
cp ../package.json node_modules/.pnpm/lightningcss-linux-riscv64-gnu@1.30.2/node_modules/lightningcss-linux-riscv64-gnu/package.json
cp ../package.json node_modules/.pnpm/lightningcss@1.30.2/node_modules/lightningcss-linux-riscv64-gnu/package.json
```

We need freelens-k8s-proxy

```bash
wget https://go.dev/dl/go1.25.5.linux-riscv64.tar.gz
sudo rm -rf /usr/local/go && tar -C /usr/local -xzf go1.25.5.linux-riscv64.tar.gz
# wget https://github.com/goreleaser/goreleaser/releases/download/v2.13.3/goreleaser_2.13.3_riscv64.deb
# sudo dpkg -i goreleaser_2.13.3_riscv64.deb
git clone https://github.com/freelensapp/freelens-k8s-proxy.git
cd freelens-k8s-proxy/
git checkout v1.5.0
go build
```

Now we can build the application!

```bash
pnpm build
pnpm build:app:dir
```

Now we have a FreeLens for RISC-V
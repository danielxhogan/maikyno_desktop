#!/bin/zsh
source ~/.zshrc

mkdir -p ./build && \
cd ./build && \
cmake \
    -DCMAKE_PREFIX_PATH="/usr/local/bin/6.10.2/gcc_64;$HOME/programs/compiled/install" \
    -DCMAKE_INSTALL_PREFIX="$HOME/programs/compiled/install" \
    -DUSE_MKP_BACKEND=ON \
    -S .. -B . && \
cmake --build . && \
cmake --install . && \
mkd

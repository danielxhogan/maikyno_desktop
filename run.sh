#!/bin/zsh
source ~/.zshrc

mkdir -p ./build && \
cd ./build && \
cmake -DCMAKE_PREFIX_PATH="/usr/local/bin/6.10.2/gcc_64;/home/hugexjackedman/programs/compiled/install" -S .. -B . && \
cmake --build . && \
./src/maikyno_desktop

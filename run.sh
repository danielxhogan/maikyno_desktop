#!/bin/zsh
source ~/.zshrc

mkdir -p ./build && \
cd ./build && \
cmake -DCMAKE_PREFIX_PATH=/usr/local/bin/6.10.2/gcc_64/ -S .. -B . && \
cmake --build . && \
./src/maikyno_desktop "/media/hugexjackedman/Media Libraries/mk_movies/collections/Evil Dead Series/Evil Dead Rise/Evil Dead Rise.mkv"

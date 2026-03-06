mkdir -p ./build && \
cd ./build && \
cmake -DCMAKE_PREFIX_PATH=/usr/local/bin/6.9.1/gcc_64/ -S .. -B . && \
cmake --build . && \
./maikyno_desktop
rm -rf ./build
mkdir ./build

pushd ./build
cmake .. \
    -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
    -DCMAKE_BUILD_TYPE=Debug    \
    -G "Unix Makefiles" \
    -DCMAKE_C_COMPILER=/usr/bin/gcc-10 \
    -DCMAKE_CXX_COMPILER=/usr/bin/g++-10 \
    -DMNN_OPENCL=ON \
    -DMNN_ARM82=OFF \
    -DMNN_LOW_MEMORY=true \
    -DMNN_CPU_WEIGHT_DEQUANT_GEMM=true \
    -DMNN_GPU_TIME_PROFILE=true \
    -DMNN_BUILD_LLM=true \
    -DMNN_SUPPORT_TRANSFORMER_FUSE=true \
    -DMNN_AVX512=false \
    -DMNN_SEP_BUILD=OFF \
    -DMNN_BUILD_CONVERTER=ON \
    -DMNN_BUILD_TEST=true

make -j8
popd


# MNN_USE_SYSTEM_LIB
    # -DMNN_BUILD_CONVERTER=ON \
    # -DMNN_BUILD_TORCH=ON
    # -DMNN_FORBID_MULTI_THREAD=ON \
    # -DMNN_USE_THREAD_POOL=OFF

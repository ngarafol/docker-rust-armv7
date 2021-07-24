FROM rustembedded/cross:armv7-unknown-linux-gnueabihf

RUN dpkg --add-architecture armhf && \
    apt-get update && \
    apt-get install -y apt-transport-https wget gnupg2 && \
    (wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | apt-key add -) && \
    printf "deb http://apt.llvm.org/xenial/ llvm-toolchain-xenial-12 main\ndeb-src http://apt.llvm.org/xenial/ llvm-toolchain-xenial-12 main" > /etc/apt/sources.list.d/backports.list && \
    apt-get update && \
    apt-get install -y clang-12 libclang-common-12-dev libclang-12-dev libclang1-12 build-essential curl 

ENV BINDGEN_EXTRA_CLANG_ARGS='-I /usr/arm-linux-gnueabihf/include/'

# Get Rust, cross and add target
# Check cross supported targets list https://github.com/rust-embedded/cross#supported-targets
RUN curl https://sh.rustup.rs -sSf | bash -s -- -y && \
    . $HOME/.cargo/env && \
    rustup target add armv7-unknown-linux-gnueabihf && \
    cargo install cross

ENV PATH="/root/.cargo/bin:${PATH}"

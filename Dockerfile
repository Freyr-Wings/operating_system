FROM ubuntu:20.04

RUN set -ex;                                      \
    tempPkgs='                                    \
        git\
        # for qemu
        ninja-build\
        pkg-config\
        wget\
    ';                                            \
    apt-get update;                               \
    apt-get install -q -y --no-install-recommends \
        $tempPkgs                                 \
        # persistent packages
        # for make, objdump, ...
        build-essential                           \
        # for git
        ca-certificates                           \
        # for qemu
        libpixman-1-dev                           \
        libglib2.0-dev                            \
        python3                                   \
        gcc-multilib                              \
        gdb-multiarch                             \
        locales                                   \
    ;\
    # QEMU
    if [ "x$http_proxy" != "x" ]; then git config --global http.proxy ${http_proxy}; fi;\
    if [ "x$https_proxy" != "x" ]; then git config --global https.proxy ${https_proxy}; fi;\
    git clone https://git.qemu.org/git/qemu.git;               \
    cd qemu;                                                   \
    git checkout tags/v5.2.0;                                  \
    ./configure --disable-kvm --disable-werror                 \
        --target-list="i386-softmmu x86_64-softmmu"            \
        --python=/usr/bin/python3;                             \
    make -j8;                                                  \
    make install;                                              \
    cd ..;                                                     \
    rm -rf qemu;                                               \
    # GDB
    wget -P ~ git.io/.gdbinit; \
    # Cleanup
    apt-get purge -y --auto-remove $tempPkgs; \
    apt-get autoremove -q -y;                 \
    apt-get clean -q -y;                      \
    rm -rf /var/lib/apt/lists/*

# Locales
RUN locale-gen en_US.UTF-8

ENV LANG=en_US.UTF-8  \
    LANGUAGE=en_US:en \
    LC_ALL=en_US.UTF-8 

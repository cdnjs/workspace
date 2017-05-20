From ubuntu:17.04
MAINTAINER Peter Dave Hello <peter@cdnjs.com>
ENV DEBIAN_FRONTEND noninteractive
ENV UBUNTU_APT_SITE ftp.yzu.edu.tw
ENV BASE_PATH       /root/cdnjs
RUN sed -i 's/^deb-src\ /\#deb-src\ /g' /etc/apt/sources.list
RUN sed -E -i "s/([a-z]+.)?archive.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
RUN sed -i "s/security.ubuntu.com/$UBUNTU_APT_SITE/g" /etc/apt/sources.list
RUN apt update         && \
    apt upgrade -y     && \
    apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        dnsutils              \
        openssh-client        \
        dpkg                  \
        coreutils             \
        mount                 \
        login                 \
        util-linux            \
        gnupg                 \
        passwd                \
        bsdutils              \
        file                  \
        openssl               \
        ca-certificates       \
        ssh                   \
        wget                  \
        cpio                  \
        dnsutils              \
        patch                 \
        sudo                  \
        sysstat               \
        vnstat                \
        htop                  \
        dstat                 \
        vim                   \
        tmux                  \
        tree                  \
        aria2                 \
        aptitude              \
        moc                   \
        colordiff             \
        curl                  \
        pbzip2                \
        pigz                  \
        fbterm                \
        fail2ban              \
        mtr-tiny              \
        ntpdate               \
        git                   \
        p7zip-full            \
        mosh                  \
        nmap                  \
        apt-file              \
        gdebi                 \
        command-not-found     \
        irssi                 \
        geoip-bin             \
        w3m                   \
        unzip                 \
        tcpdump               \
        iftop                 \
        iotop                 \
        smartmontools         \
        xterm                 \
        unattended-upgrades   \
        ppa-purge             \
        jq                    \
        pxz                   \
        iperf                 \
        parallel              \
        whois                 \
        lsof                  \
        inxi                  \
        realpath              \
        ufw                   \
        make                  \
        build-essential       \
        bash-completion       && \
    apt clean

RUN locale-gen en_US.UTF-8

RUN git --version
RUN bash --version | head -n 1
RUN mkdir ${BASE_PATH}/


#### repos ####

# workspace
RUN git clone --progress https://github.com/cdnjs/workspace      ${BASE_PATH}/workspace

# buildScript
RUN git clone --progress https://github.com/cdnjs/buildScript      ${BASE_PATH}/buildScript

# autoupdate
RUN git clone --progress https://github.com/cdnjs/autoupdate       ${BASE_PATH}/autoupdate

# atom-extension
RUN git clone --progress https://github.com/cdnjs/atom-extension   ${BASE_PATH}/atom-extension

# Drone CI
RUN git clone --progress https://github.com/cdnjs/cdnjs-drone-ci   ${BASE_PATH}/cdnjs-drone-ci

# bot
RUN git clone --progress https://github.com/cdnjs/bot              ${BASE_PATH}/bot

# common script
RUN git clone --progress https://github.com/cdnjs/script           ${BASE_PATH}/script

# tutorials
RUN git clone --progress https://github.com/cdnjs/tutorials        ${BASE_PATH}/tutorials

# importer
RUN git clone --progress https://github.com/cdnjs/cdnjs-importer   ${BASE_PATH}/cdnjs-importer

# main repo
RUN git init ${BASE_PATH}/cdnjs
RUN wget https://github.com/cdnjs/cdnjs/raw/master/tools/sparse-checkout.template -O ${BASE_PATH}/cdnjs/.git/info/sparse-checkout
RUN echo '/ajax/libs/jquery' >> ${BASE_PATH}/cdnjs/.git/info/sparse-checkout
RUN git -C ${BASE_PATH}/cdnjs config core.sparseCheckout true
RUN git -C ${BASE_PATH}/cdnjs remote add origin git://cdnjs.peterdavehello.org/cdnjs
RUN git -C ${BASE_PATH}/cdnjs pull --progress origin master --depth 500
RUN git -C ${BASE_PATH}/cdnjs branch
RUN git -C ${BASE_PATH}/cdnjs branch --set-upstream-to=origin/master
RUN git -C ${BASE_PATH}/cdnjs remote add github https://github.com/cdnjs/cdnjs.git

# website & api repo
RUN git init ${BASE_PATH}/new-website
RUN git -C ${BASE_PATH}/new-website remote add origin git://cdnjs.peterdavehello.org/new-website
RUN git -C ${BASE_PATH}/new-website pull --progress origin master
RUN git -C ${BASE_PATH}/new-website fetch origin meta:meta
RUN git -C ${BASE_PATH}/new-website remote remove origin
RUN git -C ${BASE_PATH}/new-website remote add origin https://github.com/cdnjs/new-website.git
RUN git -C ${BASE_PATH}/new-website fetch origin master
RUN git -C ${BASE_PATH}/new-website branch --set-upstream-to=origin/master

#### repos ####

# nvm && node && tools && dependencies
RUN apt install -y -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" \
        libssl-dev               \
        libssl1.0-dev            \
        libgcc-6-dev             \
        libcurl4-openssl-dev     \
        libssh2-1-dev         && \
    apt clean

RUN curl --compressed -o- https://cdn.rawgit.com/creationix/nvm/v0.33.2/install.sh | bash && \
    bash -c 'source $HOME/.nvm/nvm.sh && \
    nvm install 4 && \
    nvm cache clear && \
    npm install -g pnpm ied npm-check-updates && \
    for repo in new-website cdnjs atom-extension autoupdate cdnjs-importer; do npm install --prefix "${BASE_PATH}/${repo}/" ; done'

# unitial
RUN curl --compressed -Lo- https://github.com/PeterDaveHello/Unitial/raw/master/setup.sh | bash

ENTRYPOINT /bin/bash

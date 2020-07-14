FROM phusion/baseimage:focal-1.0.0-alpha1-amd64

LABEL maintainer="Georgios Sokianos <walkero@gmail.com>"

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

RUN apt-get update && apt-get -y install \
    p7zip-full \
    python3-pip \
    git \
    unadf; \
    pip3 install amitools; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

# Install latest lha from git repo
RUN apt-get update && apt-get -y install dh-autoreconf; \
    cd /tmp; \
    git clone https://github.com/jca02266/lha.git; \
    mkdir build; \
    cd lha; \
    autoreconf -vfi; \
    cd ../build; \
    ../lha/configure --prefix=/usr; \
    make; \
    make install; \
    apt-get -y purge dh-autoreconf && apt-get -y autoremove; \
    apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*;

RUN curl -fSL "https://downloads.sourceforge.net/project/aros/nightly2/20200714/Binaries/AROS-20200714-amiga-m68k-boot-iso.zip" -o /tmp/AROS-m68k-boot-iso.zip; \
    cd /tmp; \
    mkdir /home/aros; \
    7z x AROS-m68k-boot-iso.zip; \
    cd AROS-*-amiga-m68k-boot-iso; \
    7z x aros-amiga-m68k.iso -o/home/aros; \
    cd /home/aros; \
    rm -rf ./Devs ./Demos ./Developer ./WBStartup ./Emergency-Boot ./Emergency-Boot.adf ./Prefs/Presets/Themes ./Fonts ./Locale ./Storage ./*.info; \
    rm -rf /tmp/*;

# Add git branch name to bash prompt
RUN sed -i '4c\'"\nparse_git_branch() {\n\
  git branch 2> /dev/null | sed -e \'/^[^*]/d\' -e \'s/* \\\(.*\\\)/ (\\\1)/\'\n\
}\n" ~/.bashrc; \
    sed -i '43c\'"force_color_prompt=yes" ~/.bashrc; \
    sed -i '57c\'"    PS1=\'\${debian_chroot:+(\$debian_chroot)}\\\[\\\033[01;32m\\\]\\\u@\\\h\\\[\\\033[00m\\\]:\\\[\\\033[01;34m\\\]\\\w\\\[\\\033[01;31m\\\]\$(parse_git_branch)\\\[\\\033[00m\\\]\\\$ '" ~/.bashrc; \
    sed -i '59c\'"    PS1=\'\${debian_chroot:+(\$debian_chroot)}\\\u@\\\h:\\\w \$(parse_git_branch)\$ \'" ~/.bashrc;

# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# USER vbcc
WORKDIR /opt/code

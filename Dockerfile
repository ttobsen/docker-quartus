FROM archlinux:20200407
LABEL maintainer="Tobias Baumann <tobias.baumann@elpra.de>"

# install yay deps
RUN pacman -Syyu git go binutils fakeroot gcc make sudo --needed --noprogressbar --noconfirm && yes|pacman -Scc

# install yay
RUN useradd -m altera && echo "altera ALL = NOPASSWD: ALL" >> /etc/sudoers
WORKDIR /home/altera
RUN su altera -c 'git clone https://aur.archlinux.org/yay.git; cd yay; makepkg'
RUN pushd ./yay && \
    pacman -U *.pkg.tar.xz --noprogressbar --noconfirm && \
    popd && \
    rm -rf yay

# install quartus deps
RUN echo -e "[multilib]\nInclude = /etc/pacman.d/mirrorlist" >> /etc/pacman.conf
RUN pacman -Syyu lib32-zlib lib32-libjpeg lib32-libpng lib32-libtiff lib32-tcl python3 python-pip --needed --noprogressbar --noconfirm && yes|pacman -Scc

# install container applications
RUN su altera -c 'yay -S --needed --noprogressbar --needed --noconfirm quartus-free-130; yes|yay -Scc'
RUN pip install vunit-hdl==4.4.0 PyYAML

ENV PATH="/opt/altera/13.0sp1/quartus/bin:/opt/altera/13.0sp1/modelsim_ase/bin:${PATH}"

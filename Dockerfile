FROM alpine:latest as BuildBase

    # Setup build system
    RUN apk add --update --no-cache \
        automake \
        autoconf \
        libtool \
        gcc \
        git \
        libc-dev \
        make 
        
    # Build dependancies that aren't available as alpine or python packages
    RUN git clone https://git.savannah.gnu.org/git/chktex.git \
        && cd chktex/chktex \
        && sh autogen.sh --prefix=/usr/bin \
        && ./configure \
        && make \
        && install chktex /usr/bin



FROM alpine:latest as Final

    COPY --from=BuildBase /usr/bin/chktex /usr/bin/chktex

    # Install initial texlive environment (and delete all the goddamned documentation ~2.4GB)
    RUN apk add texlive-full biber python3 py3-pip \
        && pip3 install pygments \
        && find / -name "*.pdf" -type f -delete

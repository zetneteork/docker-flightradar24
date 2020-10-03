FROM debian:stable AS download
ENV ARCH=amd64
ARG URL="https://repo-feed.flightradar24.com/linux_x86_64_binaries/fr24feed_1.0.25-3_${ARCH}.tgz"
WORKDIR /
ADD ${URL} /fr24feed.tgz
RUN tar xvfz fr24feed.tgz &&\
    cd /fr24feed_amd64 &&\
    chmod +x fr24feed


FROM debian:stable
ENV DEBIAN_FRONTEND=noninteractive
WORKDIR /
COPY --from=download /fr24feed_amd64/fr24feed .
RUN apt-get update &&\
    apt-get install -yf apt-utils dialog &&\
    dpkg-reconfigure debconf -f noninteractive -p critical &&\
    apt install --yes dump1090-mutability &&\
    #dpkg -i --force-all fr24feed.deb &&\
    apt-get install -yf


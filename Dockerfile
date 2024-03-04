FROM debian:latest AS buildenv

ENV APT_PACKAGES build-essential
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends ${APT_PACKAGES} \
    && apt-get autoremove --yes \
    && apt-get clean

RUN useradd --system --uid=10000 --shell=/sbin/nologin buildenv
USER buildenv
WORKDIR /home/buildenv

COPY --chown=buildenv ./files/sx1302_hal-2.1.0-local-install.tar.gz ./source.tar.gz
RUN tar --extract --strip-components=1 --file=./source.tar.gz
COPY --chown=buildenv ./files/target.cfg ./target.cfg

RUN make clean all \
    && make install


FROM debian:latest

ENV APT_PACKAGES dfu-util
ENV DEBIAN_FRONTEND noninteractive
RUN apt-get update \
    && apt-get upgrade --yes \
    && apt-get install --yes --no-install-recommends ${APT_PACKAGES} \
    && apt-get autoremove --yes \
    && apt-get clean

RUN useradd --system --uid=10000 --shell=/sbin/nologin --group=dialout lorawan
COPY --from=buildenv --chown=buildenv /home/buildenv/buildout /usr/libexec/lorawan
COPY --from=buildenv --chown=buildenv /home/buildenv/mcu_bin /usr/libexec/lorawan/mcu_bin/

USER lorawan
WORKDIR /usr/libexec/lorawan
CMD [ "/usr/libexec/lorawan/lora_pkt_fwd", "-c", "config.json" ]

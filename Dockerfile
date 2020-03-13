FROM postgres:12
ARG DEBIAN_FRONTEND=noninteractive

ARG DEPS="vim"
RUN apt-get update && apt-get install -y $DEPS

RUN echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections \
    && echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, ru_RU.UTF-8 UTF-8" | debconf-set-selections \
    && rm "/etc/locale.gen" \
    && dpkg-reconfigure locales \
    && locale -a \
    && ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime \
    && dpkg-reconfigure tzdata

ENV LANG=ru_RU.utf8

COPY ./conf/.bashrc /root/.bashrc
COPY ./conf/postgresql.conf /etc/postgresql/postgresql.conf

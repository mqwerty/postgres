FROM postgres:12
ARG DEBIAN_FRONTEND=noninteractive

RUN addgroup --system --gid 3000 app && adduser --uid 3000 --gid 3000 --no-create-home --system app

ARG DEPS="vim"
RUN apt-get update && apt-get install -y $DEPS

RUN echo "locales locales/default_environment_locale select en_US.UTF-8" | debconf-set-selections \
    && echo "locales locales/locales_to_be_generated multiselect en_US.UTF-8 UTF-8, ru_RU.UTF-8 UTF-8" | debconf-set-selections \
    && rm "/etc/locale.gen" \
    && dpkg-reconfigure locales \
    && locale -a

ENV LANG=en_US.utf8

#RUN ln -sf /usr/share/zoneinfo/Europe/Moscow /etc/localtime && dpkg-reconfigure tzdata

COPY ./conf/.bashrc /root/.bashrc
COPY ./conf/postgresql.conf /etc/postgresql/postgresql.conf
COPY ./conf/init.sh /docker-entrypoint-initdb.d/

RUN mkdir /socks && chown app:app /socks && chmod 0775 /socks && usermod -a -G app postgres

CMD ["postgres", "-c", "config_file=/etc/postgresql/postgresql.conf"]

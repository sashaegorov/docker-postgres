FROM debian:jessie
ENV LOCALE="en_US.UTF-8" \
    PG_MAJOR=%%PG_MAJOR%% \
    PG_VERSION=%%PG_VERSION%% \
    PATH=/usr/lib/postgresql/%%PG_MAJOR%%/bin:$PATH \
    PGDATA=/var/lib/postgresql/data

COPY docker-*.sh /
RUN ["/docker-prepare.sh"]

VOLUME /var/lib/postgresql/data
ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]

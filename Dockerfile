# vim:set ft=dockerfile:
FROM debian:jessie

ENV LANG="en_US.utf8" \
    PG_MAJOR=%%PG_MAJOR%% \
    PG_VERSION=%%PG_VERSION%% \
    PATH=/usr/lib/postgresql/%%PG_MAJOR%%/bin:$PATH \
    PGDATA=/var/lib/postgresql/data

# Copy all Docker-related files
COPY docker-*.sh /
# Run preparation script
RUN ["/docker-prepare.sh"]

VOLUME /var/lib/postgresql/data

ENTRYPOINT ["/docker-entrypoint.sh"]
EXPOSE 5432
CMD ["postgres"]

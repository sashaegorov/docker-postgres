# About PostgreSQL in Docker

![PostgreSQL Logo](http://www.postgresql.org/media/img/about/press/slonik_with_black_text_and_tagline.gif)

This is the Git repo of the un-official Docker image for [PostgreSQL](https://registry.hub.docker.com/_/postgres/) database. See original [PostgreSQL hub page](https://hub.docker.com/_/postgres/) for the full documentation on how to use the Docker image.

Following extension included:
- [pg_hint_plan](http://pghintplan.osdn.jp/pg_hint_plan.html) v.1.1.3
- [pg_dbms_stats](http://pgdbmsstats.osdn.jp/pg_dbms_stats-en.html) v.1.3.6

*Note:* These extensions are supported by PostgreSQL version 9.4 only.

## Versions supported

This repo intended to support PostgreSQL of versions *9.4* as well as *9.5*.
Version *9.4* is more common and tested better. Anyway fill free to suggest enhancement and request to pull or merge.

## How to build?

Perform following actions to build PostgreSQL container by yourself.

### From your workstation

Perform these steps if you are not intended to use `Vagrant`:

    ## Clone repository
    $ git clone git@gitlabnew.sdntest.netcracker.com:egorov/docker-postgresql.git
    $ cd docker-postgresql/

### Or using Vagrant goodness

    $ vagrant up
    $ vagrant ssh
    ## Go to shared directory
    cd /vagrant/

### Common steps…

    ## Perform update. This will create necessary `Dockerfile` in each directory.
    $ ./update.sh
    Updating for 9.4
    Updating for 9.5

    ## Perform build for version 9.4
    $ docker build --force-rm -t postgres:9.4 9.4/

Wait until completion message appears:

    ...
    Successfully built 09b1ad82b3c3

## How to run?

Here is the natural ways to run PostgreSQL in container:

    ## Run with directly in current session
    $ docker run --name postgres94 -p 5432:5432 postgres:9.4
    ## Or run it in background
    $ docker run -d --name postgres94-bg -p 5432:5432 --restart=always postgres:9.4
    ## Connect from client machine on exposed port
    psql -h localhost -p 5432 -U postgres

You can also check  [hostname ](http://www.postgresql.org/message-id/BLU102-W2529897925D1499BB8B0CEA1F00@phx.gbl) of PostgreSQL server or even [IP-address](http://stackoverflow.com/questions/5598517/find-the-host-name-and-port-using-psql-commands):

    psql -h localhost -p 5432 -U postgres << SQL
    create temp table hostname (host_name text);
    copy hostname from '/etc/hostname';
    select * from hostname;
    drop table hostname;
    select inet_server_addr();
    select inet_server_port();
    SQL

Here is the result:

    CREATE TABLE
    COPY 1
      host_name
    --------------
     a45ce2f1bfc3
    (1 row)

    DROP TABLE
     inet_server_addr
    ------------------
     172.17.0.56
    (1 row)

     inet_server_port
    ------------------
                 5432
    (1 row)

## ~~Squash it!~~

**Experimantal and NOT tested!**
Check original image with history:

    $ docker images
    REPOSITORY TAG IMAGE ID       CREATED       VIRTUAL SIZE
    postgres   9.4 c1f733eb105e   6 minutes ago 180.3 MB

Perform some magic:

    ## Run it
    $ docker run -d postgres:9.4
    ## Use ID to reimport image with different tag
    $ docker export c17bb4fc8c1123390028a6ede6e00d1c9619f1fd5dea7c44d4da3ed937d5bc73 | docker import --change "ENV LOCALE=en_US.UTF-8 PG_MAJOR=9.4 PATH=/usr/lib/postgresql/9.4/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin PGDATA=/var/lib/postgresql/data" \
    --change "EXPOSE 5432" \
    --change "CMD /bin/bash /docker-entrypoint.sh postgres" - postgres:9.4flat

Check new size:

    $ docker images
    REPOSITORY TAG     IMAGE ID       CREATED       VIRTUAL SIZE
    postgres   9.4flat c1f733eb105e   2 seconds ago 143.6 MB
    postgres   9.4     c1f733eb105e   6 minutes ago 180.3 MB

Run it with `-p` option!

    docker run -d -p 5432:5432 postgres:9.4flat

## How to cleanup?

**NOTE:** all command below should be executed with *extreme caution*!
Time to time it's necessary to cleanup Docker containers which is not used any more. Here are several ways to do that.

### Cleaning up *containers*

    ## Softest way. Change 'weeks' to 'days'
    docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm
    ## Exited only...
    docker ps -a | grep 'Exited' | awk '{print $1}' | xargs --no-run-if-empty docker rm
    ## DANGER! Every thing except 'Up'
    docker ps -a | grep -v 'Up' | awk '{print $1}' | xargs --no-run-if-empty docker rm

### Cleaning up *images*

During the image preparation where is the chance container will leave. These containers has tag `<none>`. Here is the command to find them and delete:

    $ docker images | grep '\<none\>' | awk '{print $3}' | xargs docker rmi -f

# Additional readings

- https://hub.docker.com/_/postgres/

## How to look inside? Whoa!

Example of how to attach to container. [More](https://docs.docker.com/reference/commandline/attach/) about `attach` command.

    ## Run it in background
    $ docker run -d --name postgres94-bg -p 5432:5432 --restart=always postgres:9.4
    ## Exec
    docker exec -i -t postgres94-bg bash

# Programming, Humblehacker!

![Programming, Humblehacker!](http://s3.amazonaws.com/zedshaw.progmofo/bg.png)

# TODO

1. Tests. Period.
2. Travis CI integration.

## How to push it somewhere?

    $ docker tag postgres:9.4 localhost:5000/postgres:9.4
    $ docker push localhost:5000/postgres:9.4
    ...
    Pushing repository localhost:5000/postgres:9.4 (1 tags)
    ...

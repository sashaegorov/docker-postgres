# About PostgreSQL in Docker

This is the Git repo of the un-official Docker image for [PostgreSQL](https://registry.hub.docker.com/_/postgres/) database. See original [PostgreSQL hub page](https://hub.docker.com/_/postgres/) for the full documentation on how to use the Docker image.

## Versions supported
This repo intended to support PostgreSQL of versions *9.4* as well as *9.5*.
Version *9.4* is more common and tested better. Anyway fill free to suggest enhancement and request to pull or merge.

## How to build?
Perform following actions to build PostgreSQL container by yourself.

    # Clone repository
    $ git clone git@gitlabnew.sdntest.netcracker.com:egorov/docker-postgresql.git
    $ cd docker-postgresql/

    # Perform update. This will create necessary `Dockerfile` in each directory.
    $ ./update.sh
    Updating for 9.4
    Updating for 9.5

    # Perform build for version 9.4
    $ docker build --force-rm=true -t postgres-9-4 9.4/

Wait until completion message appears:

    ...
    Step 7 : CMD postgres
     ---> Running in 327007294cf9
     ---> 09b1ad82b3c3
    Removing intermediate container 327007294cf9
    Successfully built 09b1ad82b3c3

## How to run?
Here is the natural ways to run PostgreSQL in container:

    # Run with directly in current session
    $ docker run --name postgres-9-4 -p 5432:5432 postgres-9-4
    # Or run it in background
    $ docker run -d --name postgres-9-4-bg -p 5432:5432 --restart=always postgres-9-4
    # Connect from client machine on exposed port
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

## How to cleanup?
**NOTE:** all command below should be executed with *extreme caution*!
Time to time it's necessary to cleanup Docker containers which is not used any more. Here are several ways to do that.

### Cleaning up *containers*

    # Softest way. Change 'weeks' to 'days'
    docker ps -a | grep 'weeks ago' | awk '{print $1}' | xargs --no-run-if-empty docker rm
    # Exited only...
    docker ps -a | grep 'Exited' | awk '{print $1}' | xargs --no-run-if-empty docker rm
    # DANGER! Every thing except 'Up'
    docker ps -a | grep -v 'Up' | awk '{print $1}' | xargs --no-run-if-empty docker rm

### Cleaning up *images*
During the image preparation where is the chance container will leave. These containers has tag `<none>`. Here is the command to find them and delete:

    $ docker images | grep '\<none\>' | awk '{print $3}' | xargs docker rmi -f

# Additional readings

- https://hub.docker.com/_/postgres/

# TODO
## How to look inside?

Example of how to attach to container. [More](https://docs.docker.com/reference/commandline/attach/) about `attach` command.

    docker run --name postgres-9-4-bash postgres-9-4 /bin/bash
    docker attach postgres-9-4

## How to push it somewhere?

    $ docker tag postgres-9-4 localhost:5000/postgres-9-4
    $ docker push localhost:5000/postgres-9-4
    The push refers to a repository [localhost:5000/postgres-9-4] (len: 1)
    Sending image list
    Pushing repository localhost:5000/postgres-9-4 (1 tags)
    ...

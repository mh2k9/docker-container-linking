#!/usr/bin/env bash

docker run --name test1 -d -p 8081:80 -v $(pwd):/var/www/html csemahadi/php7-docker-image
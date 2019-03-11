#!/usr/bin/env bash

docker run --name test2 -p 8080:80 -v $(pwd):/var/www/html --link test1:tl csemahadi/php7-docker-image

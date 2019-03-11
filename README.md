# Docker Container Linking

What is docker container linking?
---
Docker container linking is a feature to create a communication bride among containers. This bridge/linking is used to communicate with each other of containers and pass date securely from one container to another.

Show docker containers
---
- Run `$ docker ps` and we can see the following containers
```bash
CONTAINER ID        IMAGE                         COMMAND                  CREATED             STATUS              PORTS                  NAMES
376170ae9ae2        csemahadi/php7-docker-image   "/usr/sbin/apache2ct…"   15 seconds ago      Up 11 seconds       0.0.0.0:8080->80/tcp   test2
f577c140ee8c        csemahadi/php7-docker-image   "/usr/sbin/apache2ct…"   25 seconds ago      Up 22 seconds       0.0.0.0:8081->80/tcp   test1
```

How to create link?
---
Consider we have two docker container named test1 and test2 and we want to access the resource of test1 container from test2 container securely. For that we can follow the following steps

- Pull repo: `$ git clone https://github.com/mh2k9/docker-container-linking.git`. 
- Go to **test1** directory and run `start-test1.sh`. This bash command create a docker container named `test1` by the following command
    ```bash
    #!/usr/bin/env bash
    
    docker run --name test1 -d -p 8081:80 -v $(pwd):/var/www/html csemahadi/php7-docker-image
    ```
- Now go to **test2** directory and run `start-test2.sh`. This bash file contains the following docker command
    ```bash
    #!/usr/bin/env bash
    
    docker run --name test2 -p 8080:80 -v $(pwd):/var/www/html --link test1:tl csemahadi/php7-docker-image
    ```
    That command contains a `--link` flag which has the value `test1:tl`. Here `test1` is the docker container which we created earlier and `tl` is the alice by which we can access the resource of `test1` container from `test2` container.
    
Resource access example:
---
Go to **test2** directory and open the `index.php` file which contains the following PHP codes
```PHP
$ch = curl_init();
curl_setopt($ch, CURLOPT_URL, "tl/index.php");
curl_setopt($ch, CURLOPT_RETURNTRANSFER, 1);
curl_setopt($ch, CURLOPT_CONNECTTIMEOUT, 5);
curl_setopt($ch, CURLOPT_TIMEOUT, 5);
$data = curl_exec($ch);
$httpcode = curl_getinfo($ch, CURLINFO_HTTP_CODE);
curl_close($ch);

print_r($data);
```

This PHP file do a cURL request to `index.php` of `test1` container using the alice `tl` instead of using host/IP address. This cURL request return the contents of `index.php` of `test1` container. It means container `test2` is linked with container `test1` with the alice `tl` and by this linking alice we can access all the resources of `test1` container from `test2` container. 

**Get the host/IP of test2 container**

`$ docker inspect --format '{{ .NetworkSettings.IPAddress }}' test2`.

Possible IP is: `172.17.0.3`. Now hit this IP on browser and you will see the page is showing a message: `This is a message from test1 container.`

That message is from `index.php` file of `test1` container.
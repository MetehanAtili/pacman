#!/bin/bash

# if docker container with name packman exists, stop and remove it
if [ "$(docker ps -q -f name=packman)" ]; then
    docker stop packman
    docker rm packman
fi

# create Dockerfile
cat <<EOF > Dockerfile
FROM nginx:alpine

COPY www /www
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD (tail -F /var/log/nginx/access.log &) && exec nginx -g "daemon off;"
EOF

# build docker image
docker build -t nginx:latest .

# run docker container with name packman and port 4000
docker run -d --name packman -p 4000:80 nginx:latest
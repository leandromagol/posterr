#!/bin/bash

docker-compose build
docker-compose up -d
docker exec -it posterr-app-1 rake db:create
docker exec -it posterr-app-1 rake db:migrate
docker exec -it posterr-app-1 rake db:reset
docker exec -it posterr-app-1 rake db:seed
echo 'Poster-api running on http://127.0.0.1:3000/'
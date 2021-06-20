#!/bin/bash

MCROOT=/home/minecraft/mc-root

if [ ! -d "/home/minecraft/paper-mc-docker" ]; then
	cd /home/minecraft/
	git clone https://github.com/brandon-gayne/paper-mc-docker.git
	echo "Added paper build repo"
fi

cd /home/minecraft

if [ ! -f "/home/minecraft/paper-mc-docker/.env" ]; then
	echo "MCROOT=/home/minecraft/paper-mc-docker" >> paper-mc-docker/.env
	echo "Added environment file"
fi

echo "Checking config and world files exist!"

for dir in world world_nether world_the_end config; do
	if [ ! -d "$MCROOT/$dir" ]; then
		mkdir $MCROOT/$dir
		echo "$dir added!"
	else
		echo "$dir exists!"
	fi
done

cd paper-mc-docker

echo "Building image!"

docker build . --no-cache -t mc

echo "Latest image built!"

docker-compose up -d
#!/bin/bash

MCROOT=/home/minecraft/mc-root
DSHOOK=$(cat /home/minecraft/.discord/.env)

if [! command -v discord.sh &> /dev/null ]; then
	git clone https://github.com/ChaoticWeg/discord.sh
	mv discord.sh/discord.sh /usr/bin/discord.sh
fi

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


function discord_message() {
	discord.sh --webhook-url=$DSHOOK --username "MC Updater Bot" --text "$1"
}

discord_message "Server going down for updates!"

cd paper-mc-docker

discord_message "Building new server image!"

docker build . --no-cache -t mc

discord_message "Latest image built!"

major=`curl https://papermc.io/api/v2/projects/paper | jq  -r '.version_groups[-1]'`
build=`curl https://papermc.io/api/v2/projects/paper/version_group/$major/builds | jq -r '.builds[-1].build'` 

discord_message "Server rebuilt with build #$build on Minecraft version $major"

docker-compose up -d 
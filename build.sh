#!/bin/bash

sudo docker build . --no-cache -t mc && sudo docker-compose up -d --build

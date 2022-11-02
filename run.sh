#!/bin/sh

docker build -t memlab . && docker run -p 9191:8080 memlab
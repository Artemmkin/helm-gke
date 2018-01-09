#!/bin/bash

docker build --build-arg VCS_REF=`git rev-parse --short HEAD` \
             --build-arg BUILD_DATE=`date -u +'%Y-%m-%d'` \
             -t artemkin/helm-gke:`git describe --abbrev=0 --tags` .

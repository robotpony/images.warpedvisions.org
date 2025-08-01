#!/bin/zsh

rsync -avz --exclude .gitignore --exclude .DS_Store --exclude .git/ --exclude deploy.sh --delete .  w28@w42.warpedvisions.org:~/images.warpedvisions.org/

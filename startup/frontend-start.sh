#!/bin/bash
cd /var/lightfeather-app/frontend/
npm ci
nohup npm start &
sleep 10
echo -ne "\n"

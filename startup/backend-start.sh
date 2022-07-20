#!/bin/bash
cd /var/lightfeather-app/backend/
npm ci
nohup npm start &
sleep 10
echo -ne "\n"

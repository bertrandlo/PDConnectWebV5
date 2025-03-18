@echo off

cd /d C:\Users\Administrator\Desktop\PDS-connected\backend

echo Fetching latest changes from remote...
git fetch origin dev

echo Forcing local files to match remote...
git reset --hard origin/dev

echo Stoping the old backend container...
docker stop pds-connected-backend

echo Deleting the old backend container...

docker rm pds-connected-backend

docker rmi backend-pds-connected-backend

echo Restaring the new backend container

docker compose -f docker-compose.prod.yml up -d

pause 
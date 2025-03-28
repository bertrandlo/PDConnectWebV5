@echo off
REM initial image and container
REM cd frontend;docker build . -t="pds-connected-client"
REM docker run -d --name="pds-connected-client" -p 5000:5000 pds-connected-client
cd /d C:\Users\Administrator\Desktop\PDS-connected\frontend

echo Deleting dist directory...
rmdir /s /q dist

echo Building the project for production environment...
call yarn build

echo Removing old nginx files from Docker container...
docker exec pds-connected-client rm -rf /usr/share/nginx

echo Copying new files to Docker container...
docker cp dist pds-connected-client:/usr/share/nginx


echo Restarting Docker container...
docker restart pds-connected-client

echo Deployment completed successfully!
pause

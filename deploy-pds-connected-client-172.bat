@echo off
REM initial image and container
REM cd frontend;docker build . -t="pds-connected-client"
REM docker run -d --name="pds-connected-client-172" -p 5001:5000 pds-connected-client
cd /d C:\Users\Administrator\Desktop\PDS-connected\frontend-172

echo Deleting dist directory...
rmdir /s /q dist

echo Checking out to original version to avoid conflicts caused by auto-generated files...
git checkout .

echo Pulling latest code from Git...
git pull

echo Run yarn install...
call yarn install

echo Building the project for production environment...
call yarn build

echo Removing old nginx files from Docker container...
docker exec pds-connected-client-172 rm -rf /usr/share/nginx

echo Copying new files to Docker container...
docker cp dist pds-connected-client-172:/usr/share/nginx


echo Restarting Docker container...
docker restart pds-connected-client-172

echo Deployment completed successfully!
pause

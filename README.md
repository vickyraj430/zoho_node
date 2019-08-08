# Data Driven Organization
###### Engage Well !
     
# Pre-Requisites    
1. Node JS v4.x (https://nodejs.org/en/download/)
2. npm v2.14.20 
3. Sencha Cmd v6.0.2.14
4. Sencha ExtJs 6.0.1 (https://www.sencha.com/)
5. Brackets v1.6.0 (http://brackets.io/)
6. Git (https://git-scm.com/downloads)

# Steps to Setup Project
1. Open Terminal cd to project directory
2. Run : npm install ( This command will isntall all the required node modules in to the project directory)
3. Copy the downloaded ExtJS 6.0.1 library folder to /project/directory/views/ with the name ext

# Project Directory Structure
1. Follow the link https://www.terlici.com/2014/08/25/best-practices-express-structure.html
2. In view folder ExtJS code lies


# Steps to run the Server
1. Change the port on which server should run in package.json. , default port configured is 3000. you can change it to any "config:{port:3000}"
2. Change the environment in package.json. The default environment is "devlopement". You can change it to "production" for deployment to production with "config:{env:'production'}". The available options are "devlopement/production/local". Only use "local" environment if you are outside the office network.
2. Open Terminal and cd to project directory
3. Run : node app . ( This command will start the server listening to the request from browser on the the port configured in package.json)


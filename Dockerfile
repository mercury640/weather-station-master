FROM node:14

RUN mkdir -p /home/service

WORKDIR /home/service/

COPY nodejs/* /home/service/

RUN npm install
 
EXPOSE 8080
 
CMD [ "npm", "start" ]

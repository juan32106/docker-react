FROM node:alpine as builder

RUN apk add zip

WORKDIR /usr/app

COPY ./package.json ./

RUN npm install

COPY ./ ./

RUN npm cache clean --force
RUN npm install > npm.log 2>&1
RUN npm run build

RUN zip -r npm.zip /usr/app/build

FROM nginx:alpine

WORKDIR /usr/share/nginx/html

RUN apk add unzip

COPY --from=builder /usr/app/npm.zip /usr/share/nginx/html/

RUN unzip npm.zip


FROM node:12.18.4-alpine3.12 as testbuild

# update packages
RUN apk update && apk upgrade && \
    apk add --no-cache bash git openssh

# Install pm2 list
RUN npm install pm2 -g

# create root application folder
WORKDIR /app

# copy configs to /app folder
COPY package*.json ./
#COPY ts*.json ./

# copy source code to /app/src folder
COPY . /app/
RUN npm install
RUN npm run build
FROM node:12.18.4-alpine3.12 as prod
WORKDIR /app

COPY package*.json ./
RUN npm install
COPY --from=testbuild /app/dist/ dist/

CMD [ "pm2-runtime", "./dist/index.js" ]


FROM node:14-alpine3.14

RUN apk update --no-cache

USER node
COPY --chown=node:node . /usr/src/app

WORKDIR /usr/src/app

COPY package*.json ./

# install and patch
RUN npm install && npm audit fix

COPY . .

EXPOSE 3000

CMD [ "npm", "start" ]


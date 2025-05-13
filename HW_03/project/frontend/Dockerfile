### Stage: 1 ###
FROM node:18-alpine3.21 AS build

WORKDIR /app

COPY package*.json .

RUN npm i

COPY . .

RUN npm run build
### Stage: 2 ###
FROM nginx:stable-alpine3.20-slim AS prod

WORKDIR /app

COPY ./nginx/nginx.conf /etc/nginx/nginx.conf.template
COPY ./entrypoint.sh /entrypoint.sh
COPY --from=build /app/build/ /usr/share/nginx/html

EXPOSE 3000

RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]

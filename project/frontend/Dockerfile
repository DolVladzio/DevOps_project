### Stage: 1 ###
FROM node:20-alpine AS build

WORKDIR /app
ENV REACT_APP_API_BASE_URL=/api

COPY package*.json /app/
RUN npm i
COPY . .

RUN npm run build
### Stage: 2 ###
FROM nginx:stable-alpine3.20-slim AS prod

WORKDIR /app

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/ /usr/share/nginx/html

CMD ["nginx", "-g", "daemon off;"]

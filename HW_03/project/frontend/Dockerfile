### Stage: 1 ###
FROM node:12.22.9-alpine AS build

WORKDIR /app

ARG REACT_APP_API_BASE_URL
ENV REACT_APP_API_BASE_URL=$REACT_APP_API_BASE_URL

COPY package*.json /app/
RUN npm ci
COPY . .

RUN npm run build
### Stage: 2 ###
FROM nginx:stable-alpine3.20-slim AS prod

WORKDIR /app

COPY ./nginx/nginx.conf /etc/nginx/conf.d/default.conf
COPY --from=build /app/build/ /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]

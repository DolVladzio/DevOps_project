# ### Stage: 1 ###
# FROM node:current-alpine3.21 AS build

# WORKDIR /app

# COPY package*.json .

# RUN npm i

# COPY . .

# RUN npm run build
# ### Stage: 2 ###
# FROM nginx:stable-alpine3.20-slim AS prod

# WORKDIR /app

# COPY --from=build /app/build/ /usr/share/nginx/html

# EXPOSE 80

# CMD ["nginx", "-g", "daemon off;"]

FROM node:current-alpine3.21

WORKDIR /app

COPY package*.json .

RUN npm i

COPY . .

CMD [ "npm", "start" ]

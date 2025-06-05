# Stage 1: Build
FROM gradle:7.5.1-jdk11 AS build

WORKDIR /app

COPY . .

RUN gradle clean --refresh-dependencies war
# Stage 2: Runtime
FROM tomcat:9.0.104-jre11-temurin-jammy

RUN apt-get update && apt-get install -y postgresql-client

COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

CMD ["catalina.sh", "run"]

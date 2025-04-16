### Build Stage ###
FROM gradle:7-jdk11 AS build

WORKDIR /app

COPY system.properties build.gradle settings.gradle pre-commit.gradle liquibase.gradle gradlew ./
COPY src/ src/
COPY config/ config/

RUN gradle clean war

### Production Stage ###
FROM tomcat:9.0.93-jdk11 AS prod

COPY --from=build /app/build/libs/*.war /usr/local/tomcat/webapps/ROOT.war

COPY scripts/ /scripts/

RUN apt-get update && \
    apt-get install -y --no-install-recommends postgresql-client && \
    rm -rf /var/lib/apt/lists/* && \
    chmod +x /scripts/*.sh

EXPOSE 8080

CMD ["catalina.sh", "run"]

# BUILD STAGE
FROM gradle:5.6-jdk12 AS build
COPY . /b
USER root
ENV BUILD_NUMBER=1
RUN cd /b && \
mkdir -p .git/refs .git/objects && \
echo 'ref: refs/heads/master' > .git/HEAD && \
gradle --refresh-dependencies init && \
gradle bootJar

FROM adoptopenjdk/openjdk12:latest

LABEL maintainer="Jon Herrmann" \
org.opencontainers.image.title="TITLE" \
org.opencontainers.image.description="DESCRIPTION" \
org.opencontainers.image.licenses="EUPL-1.2" \
org.opencontainers.image.documentation="https://github.com/repo-template" \
org.opencontainers.image.source="https://github.com/repo-template"

EXPOSE 8080
COPY --from= build /b/build/libs/*.jar /app.jar
RUN bash -c 'touch /app.jar'
ENTRYPOINT ["java","-Djava.security.egd=file:/dev/./urandom","-jar","/app.jar"]

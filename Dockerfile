FROM adoptopenjdk/openjdk11:x86_64-alpine-jdk-11.0.5_10 AS toBuildFakeMail
WORKDIR /data
COPY ./ /data
RUN apk add --no-cache git \
    && ./gradlew build \
    && mv build/libs/data-1.4.0.jar build/libs/fake-smtp-server.jar

FROM adoptopenjdk/openjdk11:x86_64-alpine-jdk-11.0.5_10
COPY --from=toBuildFakeMail /data/build/libs/fake-smtp-server.jar /opt/fake-smtp-server.jar
COPY entrypoint.sh /usr/local/bin/
RUN apk add --no-cache tini curl

EXPOSE 5080
EXPOSE 5081
EXPOSE 5025

ENV JAVA_OPTS=""
ENTRYPOINT ["tini", "--", "/usr/local/bin/entrypoint.sh"]
HEALTHCHECK --interval=30s --timeout=5s \
  CMD curl -f http://localhost:5080 || exit 1
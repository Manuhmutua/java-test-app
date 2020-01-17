FROM maven:3.6-jdk-8-alpine As builder
COPY . /app
WORKDIR /app
RUN mvn clean install

FROM openjdk:8-jre-alpine
COPY --from=builder /app/target/example-0.0.1-SNAPSHOT.jar /
RUN mkdir /user && \
    echo 'nobody:x:65534:65534:nobody:/:' > /user/passwd && \
    echo 'nobody:x:65534:' > /user/group
EXPOSE 8090
USER nobody:nobody
ENTRYPOINT ["java", "-Djava.security.egd=file:/dev/./urandom", "-jar", "/example-0.0.1-SNAPSHOT.jar"]
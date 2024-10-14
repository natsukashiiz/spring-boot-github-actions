FROM eclipse-temurin:17-jdk-alpine
WORKDIR /app
COPY target/spring-boot-github-actions-0.0.1-SNAPSHOT.jar server.jar
EXPOSE 8080
CMD ["java", "-jar", "server.jar"]
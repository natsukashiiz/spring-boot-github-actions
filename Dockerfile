FROM eclipse-temurin:17-jre-alpine
WORKDIR /app
COPY target/spring-boot-github-actions-0.0.1-SNAPSHOT.jar server.jar
EXPOSE 970
CMD ["java", "-jar", "server.jar"]
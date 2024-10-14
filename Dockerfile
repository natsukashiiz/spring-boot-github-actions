# First stage, build the custom JRE
FROM openjdk:17-jdk-slim AS jre-builder

# Install binutils, required by jlink
RUN apt-get update -y && \
    apt-get install -y binutils && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/*

# Build small JRE image
RUN jlink \
    --verbose \
    --add-modules java.base,java.compiler,java.desktop,java.instrument,java.management,java.naming,java.net.http,java.prefs,java.rmi,java.scripting,java.security.jgss,java.sql,jdk.jfr,jdk.unsupported \
    --strip-debug \
    --no-man-pages \
    --no-header-files \
    --compress=2 \
    --output /optimized-jdk-17

# Second stage, use the custom JRE and build the app image
FROM alpine:latest

# Set JAVA_HOME
ENV JAVA_HOME=/opt/jdk/jdk-17
ENV PATH="${JAVA_HOME}/bin:${PATH}"

# Copy JRE from the base image
COPY --from=jre-builder /optimized-jdk-17 $JAVA_HOME

# Ensure the JRE files have correct permissions
RUN chmod -R 755 $JAVA_HOME

# Add app user
ARG APPLICATION_USER=spring

# Create a user to run the application, don't run as root
RUN addgroup --system $APPLICATION_USER && \
    adduser --system $APPLICATION_USER --ingroup $APPLICATION_USER

# Create the application directory
RUN mkdir /app && chown -R $APPLICATION_USER /app

# Copy the jar file with the appropriate ownership
COPY --chown=$APPLICATION_USER:$APPLICATION_USER target/*.jar /app/app.jar

# Set the working directory
WORKDIR /app

# Switch to the application user
USER $APPLICATION_USER

# Expose the application port
EXPOSE 970

# Entry point to run the application
ENTRYPOINT ["java", "-jar", "/app/app.jar"]
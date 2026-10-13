# Multi-stage build for Spring Boot Gradle Application
# Stage 1: Build the JAR package
FROM eclipse-temurin:17-jdk-alpine AS builder

WORKDIR /app

# Copy gradle configuration and wrapper
COPY gradlew .
COPY gradle gradle
COPY build.gradle settings.gradle ./

# Grant execution rights to Gradle Wrapper
RUN chmod +x gradlew

# Copy source code and build application
COPY src src
RUN ./gradlew bootJar -x test --no-daemon

# Stage 2: Minimal runtime image
FROM eclipse-temurin:17-jre-alpine

WORKDIR /app

# Copy runnable jar from builder stage
COPY --from=builder /app/build/libs/*.jar app.jar

# Expose default application port
EXPOSE 8080

# Run Spring Boot application
ENTRYPOINT ["java", "-jar", "app.jar"]

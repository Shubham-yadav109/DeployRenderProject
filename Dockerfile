# Stage 1: Build using Maven
FROM maven:3.9.9-eclipse-temurin-17 AS builder

WORKDIR /app

# Copy pom.xml first (for dependency caching)
COPY pom.xml .
RUN mvn dependency:go-offline

# Copy source code
COPY src ./src

# Build jar
RUN mvn clean package -DskipTests

# Stage 2: Run app
FROM eclipse-temurin:17-jre

WORKDIR /app

# Copy jar from builder
COPY --from=builder /app/target/*.jar app.jar

# Expose port (Spring Boot)
EXPOSE 8080

# Run application
ENTRYPOINT ["java", "-jar", "app.jar"]

FROM maven:3.8.4-jdk-8-slim AS build
WORKDIR /app
COPY pom.xml .
RUN mvn dependency:go-offline
COPY src ./src
RUN mvn clean package -DskipTests

FROM eclipse-temurin:8-jdk
WORKDIR /app
COPY --from=build /app/target/login-0.1.0.jar ./login-service.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "login-service.jar"]


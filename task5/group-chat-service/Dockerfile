
FROM maven:3.8.4-jdk-8-slim AS build


WORKDIR /app

COPY pom.xml .
COPY src ./src

RUN mvn clean package -DskipTests

FROM eclipse-temurin:8-jdk

WORKDIR /app

COPY --from=build /app/target/groupchat-0.1.0.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]


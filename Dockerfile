FROM maven:3.9-eclipse-temurin-21 AS builder

WORKDIR /build

COPY app/pom.xml .
COPY app/src ./src
 
RUN mvn -q -DskipTests package



FROM eclipse-temurin:21-jre

RUN useradd --create-home --uid 1001 appuser

WORKDIR /app

COPY --from=builder /build/target/*.jar app.jar

USER appuser

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "app.jar"]


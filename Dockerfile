ARG BUILD_IMAGE=maven:3.9.16-eclipse-temurin-25
ARG RUNTIME_IMAGE=mcr.microsoft.com/openjdk/jdk:25-distroless

# ---------------------------------------------------
# Build an artifact
# ---------------------------------------------------
FROM ${BUILD_IMAGE} AS build
COPY pom.xml ./
COPY src ./src

RUN mvn -B clean dependency:copy-dependencies -DoutputDirectory=./target/lib package -Dmaven.test.skip

# ---------------------------------------------------
# Build container
# ---------------------------------------------------
FROM ${RUNTIME_IMAGE}
USER app
WORKDIR /opt/app
#COPY agent/applicationinsights-agent-3.7.7.jar applicationinsights-agent-3.7.7.jar
COPY --from=build /target/headerchecker-0.1.jar app.jar
EXPOSE 8080
#CMD ["-XX:+UseParallelGC","-XX:MaxRAMPercentage=75","-XX:InitialRAMPercentage=75","-XX:+UseStringDeduplication", "-javaagent:applicationinsights-agent-3.7.7.jar", "-jar", "app.jar"]
CMD ["-XX:+UseParallelGC","-XX:MaxRAMPercentage=75","-XX:InitialRAMPercentage=75","-XX:+UseStringDeduplication", "-jar", "app.jar"]

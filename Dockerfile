ARG BUILD_IMAGE=maven:3.9.9-eclipse-temurin-21
ARG CORE_IMAGE=mcr.microsoft.com/openjdk/jdk:21-distroless

# ---------------------------------------------------
# Build an artifact
# ---------------------------------------------------
FROM ${BUILD_IMAGE} as build
COPY pom.xml ./
COPY src ./src

RUN mvn -B clean dependency:copy-dependencies -DoutputDirectory=./target/lib package -Dmaven.test.skip

# ---------------------------------------------------
# Build container
# ---------------------------------------------------
FROM ${CORE_IMAGE}
USER app
WORKDIR /opt/app
COPY --from=build /target/headerchecker-0.1.jar app.jar
EXPOSE 8080
CMD ["-XX:+UseParallelGC","-XX:MaxRAMPercentage=75","-XX:InitialRAMPercentage=75","-XX:+UseStringDeduplication","-jar", "app.jar"]
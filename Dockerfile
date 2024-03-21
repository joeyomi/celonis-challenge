# checkov:skip=CKV_DOCKER_7: "Ensure the base image uses a non latest version tag"
# checkov:skip=CKV_DOCKER_2: "Ensure that HEALTHCHECK instructions have been added to container images"
# checkov:skip= CKV_DOCKER_3: "Ensure that a user for the container has been created"

# Build Stage.
FROM gradle:7.6.3-jdk-jammy AS build
COPY --chown=gradle:gradle . /home/gradle/src
WORKDIR /home/gradle/src
ARG API_KEY="dev"
RUN gradle build --no-daemon 


# Final Stage
FROM chainguard/jdk-lts:latest

EXPOSE 8080

COPY --from=build /home/gradle/src/build/libs/*.jar /spring-boot-application.jar

ENTRYPOINT ["java","-jar","/spring-boot-application.jar"]
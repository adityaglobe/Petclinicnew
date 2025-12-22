FROM openjdk:11-jre-slim
WORKDIR /app
COPY target/petclinic.war app.war
EXPOSE 8082
ENTRYPOINT ["java","-jar","app.war"]

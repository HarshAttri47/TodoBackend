# Use a lightweight OpenJDK 22 base image to build the application
FROM openjdk:22-slim as build

# Set the working directory
WORKDIR /app

# Copy the Maven wrapper files to the container
COPY .mvn .mvn
COPY mvnw pom.xml ./

# Copy the rest of the source code
COPY src ./src

# Build the application, skipping tests
RUN ./mvnw clean install -DskipTests

# Use a new, even smaller base image for the final, runnable application
FROM openjdk:22-slim

# Set the working directory
WORKDIR /app

# Expose the application port
EXPOSE 8080

# Copy the built jar file from the 'build' stage
COPY --from=build /app/target/*.jar ./app.jar

# Run the application
CMD ["java", "-jar", "app.jar"]
# Use official nginx image as the base image
FROM nginx:latest

ARG environment

# Copy the build output to replace the default nginx contents.
COPY ./dist/angular-build-once-deploy-anywhere /usr/share/nginx/html
# Copy the configuration file
COPY ./config/$environment.json /usr/share/nginx/html/assets/config.json

# Expose port 8080
EXPOSE 80

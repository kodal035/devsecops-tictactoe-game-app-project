# Build stage
FROM node:20-alpine AS build
WORKDIR /app
COPY package*.json ./
RUN npm ci
COPY . . 
RUN npm run build

# Production stage
FROM nginx:alpine

# Install and upgrade libxml2 in the production stage
RUN apk update && apk upgrade && apk add --no-cache libxml2

# Copy build artifacts from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

# Add nginx configuration if needed
# COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

# Stage 1: build
FROM node:16-alpine AS build
WORKDIR /app

# copy only package files first for caching
COPY package*.json ./
RUN npm ci

# copy rest and build
COPY . .
RUN npm run build

# Stage 2: serve with nginx
FROM nginx:stable-alpine
# remove default nginx content
RUN rm -rf /usr/share/nginx/html/*
# copy build output
COPY --from=build /app/build /usr/share/nginx/html
# copy custom nginx config to support SPA routing
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

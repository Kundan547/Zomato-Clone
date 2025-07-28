# ---- Build Stage ----
FROM node:18-alpine AS builder

# Set working directory
WORKDIR /app

# Copy package files
COPY package*.json ./

# Install all dependencies (including dev for build)
RUN npm install --legacy-peer-deps

# Copy source code
COPY . .

# Fix CRA eslint and OpenSSL issues
ENV SKIP_PREFLIGHT_CHECK=true
ENV NODE_OPTIONS=--openssl-legacy-provider

# Build React app
RUN npm run build

# ---- Production Stage ----
FROM nginx:alpine

# Copy build output to nginx html folder
COPY --from=builder /app/build /usr/share/nginx/html

# Expose HTTP port
EXPOSE 80

# Run nginx
CMD ["nginx", "-g", "daemon off;"]

FROM node:20-slim AS build

WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# ---- Serve with nginx ---- #
FROM nginx:alpine

# Copy assets (js, css, etc.)
COPY --from=build /app/dist/Angular-app/browser/ /usr/share/nginx/html/

# Copy main index.html
COPY --from=build /app/dist/Angular-app/index.html /usr/share/nginx/html/

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

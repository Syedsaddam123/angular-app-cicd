FROM nginx:alpine

COPY dist/Angular-app/browser /usr/share/nginx/html

EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]

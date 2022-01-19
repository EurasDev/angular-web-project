FROM nginx:1.17.1-alpine
WORKDIR /usr/share/nginx/html
COPY ./build/angular-app/dist/angular-app .
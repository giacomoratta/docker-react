# 1) "build" phase - - - - - - - - - - - - - - - - - - - - - - - - -
FROM node:alpine AS builder

WORKDIR '/app'

COPY package.json .
RUN npm install

# to make this step faster, remove local node_modules
COPY . .

# it will generate /build directory
RUN npm run build

# 2) "run" phase - - - - - - - - - - - - - - - - - - - - - - - - -

FROM nginx

EXPOSE 80

COPY --from=builder /app/build /usr/share/nginx/html

# No start CMD (nginx container will do automatically)

# docker build -f Dockerfile.prod .
# docker run -p 8080:80 <containerID>

# WARNING: AWS fails with named images!
#
# FROM node:alpine
# WORKDIR '/app'
# COPY package.json .
# RUN npm install
# COPY . .
# RUN npm run build
#
# FROM nginx
# COPY --from=0 /app/build /usr/share/nginx/html

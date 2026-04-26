FROM node:20-alpine AS build
ARG SUPERSPLAT_VERSION=2.24.4
WORKDIR /app
RUN apk add --no-cache git openssh-client
RUN git clone --branch "v$SUPERSPLAT_VERSION" --single-branch https://github.com/playcanvas/supersplat.git
WORKDIR /app/supersplat
RUN npm install
RUN npm run build

FROM node:20-alpine AS runtime
WORKDIR /app
RUN npm install -g serve
COPY --from=build /app/supersplat/dist ./dist
EXPOSE 3000
CMD ["serve", "dist", "-l", "3000", "-C"]

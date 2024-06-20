FROM node:18.20.3-alpine

WORKDIR /app

CMD ["node", "orchestration/api.mjs"]

RUN apk add --no-cache libc6-compat python3 make g++ curl

COPY ./package.json ./package-lock.json ./

RUN npm i

COPY circuits ./circuits
COPY config ./config
COPY build ./build
COPY orchestration ./orchestration
COPY proving-files ./proving-files

EXPOSE 3000

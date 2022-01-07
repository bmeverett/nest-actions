FROM node:14-alpine AS builder
WORKDIR /app
COPY ./package.json ./
COPY ./package-lock.json ./
RUN npm i
COPY . .
RUN npm run test
RUN npm run build


FROM builder
WORKDIR /app
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/node_modules ./
ENV NODE_ENV=production
RUN npm prune --production
COPY --from=builder /app/dist ./dist
RUN apk --no-cache add tini

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/main"]

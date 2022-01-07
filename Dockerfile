FROM node:14-alpine AS builder
WORKDIR /app
COPY ./package.json ./
COPY ./package-lock.json ./
COPY ./public ./public
RUN npm i
COPY . .
RUN npm run test
RUN npm run build


FROM builder
WORKDIR /app
ARG FLO_NPM_TOKEN
COPY --from=builder /app/.npmrc ./
COPY --from=builder /app/package.json ./
COPY --from=builder /app/package-lock.json ./
COPY --from=builder /app/public ./public
ENV NODE_ENV=production
RUN npm install --only=prod
COPY --from=builder /app/dist ./dist
RUN apk --no-cache add tini

EXPOSE 3000
ENTRYPOINT ["/sbin/tini", "--"]
CMD ["node", "dist/main"]

FROM node:10-alpine
HEALTHCHECK --interval=30s --timeout=3s \
    CMD curl -f http://localhost:8079 || exit 1
ENV NODE_ENV "production"
ENV PORT 8079
EXPOSE 8079
RUN addgroup mygroup && adduser -D -G mygroup myuser && mkdir -p /usr/src/app && chown -R myuser /usr/src/app

# Prepare app directory
WORKDIR /usr/src/app
COPY package.json /usr/src/app/
COPY yarn.lock /usr/src/app/
RUN chown myuser /usr/src/app/yarn.lock

USER myuser
RUN yarn install

COPY  helpers /usr/src/app
COPY  public /usr/src/app
COPY scripts /usr/src/app
COPY config.js /usr/src/app
COPY server.js /usr/src/app

# Start the app
CMD ["/usr/local/bin/npm", "start"]

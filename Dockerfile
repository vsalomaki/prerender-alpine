FROM node:22-alpine

ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
ENV MEMORY_CACHE=0
ENV BLACKLISTED_EXTS=ico,jpg,jpeg,png,ttf,eot,otf,woff,woff2,gif,svg,pdf,css,svg
ENV BLACKLISTED_DOMAIN=www.googletagmanager.com,googletagmanager.com,www.google-analytics.com,google-analytics.com,connect.facebook.net,lc.iadvize.com,fonts.gstatic.com,gstatic.com,i.ytimg.com,www.youtube.com,vimeo.com,www.vimeo.com,baidu.com,f.vimeocdn.com,fresnel.vimeocdn.com,player.vimeo.com,i.vimeocdn.com,youtube.com,player.youtube.com,stats.g.doubleclick.net,static.iadvize.com,api.iadvize.com
ENV BLACKLISTED_MATCH=^[^ignore]+$

# install chromium, tini
RUN apk add --no-cache chromium tini

USER node
WORKDIR "/home/node"

COPY ./package.json .
COPY ./server.js .

# install npm packages and clear cache
RUN npm install --no-package-lock \
    && npm cache clean --force \
    && rm -rf /var/cache/apk/* /tmp/*

EXPOSE 3000

ENTRYPOINT ["tini", "--"]
CMD ["node", "server.js"]

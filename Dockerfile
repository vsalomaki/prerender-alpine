FROM node:12-alpine
ENV CHROME_BIN=/usr/bin/chromium-browser
ENV CHROME_PATH=/usr/lib/chromium/
ENV MEMORY_CACHE=0
ENV BLACKLISTED_EXTS=ico,jpg,jpeg,png,ttf,eot,otf,woff,woff2,gif,svg,pdf,css,svg
ENV BLACKLISTED_DOMAIN=www.googletagmanager.com,googletagmanager.com,www.google-analytics.com,google-analytics.com,connect.facebook.net,lc.iadvize.com,fonts.gstatic.com,gstatic.com,i.ytimg.com,www.youtube.com,vimeo.com,www.vimeo.com,baidu.com,f.vimeocdn.com,fresnel.vimeocdn.com,player.vimeo.com,i.vimeocdn.com,youtube.com,player.youtube.com,stats.g.doubleclick.net,static.iadvize.com,api.iadvize.com
ENV BLACKLISTED_MATCH=^[^ignore]+$

COPY ./package.json .
COPY ./server.js .

# install chromium and clear cache
RUN apk add --update-cache chromium \
 && rm -rf /var/cache/apk/* /tmp/*

# install npm packages
RUN npm install --no-package-lock

EXPOSE 3000

CMD ["node", "server.js"]

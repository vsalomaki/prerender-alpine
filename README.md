# Prerender Alpine

Lightweight Prerender container built on Alpine Linux with Node and Headless Chrome.

- Prerender 5.6.0
- Chromium 81.0.4044.113
- Node 12.16.3

This package includes https://github.com/kenylieou/prerender-request-blacklist

## Requirements

- Docker

## Usage

Pull and run the image:

```
docker pull tvanro/prerender-alpine:6.1.0
docker run -p 3000:3000 tvanro/prerender-alpine:6.1.0
```
Prerender will now be running on http://localhost:3000. Try the container out with curl:

```
curl http://localhost:3000/render?url=https://www.example.com/
```

## Prerender plugins

A few default plugins have been activated by default (see `server.js`):
- https://github.com/prerender/prerender/blob/master/lib/plugins/blacklist.js
- https://github.com/prerender/prerender/blob/master/lib/plugins/httpHeaders.js
- https://github.com/prerender/prerender/blob/master/lib/plugins/removeScriptTags.js

This can be modified by creating your own `server.js` and mounting this file as a docker volume:

```
docker run -p 3000:3000 -v $(pwd)/server.js:/server.js tvanro/prerender-alpine:6.1.0 
```

## Prerender memory cache

The [prerender-memory-cache](https://github.com/prerender/prerender-memory-cache) plugin is not activated by default.
You can activate it with the environment variable `MEMORY_CACHE=1`.

You can customize cache behavior with environment variables :
- CACHE_MAXSIZE=1000 : max number of objects in cache
- CACHE_TTL=6000 : time to live in seconds

```
docker run -p 3000:3000 -e MEMORY_CACHE=1 -e CACHE_MAXSIZE=1000 -e CACHE_TTL=6000 tvanro/prerender-alpine:6.1.0 
```

## Options

Possibility to add domain redirects from environment variable like this:
```
MAP_DOMAIN_TO_LOCALHOST=example.com,host.docker.internal
```
This will cause chromium to resolve *.example.com to host.docker.internal. Wildcard is added automatically.

List of blacklist data separated by `,` 

```bash
export BLACKLISTED_EXTS=css,jpg
export BLACKLISTED_DOMAIN=google.com
export BLACKLISTED_MATCH=regex_pattern
```


For example:

```bash
export BLACKLISTED_EXTS=ico,jpg,jpeg,png,ttf,eot,otf,woff,woff2,gif,svg,pdf,css,svg
export BLACKLISTED_DOMAIN=www.googletagmanager.com,googletagmanager.com,www.google-analytics.com,google-analytics.com,connect.facebook.net,lc.iadvize.com,fonts.gstatic.com,gstatic.com,i.ytimg.com,www.youtube.com,vimeo.com,www.vimeo.com,baidu.com,f.vimeocdn.com,fresnel.vimeocdn.com,player.vimeo.com,i.vimeocdn.com,youtube.com,player.youtube.com,stats.g.doubleclick.net,static.iadvize.com,api.iadvize.com
export BLACKLISTED_MATCH=^[^ignore]+$
export MAP_DOMAIN_TO_LOCALHOST=example.com,localhost
```


## Prerender documentation

Check out the official Prerender documentation: https://github.com/prerender/prerender

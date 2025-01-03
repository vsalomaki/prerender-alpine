"use strict";

const prerender = require("prerender");
const prMemoryCache = require("prerender-memory-cache");

var chromeFlags = [
  "--no-sandbox",
  "--headless",
  "--disable-gpu",
  "--remote-debugging-port=9222",
  "--hide-scrollbars",
  "--disable-dev-shm-usage",
  "--ignore-certificate-errors",
];

if (process.env.PROXY) {
  const proxySetting = `--proxy-server="${process.env.PROXY}"`;
  chromeFlags.push(proxySetting);
  console.log("Using proxy setting " + proxySetting);
}

if (process.env.MAP_DOMAIN_TO_LOCALHOST) {
  const isFQDN = require("is-fqdn");
  const setting = process.env.MAP_DOMAIN_TO_LOCALHOST.trim().split(",");
  if (setting.length > 0) {
    const domain = setting[0];
    const target = setting.length > 1 ? setting[1] : "localhost";

    if (isFQDN(domain)) {
      const addStr = "--host-resolver-rules=MAP *." + domain + " " + target;
      console.log("Mapping *." + domain + " to " + target);
      chromeFlags.push(addStr);
    } else {
      console.log(domain + " is not an FQDN");
    }
  }
}

const server = prerender({
  chromeFlags: chromeFlags,
  forwardHeaders: true,
  chromeLocation: "/usr/bin/chromium-browser",
});

const memCache = Number(process.env.MEMORY_CACHE) || 0;
if (memCache === 1) {
  server.use(prMemoryCache);
}

server.use(prerender.blacklist());
server.use(prerender.httpHeaders());
server.use(prerender.removeScriptTags());
if (process.env.ALLOWED_DOMAINS) {
  server.use(prerender.whitelist());
}
server.use(require("prerender-request-blacklist"));

server.start();

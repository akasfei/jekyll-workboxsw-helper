# jekyll-workboxsw-helper

Generate precache manifest for workboxSW.

`_config.yml`

```
workboxsw_helper:
  workbox_url: "/workbox/workbox-sw.js"
  clients_claim: "true"
  skip_waiting: "true"
  cache_first: "/\\.(?:png|gif|jpg|jpeg|svg|ico)$/"
  precache:
    - "/index.html"
    - "/workbox/workbox-sw.js"
  precache_all_regex: "\\.(?:png|gif|jpg|jpeg|svg|ico)$"
```

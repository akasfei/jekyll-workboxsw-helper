Jekyll::Hooks.register :site, :post_write do |site|
  config = site.config["workboxsw_helper"]
  sw_code = "importScripts('%s');\n\n" % (config["workbox_url"] || "workbox/workbox-sw.js")
  sw_code += "const workboxSW = new WorkboxSW({clientsClaim: %s, skipWaiting: %s});\n" % [config["clients_claim"] || "true", config["skip_waiting"] || "true"]
  sw_code += "workboxSW.router.registerRoute(%s, workboxSW.strategies.cacheFirst());\n\n" % (config["cache_first"] || "/\\.(?:png|gif|jpg|jpeg|svg|ico|js)$/")
  md5 = Digest::MD5.new
  cache_minimal = []
  config["precache"].each do |file|
    md5.reset
    md5 << File.read("%s/%s" % [site.dest, file])
    cache_minimal.push("\n  { url: \"%s\", revision: \"%s\" }" % [file, md5.hexdigest])
  end
  sw = File.new(site.in_dest_dir("sw.js"), "w")
  sw.puts(sw_code)
  sw.puts("workboxSW.precache([%s\n]);\n" % cache_minimal.join(","))
  sw.close
  cache_all = [].concat(cache_minimal)
  filter = Regexp.new(config["precache_all_regex"])
  site.static_files.each do |file|
    if filter.match?(file.relative_path)
      md5.reset
      md5 << File.read("%s/%s" % [site.dest, file.relative_path])
      cache_all.push("\n  { url: \"%s\", revision: \"%s\" }" % [file.relative_path, md5.hexdigest])
    end
  end
  sw_all = File.new(site.in_dest_dir("sw-precache-all.js"), "w")
  sw_all.puts(sw_code)
  sw_all.puts("workboxSW.precache([%s\n]);\n" % cache_all.join(","))
  sw_all.close
end

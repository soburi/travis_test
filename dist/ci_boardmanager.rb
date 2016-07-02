require 'json'
require 'digest'
require 'optparse'
require 'open-uri'

template = ''
jsonfile = ''
pkg_url= ''
release = ''
repo_url = ''

opt = OptionParser.new
opt.on('-t FILE', '--template=FILE') {|o| template = o }
opt.on('-j FILE', '--json=FILE') {|o| jsonfile = o }
opt.on('-u PACKAGE_URL', '--url=PACKAGE_URL') {|o| pkg_url= o }
opt.on('-r RELEASE', '--release=RELEASE') {|o| release = o }
opt.on('-g GH_REPO_URL', '--gh-repo=GH_REPO_URL') {|o| repo_url = o }
opt.parse!(ARGV)

slug = repo_url.sub(/https:\/\/github.com\//,'').sub(/\.git$/,'')
user_repo = slug.split('/')
ghpage_url = "https://#{user_repo[0]}.github.io/#{user_repo[1]}/#{jsonfile}"
STDERR.puts("ghpage_url #{ghpage_url}\n")
STDERR.puts("repo_url #{repo_url}\n")

entry = nil
open(template) do |j|
  entry = JSON.load(j)
end

open(ghpage_url) do |f|
  bmdata = JSON.load(f)
  packages = bmdata['packages']
  root = packages[0]
  pkgs = root["platforms"]

  raise if pkgs.find {|x| x["version"] == release} != nil

  pkg_url = pkg_url
  STDERR.puts("pkg_url #{pkg_url}\n")

  open(pkg_url) do |ff|
    entry["url"] = pkg_url
    entry["version"] = release
    entry["archiveFileName"] = pkg_url.sub(/^.*\//, '')
    entry["checksum"] =  "SHA-256:" + Digest::SHA256.hexdigest(ff.read)
    entry["size"] =  "#{ff.size}"
  end

  pkgs.unshift(entry)

  newjson = JSON.pretty_generate(bmdata)
  STDOUT.puts(newjson)
end


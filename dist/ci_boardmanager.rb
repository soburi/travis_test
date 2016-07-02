require 'json'
require 'ostruct'
require 'digest'
require 'git'
require 'optparse'
require 'open-uri'

template = ''
jsonfile = ''
archivename = ''
release = ''

opt = OptionParser.new
opt.on('-t FILE', '--template=FILE') {|o| template = o }
opt.on('-j FILE', '--json=FILE') {|o| jsonfile = o }
opt.on('-a FILE', '--archive=FILE') {|o| archivename= o }
opt.on('-r RELEASE', '--release=RELEASE') {|o| release = o }
opt.parse!(ARGV)

if ENV.key?('TRAVIS_REPO_SLUG')
  slug = ENV['TRAVIS_REPO_SLUG']
else
  g = Git.open('.')
  slug = g.config['remote.origin.url'].sub(/^https:\/\/github.com\//, "").sub(/\.git$/, "")
end

user_repo = slug.split('/')
p slug
p user_repo
ghpage_url = "https://#{user_repo[0]}.github.io/#{user_repo[1]}/#{jsonfile}"
STDERR.puts("ghpage_url #{ghpage_url}\n")
repo_url   = "https://github.com/#{slug}"
STDERR.puts("repo_url #{repo_url}\n")

entry = nil
open(template) do |j|
  entry = JSON.load(j)
end

open(ghpage_url) do |f|
  bmdata = JSON.load(f)
  p bmdata
  packages = bmdata['packages']
  root = packages[0]
  pkgs = root["platforms"]

  raise if pkgs.find {|x| x["version"] == release} != nil

  pkg_url = "#{repo_url}/releases/download/#{release}/#{archivename}"
  STDERR.puts("pkg_url #{pkg_url}\n")
  open(pkg_url) do |ff|
    entry["url"] = pkg_url
    entry["version"] = release
    entry["archiveFileName"] = pkg_url.sub(/^.*\//, '')
    entry["checksum"] =  "SHA-256:" + Digest::SHA256.hexdigest(File.binread(ff))
    entry["size"] =  "#{ff.size}"
  end

  pkgs.unshift(entry)

  newjson = JSON.pretty_generate(bmdata)
  STDOUT.puts(newjson)
end


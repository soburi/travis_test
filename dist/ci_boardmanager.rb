require 'json'
require 'ostruct'
require 'digest'
require 'git'
require 'optparse'
require 'open-uri'

template = ''
jsonfile = ''
pkg_url= ''
release = ''

opt = OptionParser.new
opt.on('-t FILE', '--template=FILE') {|o| template = o }
opt.on('-j FILE', '--json=FILE') {|o| jsonfile = o }
opt.on('-u PACKAGE_URL', '--url=PACKAGE_URL') {|o| pkg_url= o }
opt.on('-r RELEASE', '--release=RELEASE') {|o| release = o }
opt.parse!(ARGV)

if ENV.key?('TRAVIS_REPO_SLUG')
  slug = ENV['TRAVIS_REPO_SLUG']
else
  g = Git.open('.')
  slug = g.config['remote.origin.url'].sub(/^https:\/\/github.com\//, "").sub(/\.git$/, "")
end

user_repo = slug.split('/')
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
  packages = bmdata['packages']
  root = packages[0]
  pkgs = root["platforms"]

  raise if pkgs.find {|x| x["version"] == release} != nil

  pkg_url = pkg_url
  STDERR.puts("pkg_url #{pkg_url}\n")

  retry_count = 0
  begin
    open(pkg_url) do |ff|
      entry["url"] = pkg_url
      entry["version"] = release
      entry["archiveFileName"] = pkg_url.sub(/^.*\//, '')
      entry["checksum"] =  "SHA-256:" + Digest::SHA256.hexdigest(File.binread(ff))
      entry["size"] =  "#{ff.size}"
    end
  rescue => e
    sleep 10
    retry_count = retry_count + 1

    if retry_count > 6
      abort e.message
    end

    retry
  end

  pkgs.unshift(entry)

  newjson = JSON.pretty_generate(bmdata)
  STDOUT.puts(newjson)
end


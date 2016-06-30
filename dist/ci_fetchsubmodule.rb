#!/usr/bin/ruby

require 'rubygems'
require 'json'
require 'open-uri'
require 'zip'

JSON.parse(ARGF.read).each do |e|
  zipurl = e['url'] + '/archive/' + e['revision'] + '.zip'
  p zipurl
  open(zipurl) do |arc|
    Zip::File.open(arc) do |zip|
      zip.each do |entry|
        p (e['path'] + '/' + entry.name.sub(/^[^\/]*\//, '') )
        entry.extract(e['path'] + '/' + entry.name.sub(/^[^\/]*\//, '') )
      end
    end
  end
end

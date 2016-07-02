require 'git' 

reponame   = 'unknown'
branchname = 'unknown'

if ENV.key?('TRAVIS_REPO_SLUG')
  reponame = File.basename(ENV['TRAVIS_REPO_SLUG'])
else
  reponame = g.config['remote.origin.url'].sub(/^.*\//, "").sub(/\.git$/, "")
end

if ENV.key?('TRAVIS_BRANCH')
  branchname = ENV['TRAVIS_BRANCH']
else 
  branchname = g.branches.select {|br| br.current }[0].full
  if branchname =~ /\((.*)\)/
    tmp = $1
    tmp =~ /^(.*\ )(.*)$/
    branchname = $2
  end
end


print(reponame + '-' + branchname)

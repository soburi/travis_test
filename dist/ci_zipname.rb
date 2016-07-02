require 'git' 

reponame   = 'unknown'
branchname = 'unknown'

if ENV['TRAVIS_TAG'] != ""
  if ENV['TRAVIS_REPO_SLUG'] != ""
    reponame = File.basename(ENV['TRAVIS_REPO_SLUG'])
  else
    reponame = g.config['remote.origin.url'].sub(/^.*\//, "").sub(/\.git$/, "")
  end

  if ENV['TRAVIS_BRANCH'] != ""
    branchname = ENV['TRAVIS_BRANCH']
  else 
    branchname = g.branches.select {|br| br.current }[0].full
    if branchname =~ /\((.*)\)/
      tmp = $1
      tmp =~ /^(.*\ )(.*)$/
      branchname = $2
    end
  end
else
  if ENV['TRAVIS_COMMIT'] != ""
    print(ENV['TRAVIS_COMMIT'])
    return
  end
end

print(reponame + '-' + branchname)


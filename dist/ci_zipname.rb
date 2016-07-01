require 'git' 

g = Git.open('.')

gbasename = g.config['remote.origin.url'].sub(/^.*\//, "")
lastupdate = g.log(1)[0].date.strftime( '%Y%m%d%H%M%S')
branchname = g.branches.select {|br| br.current }[0].full

print( gbasename + '-' + branchname + '-' + lastupdate)

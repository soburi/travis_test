 require 'git' 
 
print Git.open('.').log(1)[0].date.strftime( '%Y%m%d%H%M%S')

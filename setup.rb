
# standard ruby program to build the extension

#This will build the gem and push to gemcutter (only used by the admin)
#You can use this locally and distribute the gem to a local network for installs
if ARGV[0] == 'build'
  `gem build tclink.gemspec`
  #gem push tclink-3.4.4.gem
else #assume install

  #move into ext directory
  prevdir = Dir.pwd
  Dir.chdir File.dirname(__FILE__) + "/ext"

  #run extconf
  require './extconf'

  #make the shared library
  #install the shared library

  `make print install`

  Dir.chdir prevdir
end

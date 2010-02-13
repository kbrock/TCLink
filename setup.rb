
# standard ruby program to build the extension

#move into ext directory
prevdir = Dir.pwd
Dir.chdir File.dirname(__FILE__) + "/ext"

#run extconf
require './extconf'
#make the shared library
`make`

Dir.chdir prevdir

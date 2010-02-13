#
# create the make file and all necessary files to compile
#

#NOTE: this must be run from the ext directory

require 'mkmf'

unless File.exist?("config.h")

  # determine the platform name
  uname=`uname -sm | tr ' ' -`.chomp

  # determine ruby version (just read out of the gemspec file)
  # it will have a line that reads s.version = '3.4.4'
  #   find the lines (grep)
  #   select the first
  #   cut up on quote (split)
  #   and pick the part that is in the quotes [1]

  version =''
  File.open("../tclink.gemspec", "r") { |f|
    version = f.read.grep(/s\.version/).first.split(/['"]/)[1]
  }

  #must at least have 3 digits in version string (e.g. "3.4")
  raise "could not determine version from spec file" unless version && version.size > 2

  # config.h file sets TCLINK_VERSION with approperiate environment information
  File.open("config.h", "w") do |f|
    f.puts "#define TCLINK_VERSION \"#{version}-Ruby-#{uname}\""
  end
end

have_library("crypto", "CRYPTO_lock")
have_library("ssl", "SSL_connect")
create_makefile("tclink")

require 'rubygems' unless defined?(Gem)

spec=Gem::Specification.new do |s|
  s.name = 'tclink'
#note: extconf takes version out of this file
  s.version = '3.4.4'
  s.summary = "TCLink Trust Commerce link"
  s.description = "Trust Commerce connectivity layer"
  s.homepage = "http://trustcommerce.com"
  s.require_path = 'ext'
  # s.has_rdoc = false
  #s.author = "Some Person"
  s.email = "developer@trustcommerce.com"
  s.extensions = ["ext/extconf.rb"]

  s.files = %w[
    LICENSE README doc/TCDevGuide.html doc/TCDevGuide.txt
    ext/depend ext/extconf.rb ext/tclink.h ext/tclink.c ext/rb_tclink.c
    setup.rb tctest.rb tclink.gemspec]
  s.files
end

if $0 == __FILE__
  #Gem::manage_gems
  #Gem::Builder.new(spec).build
  require 'rubygems/gem_runner'
  Gem::GemRunner.new.run ['build', 'tclink.gemspec']
end

spec

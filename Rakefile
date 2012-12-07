require 'rake/testtask'

task :default => :example

task :example do
  `bin/parade serve example`
end

begin
  require 'mg'
rescue LoadError
  abort "Please `gem install mg`"
end

MG.new("parade.gemspec")

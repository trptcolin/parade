require_relative '../spec_helper'

Dir[File.join(File.dirname(__FILE__),'..','..','fixtures','parsers','*')].each do |md|

  fixture_name = File.basename(md).gsub('.md','').upcase
  markdown_contents = File.read(md)
  Kernel.const_set(fixture_name,markdown_contents)

end


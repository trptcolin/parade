require_relative '../spec_helper'

Dir[File.join(File.dirname(__FILE__),'..','..','fixtures','renderers','*.html')].each do |md|

  fixture_name = File.basename(md).gsub('.html','').upcase
  markdown_contents = File.read(md)
  Kernel.const_set(fixture_name,markdown_contents)

end


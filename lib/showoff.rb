require 'rubygems'
require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'fileutils'
require 'logger'
require 'tilt'

begin
  require 'RMagick'
rescue LoadError
  $stderr.puts 'image sizing disabled - install rmagick'
end

begin
  require 'pdfkit'
rescue LoadError
  $stderr.puts 'pdf generation disabled - please install `pdfkit` and `wkhtmltopdf-binary`'
end

require_relative 'showoff/server'
require_relative 'showoff/utilities'
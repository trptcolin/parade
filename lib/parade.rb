require 'rubygems'
require 'sinatra/base'
require 'json'
require 'nokogiri'
require 'fileutils'
require 'logger'
require 'tilt'
require 'css_parser'

begin
  require 'RMagick'
rescue LoadError
  $stderr.puts %{
--------------------------------------------------------------------------------
  Please install RMagick:

  $ gem install rmagick

  RMagick is required for:

    * Static output to ensure images are included with the documents
    * Web rendering, auto-re-sizing of images
--------------------------------------------------------------------------------
}
end

begin
  require 'pdfkit'
rescue LoadError
  $stderr.puts  %{
--------------------------------------------------------------------------------
  Please install PDFKit and wkhtmltopdf-binary:

  $ gem install pdfkit
  $ gem install wkhtmltopdf-binary

  PDFKit and wkhtmltopdf-binary are required to provide PDF output
--------------------------------------------------------------------------------
}
end

require 'parade/helpers/encode_image'
require 'parade/server'
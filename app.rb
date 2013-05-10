require 'rubygems'
require 'bundler/setup'

require 'sinatra'
require 'haml'
require 'net/http'
require_relative 'lib/weather'
require_relative 'lib/xml_reader'
require_relative 'lib/populator'
require_relative 'lib/classifier'

$reader = XmlReader.new
$populator = Populator.new
$classifier = Classifier.new
$uri = URI('http://www.yr.no/place/Sweden/Stockholm/Stockholm/forecast.xml')

get '/' do
  forecast = Net::HTTP.get($uri)
  xml = $reader.read(forecast)
  weather = $populator.populate(xml)
  @desc = $classifier.apply(weather)
  haml :index
end

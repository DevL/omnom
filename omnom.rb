require 'nemah'
require 'sinatra'
require "sinatra/reloader" if development?

get '/' do
  'Om nom nom...nom!'
end

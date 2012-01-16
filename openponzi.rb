require 'rubygems'
require 'sinatra'

configure :production do

end

configure :development do

end

configure :test do

end

# let's see something
get '/' do
  "Hello World!"
end


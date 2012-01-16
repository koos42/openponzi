require 'rubygems'
require 'sinatra'
require 'datamapper'

enable :sessions

helpers do
  # Helpers?
end

DataMapper.setup(:default, ENV['DATABASE_URL'] || "sqlite://#{Dir.pwd}/my.db")

class Schemer
  include DataMapper::Resource

  property :id,           Serial
  property :facebook_id,  String
  
  has n, :children, :child_key => [:child_id]
end

class Child
  include DataMapper::Resource

  belongs_to :parent, 'Schemer', :key => true
  belongs_to :child,  'Schemer', :key => true
end


DataMapper.finalize
DataMapper.auto_upgrade!

# let's see something
get '/*' do
  erb :index
end



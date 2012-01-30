require 'rubygems'
require 'sinatra'
require 'datamapper'
require 'omniauth'

require 'omniauth-twitter'
require 'omniauth-facebook'

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

use Rack::Session::Cookie # for OmniAuth
use OmniAuth::Builder do
  provider :facebook, 206051896150651, '8ad7b4f457075e4de89785d50e570ef0'
  provider :twitter,  '630QTNeBiMkj2NdI28utfA', 'Iq3A3ZmY5J8TvyeZCUuffhSUnGl9UOeHmDtHnYVzRs'
end

# let's see something
get '/' do
  erb :index
end

get '/auth/:name/callback' do 
  @auth = request.env['omniauth.auth']
  session[:auth] = @auth
  if session[:redirect]
    redirect session.delete(:redirect)
  else
    erb :callback 
  end
end

def require_login( redir )
  if session[:auth].nil_or_empty?
    session[:redirect] = redir
    redirect 'auth/facebook'
  end
end

def hash_helper(h,indent)
  ret_val = ""
  if h.kind_of? Hash
    h.each do |k,v|
      indent.times do ret_val += "&nbsp;&nbsp;"; end
      ret_val += "#{k} -- #{hash_helper(v,indent+1)}<br/>"
    end
  else
    ret_val += h.inspect
  end
  ret_val
end

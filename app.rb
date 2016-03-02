require 'sinatra'
require "sinatra/multi_route"
require 'httparty'
require 'json'

require 'dotenv'
Dotenv.load

class ExampleApp < Sinatra::Base
  register Sinatra::MultiRoute

  # Config
  callback = 'http://localhost:9292/auth/mlh/callback'
  client_id = ENV['MYMLH_APP_ID']
  client_secret = ENV['MYMLH_SECRET']

  # Helpers

  def fetch_user(access_token)
    base_url = "https://my.mlh.io/api/v1/user"
    qs = URI.encode_www_form({'access_token': access_token})


    HTTParty.get("#{base_url}?#{qs}").to_json
  end

  get '/' do
    "<a href='/auth/mlh'>Login with MLH</a>"
  end

  get '/auth/mlh' do  
    base_url = "https://my.mlh.io/oauth/authorize"

    qs = URI.encode_www_form(
      'client_id': client_id,
      'redirect_uri': callback,
      'response_type': 'code'
    )

    redirect "#{base_url}?#{qs}"
  end

  route :get, :post, '/auth/mlh/callback' do
    base_url = "https://my.mlh.io/oauth/token"
    code = params[:code]

    headers = { 'Content-Type' => 'application/json' }
    body = {
      'client_id': client_id,
      'client_secret': client_secret,
      'code': code,
      'grant_type': 'authorization_code',
      'redirect_uri': callback
    }.to_json

    resp = HTTParty.post( base_url, body: body, headers: headers )
    user = fetch_user(resp['access_token'])
    return user
  end
end
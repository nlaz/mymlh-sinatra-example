require 'sinatra'
require "sinatra/multi_route"
require 'httparty'
require 'json'

require 'dotenv'
Dotenv.load

class ExampleApp < Sinatra::Base
  register Sinatra::MultiRoute

  # Config
  callback = ENV['MYMLH_CALLBACK']
  client_id = ENV['MYMLH_APP_ID']
  client_secret = ENV['MYMLH_SECRET']

  # Helpers

  def fetch_user(access_token)
    base_url = "https://my.mlh.io/api/v1/user"
    qs = URI.encode_www_form({'access_token': access_token})

    # Tokens don't expire, but users can reset them, so best to do some error
    # handling here too.
    HTTParty.get("#{base_url}?#{qs}").to_json
  end

  # Routes

  get '/' do
    "<a href='/auth/mlh'>Login with MLH</a>"
  end

  get '/auth/mlh' do  
    # Step 1: Request an Authorization Code from My MLH by directing a user to
    # your app's authorize page.
    base_url = "https://my.mlh.io/oauth/authorize"

    qs = URI.encode_www_form(
      'client_id': client_id,
      'redirect_uri': callback,
      'response_type': 'code'
    )

    redirect "#{base_url}?#{qs}"
  end

  route :get, :post, '/auth/mlh/callback' do
    # Step 2: Assuming the user clicked authorize, we should get an Authorization
    # Code which we can now exchange for an access token.
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

    # Step 3: Now we should have an access token which we can use to get the
    # current user's profile information.  In a production app you would
    # create a user and save it to your database at this point.

    resp = HTTParty.post( base_url, body: body, headers: headers )
    user = fetch_user(resp['access_token'])
    return user
  end
end
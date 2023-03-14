# frozen_string_literal: true
require 'net/http'

class Oauth::GetToken < ApplicationService
  def call
    client_id = ''
    client_secret = ''
    
    uri = URI('https://oauth.battle.net/token')
    req = Net::HTTP::Post.new(uri)
    req.basic_auth client_id, client_secret
    req.content_type = 'application/x-www-form-urlencoded'

    req.set_form_data({
      'grant_type' => 'client_credentials'
    })

    req_options = {
      use_ssl: uri.scheme == 'https'
    }
    res = Net::HTTP.start(uri.hostname, uri.port, req_options) do |http|
      http.request(req)
    end

    JSON.parse(res.body).try(:[], 'access_token')
  end
end

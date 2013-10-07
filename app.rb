require 'faraday'
require 'sinatra'
require 'uri'
 
def send_message(message)
  conn = Faraday.new(:url => 'https://api.mailgun.net/v2') do |faraday|
    faraday.request  :url_encoded
    faraday.response :logger
    faraday.adapter  Faraday.default_adapter
  end

  conn.basic_auth('api', ENV['MAILGUN_KEY'])

  params = {
    :from => 'whisper <hidden@email.com>',
    :to => ENV['TARGET_EMAIL'],
    :subject => 'notes',
    :text => message
  }

  conn.post(ENV['MAILGUN_USERNAME']+'.mailgun.org/messages', params)
end

get '/*' do
  if request.query_string.empty?
    ":("
  else
  # body of email is everything following ? in http request
    send_message(URI.unescape(request.query_string))
    ":)"
  end
end
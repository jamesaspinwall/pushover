require "net/https"

def pushover(message)
  url = URI.parse("https://api.pushover.net/1/messages.json")
  req = Net::HTTP::Post.new(url.path)
  req.set_form_data(
      {
          :token => "au9x1jpb6of8rp81cvxvt5qj4tph6v",
          :user => "upxpu88ksz1xxwad35unfj7uokczj4",
          :message => message,
      })
  res = Net::HTTP.new(url.host, url.port)
  res.use_ssl = true
  res.verify_mode = OpenSSL::SSL::VERIFY_PEER
  res.start { |http| http.request(req) }
end

pushover('Hi')

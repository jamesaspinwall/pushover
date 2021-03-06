require 'chronic'
require 'csv'
require 'celluloid/current'
require "net/https"

class TimerExample
  include Celluloid

  def aftr(message)
    at = Chronic.parse(message.delete(:at))
    if at.nil?
      puts "Error: Chronic #{message.at}"
    else
      n = at - Time.now
      after(n) {
        puts render(message)
        pushover(message)
      }
    end
  rescue => e
    puts e.message
  end

  def render(name)
    "#{name} - #{Time.now.strftime('%M:%S')}"
  end

  def pushover(message)
    url = URI.parse("https://api.pushover.net/1/messages.json")
    req = Net::HTTP::Post.new(url.path)
    data = {
        token: "au9x1jpb6of8rp81cvxvt5qj4tph6v",
        user: "upxpu88ksz1xxwad35unfj7uokczj4",
        device: 'iphone',
        message: 'test'
    }

    req.set_form_data(data.merge(message))
    res = Net::HTTP.new(url.host, url.port)
    res.use_ssl = true
    res.verify_mode = OpenSSL::SSL::VERIFY_PEER
    res.start { |http|
      http.request(req)
    }
  end
end

class PushMe
  def initialize
    messages = CSV.read('push_me.csv')
    puts "Now: #{Time.now.strftime('%M:%S')}"
    t = TimerExample.new
    messages.each do |n|
      message = Hash[[:at, :message, :url, :device].zip(n)].delete_if{|k,v| v.nil?}
      t.aftr(message) if n.size > 0
    end
  end
end


PushMe.new

sleep
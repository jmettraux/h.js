
#
# spec'ing h.js
#
# Wed Nov 18 13:09:40 JST 2015
#

require 'pp'
require 'ferrum'
require 'webrick'

WPORT = 9090

server = WEBrick::HTTPServer.new(
  Port: WPORT, DocumentRoot: Dir.pwd,
  Logger: WEBrick::Log.new('/dev/null'), AccessLog: [])
    #
Thread.new { server.start }
    #
10.times do
  u = URI.parse("http://127.0.0.1:#{WPORT}/spec/test.html")
  r = Net::HTTP.start(u.host, u.port) { |http| http.get(u.path) }
  break if r.code == '200'
end


module Helpers

  def evaluate(s)

    $browser ||=
      begin

        opts = {}

        opts[:headless] = (ENV['HEADLESS'] != 'false')
        if opts[:headless]
          opts[:xvfb] = true
          opts[:headless] = false
        end
        opts[:timeout] = 15
        #opts[:process_timeout] = 15

        b = Ferrum::Browser.new(opts)

        sleep 1

        b.goto("http://127.0.0.1:#{WPORT}/spec/test.html")
        b.execute('window._src = document.body.innerHTML;')

        b
      end

    r = $browser.evaluate("JSON.stringify((function() {#{s};})())");

    begin
      r = JSON.parse(r)
    rescue
      fail RuntimeError.new(r)
    end if r.is_a?(String)

    r = r.strip if r.is_a?(String)

    r
  end

  def reset_dom

    $browser.execute('document.body.innerHTML = window._src;') \
      if $browser
  end

  def class_list(a)
    a.each_with_index.inject({}) { |h, (c, i)| h[i.to_s] = c; h }
  end
end

RSpec.configure do |c|

  c.alias_example_to(:they)
  c.alias_example_to(:so)
  c.include(Helpers)
end


class ::String

  def htrip
    self
      .gsub(/^( +)/, '')
      .gsub(/>\s+(.)/) { |m| ">#{$1}" }
      .gsub(/\s+</, '<')
      .strip
  end

  def huntrip
    '  ' + htrip.gsub(/>/, ">\n  ")
  end
end


RSpec::Matchers.define :eqh do |expected|

  match do |actual|

    expected.htrip == actual.htrip
  end

  failure_message do |actual|

    "expected:\n#{expected.huntrip}\n" +
    "actual:\n#{actual.huntrip}"
  end
end


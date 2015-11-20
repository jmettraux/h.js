
#
# spec'ing h.js
#
# Wed Nov 18 13:09:40 JST 2015
#

require 'selenium-webdriver'


def run(s)

  $driver ||=
    begin
      d = Selenium::WebDriver.for :phantomjs
      #d = Selenium::WebDriver.for :chrome
      d.navigate.to('file://' + File.absolute_path('spec/test.html'))
      d.execute_script('window._src = document.body.innerHTML;');
      d
    end

  r = $driver.execute_script(s)

  r = r.strip if r.is_a?(String)
  r = r.gsub(/\n( *)/, "\n") if r.is_a?(String)

  r
end

def reset_dom

  $driver.execute_script('document.body.innerHTML = window._src;') \
    if $driver
end

#def reload
#  $driver.navigate.to('file://' + File.absolute_path('spec/test.html')) \
#    if $driver
#end

def logs

  $driver.manage.logs.get(:browser)
    .collect { |e| "#{e.level} #{e.time} #{e.message}" }
end


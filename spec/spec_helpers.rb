
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
      d.navigate.to('file://' + File.absolute_path('spec/test.html'))
      d
    end

  r = $driver.execute_script(s)

  r = r.strip if r.is_a?(String)

  r
end


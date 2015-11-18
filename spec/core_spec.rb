
#
# spec'ing h.js
#
# Wed Nov 18 13:20:55 JST 2015
#

require 'spec_helpers.rb'


describe 'h.js / H' do

  before :all do

    @driver = Selenium::WebDriver.for :phantomjs
    #@driver = Selenium::WebDriver.for :chrome

    @driver.navigate.to('file://' + File.absolute_path('spec/test.html'))
  end

  after :all do

    @driver.quit
  end

  describe '.x()' do

    it 'works' do

      expect(@driver.execute_script(
        'return 1 + 1'
      )).to eq(2)
    end
  end
end



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

  describe '.elt' do

    it 'works .elt(selector)' do

      expect(@driver.execute_script(%{
        return H.elt('.car.bentley .blue').textContent;
      }).strip).to eq(
        'blue bentley'
      )
    end
  end

  describe '.elts' do

    it 'works  .elts(selector)' do

      expect(@driver.execute_script(%{
        return (typeof H.elt('.car .blue'));
        return (typeof H.elts('.car .blue'));
        return H.elts('.car .blue').map(function(e) { e.textContent.trim(); });
      })).to eq([
        'blue bentley'
      ])
    end
  end
end


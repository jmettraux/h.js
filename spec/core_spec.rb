
#
# spec'ing h.js
#
# Wed Nov 18 13:20:55 JST 2015
#

require 'spec_helpers.rb'


describe 'h.js / H' do

  describe '.elt' do

    it 'works  .elt(selector)' do

      expect(run(%{
        return H.elt('.car.bentley .blue').textContent;
      })).to eq(
        'blue bentley'
      )
    end

    it 'works  .elt(start, selector)'
  end

  describe '.elts' do

    it 'works  .elts(selector)' do

      expect(run(%{
        return H.elts('.car .blue')
          .map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'blue bentley', 'blue volkswagen'
      ])
    end

    it 'works  .elts(start, selector)'
  end
end


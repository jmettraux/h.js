
#
# spec'ing h.js
#
# Wed Nov 18 13:20:55 JST 2015
#

require 'spec_helpers.rb'


describe 'h.js / H' do

  describe '.elt' do

    it 'works .elt(selector)' do

      expect(run(%{
        return H.elt('.car.bentley .blue').textContent;
      })).to eq(
        'blue bentley'
      )
    end
  end

  describe '.elts' do

    it 'works  .elts(selector)' do

      expect(run(%{
        return (typeof H.elt('.car .blue'));
        return (typeof H.elts('.car .blue'));
        return H.elts('.car .blue').map(function(e) { e.textContent.trim(); });
      })).to eq([
        'blue bentley'
      ])
    end
  end
end


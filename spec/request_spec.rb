
#
# spec'ing h.js
#
# Fri Nov 20 06:22:22 JST 2015
#

require 'spec_helpers.rb'


describe 'H and xhr requests' do

  describe '.request' do

    it 'gets' do

      expect(run(%{
        var r = null;
        var onok = function(res) { r = res; };
        H.request('GET', 'http://www.example.org', onok);
        return r;
      })).to eq(
        :x
      )
    end
  end

  describe '.upload' do
    it 'works'
  end
end


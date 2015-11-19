
#
# spec'ing h.js
#
# Fri Nov 20 06:22:22 JST 2015
#

require 'spec_helpers.rb'


describe 'H and xhr requests' do

  describe '.request' do

    it 'gets' do

      req =
        run(%{
          var onok = function(res) {};
          H.request('GET', 'http://www.example.org', onok);
          return window._req;
        })

      expect(req['uri']).to eq('http://www.example.org')
      expect(req['method']).to eq('GET')
      expect(req['sent']).to eq(true)
    end
  end

  describe '.upload' do

    it 'works'
  end
end


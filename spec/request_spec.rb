
#
# spec'ing h.js
#
# Fri Nov 20 06:22:22 JST 2015
#

require 'spec_helpers.rb'


describe 'H and xhr requests' do

  describe '.request' do

    it 'gets 200' do

      req, (ok, lo, er) =
        run(%{
          var r = [ null, null, null ];

          var onok = function(res) { r[0] = res; };
          //var onload = function(res) { r[1] = res; };
          //var onerror = function(err) { r[2] = err; };

          H.request('GET', 'http://www.example.org/data.json', onok);
          //
          window._req.respond(200, '{"a":1,"b":2}');

          return [ window._req, r ];
        })

      expect(req['uri']).to eq('http://www.example.org/data.json')
      expect(req['method']).to eq('GET')
      expect(req['data']).to eq(nil)
      expect(req['sent']).to eq(true)

      expect(ok['status']).to eq(200)
      expect(ok['data']).to eq({ 'a' => 1, 'b' => 2 })
      #
      expect(lo).to eq(nil)
      #
      expect(er).to eq(nil)
    end

    it 'gets 400' do

      req, (ok, lo, er) =
        run(%{
          var r = [ null, null, null ];

          var onok = function(res) { r[0] = res; };
          var onload = function(res) { r[1] = res; };
          var onerror = function(err) { r[2] = err; };

          H.request(
            'GET', 'http://www.example.org/data.json',
            { onok: onok, onload: onload, onerror: onerror });
          //
          window._req.respond(401, '"get off"');

          return [ window._req, r ];
        })

      expect(req['uri']).to eq('http://www.example.org/data.json')
      expect(req['method']).to eq('GET')
      expect(req['headers']).to eq({})
      expect(req['data']).to eq(nil)
      expect(req['sent']).to eq(true)

      expect(ok).to eq(nil)
      #
      expect(lo).not_to eq(nil)
      expect(lo['status']).to eq(401)
      expect(lo['data']).to eq('get off')
      #
      expect(er).to eq(nil)
    end

    it 'posts 200' do

      req =
        run(%{
          var onok = function(res) {};
          H.request('POST', 'http://www.example.org', { a: 1 }, onok);
          return window._req;
        })

      expect(req['uri']).to eq('http://www.example.org')
      expect(req['method']).to eq('POST')
      expect(req['data']).to eq('{"a":1}')
      expect(req['sent']).to eq(true)
    end
  end

  describe '.upload' do

    it 'works'
  end
end


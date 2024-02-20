
#
# spec'ing h.js
#
# Tue Feb 20 10:35:13 JST 2024
#

require 'spec_helpers.rb'


describe 'H and iterating over array or hash/dict/object' do

  describe '.each' do

    it 'iterates over arrays' do

      expect(evaluate(%{
        var s = 10;
        H.each([ 1, 2, 3, 4 ], function(e) { s = s + e; });
        return s;
      })).to eq(
        20
      )
    end

    it 'iterates over hashes' do

      expect(evaluate(%{
        var s = 11;
        var ks = [];
        H.each(
          { a: 1, b: 2, c: 3 },
          function(k, v) { ks.push(k); s = s + v; });
        return [ ks, s ];
      })).to eq(
        [ %w[ a b c ], 17 ]
      )
    end
  end
end


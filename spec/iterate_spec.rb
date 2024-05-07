
#
# spec'ing h.js
#
# Tue Feb 20 10:35:13 JST 2024
#

require 'spec_helpers.rb'


describe 'H and iterating over array or hash/dict/object' do

  describe '.each' do

    it 'iterates over arrays (e)' do

      expect(evaluate(%{
        var s = 10;
        H.each([ 1, 2, 3, 4 ], function(e) { s = s + e; });
        return s;
      })).to eq(
        20
      )
    end

    it 'iterates over arrays (e, i)' do

      expect(evaluate(%{
        var a = [];
        H.each([ 'a', 'bc', 'def' ], function(e, i) { a.push(i); a.push(e); });
        return a;
      })).to eq(
        [ 0, 'a', 1, 'bc', 2, 'def' ]
      )
    end

    it 'iterates over hashes (k, v)' do

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

    it 'iterates over hashes (k, v, i)' do

      expect(evaluate(%{
        var a = [];
        H.each(
          { a: 1, b: 2, c: 3 },
          function(k, v, i) { a.push([ k, v, i ]); });
        return a;
      })).to eq(
        [ [ 'a', 1, 0 ], [ 'b', 2, 1 ], [ 'c', 3, 2 ] ]
      )
    end

    it 'iterates over hashes (k, v) #2' do

      expect(evaluate(%{
        var a = [];
        H.each(
          { "ntac": "no", "fib": "gfi", "fid": "hou", "sl": "imm" },
          //{ ntac: "no", fib: "gfi", fid: "hou", sl: "imm" },
          function(k, v) { a.push([ k, v ]); });
        return a;
      })).to eq([
        [ 'ntac', 'no' ], [ 'fib', 'gfi' ], [ 'fid', 'hou' ], [ 'sl', 'imm' ]
      ])
    end
  end

  describe '.collect' do

    it 'collects over arrays (e, i)' do

      expect(evaluate(%{
        return H.collect(
          [ 1, 2, 'three', 4 ],
          function(e, i) { return [ i, e ]; });
      })).to eq(
        [ [ 0, 1 ], [ 1, 2 ], [ 2, 'three' ], [ 3, 4 ] ]
      )
    end

    it 'collects over hashes (k, v, i)' do

      expect(evaluate(%{
        return H.collect(
          { abc: 123, def: 456, ghi: 789 },
          function(k, v, i) { return [ i, k, v ]; });
      })).to eq(
        [ [ 0, 'abc', 123 ], [ 1, 'def', 456 ], [ 2, 'ghi', 789 ] ]
      )
    end
  end

  describe '.select' do

    it 'selects over arrays (e, i)' do

      expect(evaluate(%{
        return H.select(
          [ 1, 2, 'three', 4, 'five' ],
          function(e, i) { return (i === 2) || (typeof e === 'number'); });
      })).to eq(
        [ 1, 2, 'three', 4 ]
      )
    end

    it 'selects over hashes (k, v, i)' do

      expect(evaluate(%{
        return H.select(
          { abc: 123, def: 456, ghi: 789, jkl: 'nada' },
          function(k, v, i) { return (typeof v === 'string') || (i === 2); });
      })).to eq(
        { 'ghi' => 789, 'jkl' => 'nada' }
      )
    end
  end

  describe '.reject' do

    it 'rejects over arrays (e, i)' do

      expect(evaluate(%{
        return H.reject(
          [ 1, 2, 'three', 4, 'five' ],
          function(e, i) { return (i === 2) || (typeof e === 'number'); });
      })).to eq(
        [ 'five' ]
      )
    end

    it 'rejects over hashes (k, v, i)' do

      expect(evaluate(%{
        return H.reject(
          { abc: 123, def: 456, ghi: 789, jkl: 'nada' },
          function(k, v, i) { return (typeof v === 'string') || (i === 2); });
      })).to eq(
        { 'abc' => 123, 'def' => 456 }
      )
    end
  end

  describe '.inject' do

    it 'injects over arrays (acc, e, i)' do

      expect(evaluate(%{
        return H.inject(
          [ 1, 2, 'three', 4, 'five', 6 ],
          function(acc, e, i) { acc.push([ i, e ]); return acc; },
          [ 'zero' ]);
      })).to eq(
        [ 'zero', [ 0, 1 ], [ 1, 2 ], [ 2, 'three' ], [ 3, 4 ],
          [ 4, 'five' ], [ 5, 6 ] ]
      )
    end

    it 'injects over hashes (acc, k, v, i)' do

      expect(evaluate(%{
        return H.inject(
          { abc: 123, def: 'bar', ghi: 789, jkl: 'foo' },
          function(acc, k, v, i) {
            acc.push([ i, k, v ]);
            return acc; },
          [ 'toto' ]);
      })).to eq(
        [ 'toto', [ 0, 'abc', 123 ], [ 1, 'def', 'bar' ], [ 2, 'ghi', 789 ],
          [ 3, 'jkl', 'foo' ] ]
      )
    end
  end
end


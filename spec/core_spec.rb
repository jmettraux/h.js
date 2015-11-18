
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

    it 'works  .elt(start, selector)' do

      expect(run(%{
        var t = H.elt('.train');
        return H.elt(t, '.japan').textContent;
      })).to eq(
        'shinkansen'
      )
    end
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

    it 'works  .elts(start, selector)' do

      expect(run(%{
        var t = H.elt('.train');
        return H.elts(t, '.europe > div')
          .map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end
  end

  describe '.closest' do
    it 'works'
  end

  describe '.forEach' do
    it 'works'
  end
  describe '.dim' do
    it 'works'
  end
  describe '.on' do
    it 'works'
  end
  describe '.create' do
    it 'works'
  end
  describe '.toNode' do
    it 'works'
  end
  describe '.request' do
    it 'works'
  end
  describe '.upload' do
    it 'works'
  end
  describe '.matches' do
    it 'works'
  end
  describe '.style' do
    it 'works'
  end

  describe '.hasClass' do
    it 'works'
  end
  describe '.addClass' do
    it 'works'
  end
  describe '.removeClass' do
    it 'works'
  end
  describe '.toggleClass' do
    it 'works'
  end

  describe '.show' do
    it 'works'
  end
  describe '.hide' do
    it 'works'
  end

  describe '.enable' do
    it 'works'
  end
  describe '.disable' do
    it 'works'
  end

  describe '.cenable' do
    it 'works'
  end
  describe '.cdisable' do
    it 'works'
  end

  describe '.toCamelCase' do
    it 'works'
  end

  describe '.prepend' do
    it 'works'
  end
  describe '.clean' do
    it 'works'
  end

  describe '.trigger' do
    it 'works'
  end

  describe '.onDocumentReady' do
    it 'works'
  end
end


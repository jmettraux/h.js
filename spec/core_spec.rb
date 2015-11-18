
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

  describe '.matches' do

    it 'returns true when it matches' do

      expect(run(%{
        var e = H.elt('#list-of-trains');
        return H.matches(e, '.train');
      })).to eq(
        true
      )
    end

    it 'returns false else' do

      expect(run(%{
        var e = H.elt('#list-of-trains');
        return H.matches(e, '.car');
      })).to eq(
        false
      )
    end
  end

  describe '.closest' do

    it 'works  .closest(start, selector)' do

      expect(run(%{
        var t = H.elt('.japan');
        return H.closest(t, '#cars').id;
      })).to eq(
        'cars'
      )
    end

    it 'works  .closest(start, selector, selector)' do

      expect(run(%{
        var t = H.elt('#list-of-trains');
        return H.closest(t, '.asia', '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end
  end

  describe '.forEach' do

    it 'works  .forEach(sel, fun)' do

      expect(run(%{
        var r = [];
        H.forEach('.train .europe > div', function(e) {
          r.push(e.textContent.trim());
        });
        return r;
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end

    it 'works  .forEach(start, sel, fun)' do

      expect(run(%{
        var s = H.elt('#list-of-trains');
        var r = [];
        H.forEach(s, '.europe > div', function(e) {
          r.push(e.textContent.trim());
        });
        return r;
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end
  end

  describe '.hasClass' do

    it 'works  .hasClass(sel, "clas")' do

      expect(run(%{
        return [
          H.hasClass('.bentley', 'train'),
          H.hasClass('.bentley', 'car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(sel, ".clas")' do

      expect(run(%{
        return [
          H.hasClass('.bentley', '.train'),
          H.hasClass('.bentley', '.car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(start, sel, "clas")' do

      expect(run(%{
        var s = H.elt('#cars');
        return [
          H.hasClass(s, '.bentley', 'train'),
          H.hasClass(s, '.bentley', 'car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(start, sel, ".clas")' do

      expect(run(%{
        var s = H.elt('#cars');
        return [
          H.hasClass(s, '.bentley', '.train'),
          H.hasClass(s, '.bentley', '.car')
        ];
      })).to eq([
        false, true
      ])
    end
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
  describe '.style' do
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

    it 'works (well...)' do

      expect(run(%{
        var s = 'not ready';
        H.onDocumentReady(function() { s = document.readyState; });
        return s;
      })).to eq(
        'complete'
      )
    end
  end
end


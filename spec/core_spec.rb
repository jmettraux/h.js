
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

    it 'works  .elt(sel, sel)' do

      expect(run(%{
        return H.elt('.train', '.japan').textContent;
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

    it 'works  .elts(sel, sel)' do

      expect(run(%{
        return H.elts('.train', '.europe > div')
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

  describe '.toggleClass' do

    before :each do

      run(%{ H.removeClass('#test', '.klass'); })
    end

    it 'works  .toggleClass(sel, "cla")' do

      expect(run(%{
        var r = [];
        r.push(H.hasClass('#test', '.klass'));
        H.toggleClass('#test', 'klass');
        r.push(H.hasClass('#test', '.klass'));
        H.toggleClass('#test', 'klass');
        r.push(H.hasClass('#test', '.klass'));
        return r;
      })).to eq([
        false, true, false
      ])
    end

    it 'works  .toggleClass(sel, ".cla")' do

      expect(run(%{
        var r = [];
        r.push(H.hasClass('#test', '.klass'));
        H.toggleClass('#test', '.klass');
        r.push(H.hasClass('#test', '.klass'));
        H.toggleClass('#test', '.klass');
        r.push(H.hasClass('#test', '.klass'));
        return r;
      })).to eq([
        false, true, false
      ])
    end

    it 'works  .toggleClass(start, sel, "cla")' do

      expect(run(%{
        var e = H.elt('.train');
        var r = [];
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        H.toggleClass(e, '.japan', 'klass');
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        H.toggleClass(e, '.japan', 'klass');
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        return r;
      })).to eq([
        false, false, true, false, false, false
      ])
    end

    it 'works  .toggleClass(start, sel, ".cla")' do

      expect(run(%{
        var e = H.elt('.train');
        var r = [];
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        H.toggleClass(e, '.japan', '.klass');
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        H.toggleClass(e, '.japan', '.klass');
        r.push(H.hasClass(e, '.japan', '.klass'));
        r.push(H.hasClass('.car .japan', '.klass'));
        return r;
      })).to eq([
        false, false, true, false, false, false
      ])
    end
  end

  describe '.addClass' do
    it 'works'
  end
  describe '.removeClass' do
    it 'works'
  end

  describe '.create' do
    it 'works'
  end

  describe '.toNode' do
    it 'works'
  end

  describe '.on' do

    before(:each) { reset }
    after(:all) { reset }

    it 'works  .on(sta, sel, ev, fun)' do

      expect(run(%{
        H.on('#cars', '.europe .car', 'click', function(ev) {
          ev.target.remove();
        });
        H.elt('.car.bentley').click();
        return H.elt('#cars .europe').innerHTML;
      })).to eq(%{
<div class="car volkswagen">
<div class="blue">
blue volkswagen
</div>
<div class="yellow">
yellow volkswagen
</div>
</div>
      }.strip)
    end

    it 'works  .on(sel, ev, fun)' do

      expect(run(%{
        H.on('#cars .europe .car', 'click', function(ev) {
          ev.target.remove();
        });
        H.elt('.car.bentley').click();
        return H.elt('#cars .europe').innerHTML;
      })).to eq(%{
<div class="car volkswagen">
<div class="blue">
blue volkswagen
</div>
<div class="yellow">
yellow volkswagen
</div>
</div>
      }.strip)
    end
  end

  describe '.request' do
    it 'works'
  end
  describe '.upload' do
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

  describe '.prepend' do
    it 'works'
  end

  describe '.clean' do

    before(:each) { reset }
    after(:all) { reset }

    it 'works  .clean(sel)' do

      expect(run(%{
        H.clean('#cars .europe');
        return H.elt('#cars').innerHTML;
      })).to eq(%{
<div class="asia">
<div class="car japan mazda">
<div class="red">
red mazda
</div>
</div>
</div>
<div class="europe"></div>
      }.strip)
    end

    it 'works  .clean(start, sel)' do

      expect(run(%{
        var e = H.elt('#cars');
        H.clean(e, '.europe');
        return H.elt('#cars').innerHTML;
      })).to eq(%{
<div class="asia">
<div class="car japan mazda">
<div class="red">
red mazda
</div>
</div>
</div>
<div class="europe"></div>
      }.strip)
    end

    it 'works  .clean(start, sel, "cla")' do

      expect(run(%{
        H.clean('#cars', '.europe', 'car');
        return H.elt('#cars .europe').outerHTML;
      })).to eq(%{
<div class="europe">


</div>
      }.strip)
    end

    it 'works  .clean(start, sel, ".cla")' do

      expect(run(%{
        H.clean('#cars', '.europe', '.car');
        return H.elt('#cars .europe').outerHTML;
      })).to eq(%{
<div class="europe">


</div>
      }.strip)
    end
  end

  describe '.dim' do

    it 'returns the dimensions of the target elt' do

      expect(run(%{
        return H.dim('#cars');
      })).to eq({
        'top' => 8, 'height' => 18, 'bottom' => 26,
        'left' => 8, 'width' => 384, 'right' => 392
      })
    end
  end

  describe '.style' do

    it 'returns the style of the target elt' do

      expect(run(%{
        var s = H.style('#list-of-trains');
        return [ s.fontSize, s.marginLeft ];
      })).to eq([
        '16px', '45px'
      ])
    end
  end

  describe '.toCamelCase' do

    it 'works' do

      expect(run(%{
        return [
          H.toCamelCase('ab-cd-ef'), H.toCamelCase('gh_ij-kl')
        ];
      })).to eq(%w[
        abCdEf ghIjKl
      ])
    end
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


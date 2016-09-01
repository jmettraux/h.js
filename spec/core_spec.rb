
#
# spec'ing h.js
#
# Wed Nov 18 13:20:55 JST 2015
#

require 'spec_helpers.rb'


describe 'H' do

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

    it 'works  .matches(e, sel, sel)' do

      expect(run(%{
        var e = H.elt('.train');
        return [
          H.matches(e, '.europe', '.europe'),
          H.matches(e, '.europe', '.asia')
        ];
      })).to eq([
        true, false
      ])
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

    it 'returns start if it matches' do

      expect(run(%{
        return H.closest('#list-of-trains', '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'returns start if it matches (2)' do

      expect(run(%{
        var t = H.elt('#list-of-trains');
        return H.closest(t, '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'returns start + selector if it matches' do

      expect(run(%{
        return H.closest(H.elt('body'), '.train', '.train').id;
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

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .addClass(sel, "cla")' do

      expect(run(%{
        H.addClass('.car.japan', 'vehicle');
        return H.elt('.car.japan').classList;
      })).to eq(%w[
        car japan mazda vehicle
      ])
    end

    it 'works  .addClass(sel, "cla", boo)' do

      expect(run(%{
        H.addClass('.car.mazda', 'vehicle', false);
        H.addClass('.car.bentley', 'vehicle', true);
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        %w[ car japan mazda ],
        %w[ car bentley vehicle ]
      ])
    end

    it 'works  .addClass(sel, "cla", fun)' do

      expect(run(%{
        H.addClass('.car.mazda', 'vehicle', function(e) { return false; });
        H.addClass('.car.bentley', 'vehicle', function(e) { return true; });
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        %w[ car japan mazda ],
        %w[ car bentley vehicle ]
      ])
    end

    it 'works  .addClass(sel, ".cla")' do

      expect(run(%{
        H.addClass('.car.japan', '.vehicle');
        return H.elt('.car.japan').classList;
      })).to eq(%w[
        car japan mazda vehicle
      ])
    end

    it 'works  .addClass(start, sel, "cla")' do

      expect(run(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.japan', 'vehicle');
        return H.elt(e, '.car.japan').classList;
      })).to eq(%w[
        car japan mazda vehicle
      ])
    end

    it 'works  .addClass(start, sel, "cla", boo)' do

      expect(run(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.mazda', 'vehicle', false);
        H.addClass(e, '.car.bentley', 'vehicle', true);
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        %w[ car japan mazda ],
        %w[ car bentley vehicle ]
      ])
    end

    it 'works  .addClass(start, sel, "cla", fun)' do

      expect(run(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.mazda', 'vehicle', function(e) { return false; });
        H.addClass(e, '.car.bentley', 'vehicle', function(e) { return true; });
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        %w[ car japan mazda ],
        %w[ car bentley vehicle ]
      ])
    end

    it 'works  .addClass(start, sel, ".cla")' do

      expect(run(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.japan', '.vehicle');
        return H.elt(e, '.car.japan').classList;
      })).to eq(%w[
        car japan mazda vehicle
      ])
    end
  end

  describe '.removeClass' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .removeClass(sel, "cla")' do

      expect(run(%{
        H.removeClass('.car.japan', 'japan');
        return H.elt('.car.mazda').classList;
      })).to eq(%w[
        car mazda
      ])
    end

    it 'works  .removeClass(sel, ".cla")' do

      expect(run(%{
        H.removeClass('.car.japan', '.japan');
        return H.elt('.car.mazda').classList;
      })).to eq(%w[
        car mazda
      ])
    end

    it 'works  .removeClass(start, sel, "cla")' do

      expect(run(%{
        var e = H.elt('#cars');
        H.removeClass(e, '.car.japan', 'japan');
        return H.elt(e, '.car.mazda').classList;
      })).to eq(%w[
        car mazda
      ])
    end

    it 'works  .removeClass(start, sel, ".cla")' do

      expect(run(%{
        var e = H.elt('#cars');
        H.removeClass(e, '.car.japan', '.japan');
        return H.elt(e, '.car.mazda').classList;
      })).to eq(%w[
        car mazda
      ])
    end
  end

  describe '.setClass' do

    it 'works  .setClass(sel, ".cla")' do

      expect(run(%{
        H.setClass('#sc > div', '.b');
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        %w[ b ], %w[ b ], %w[ a b ], %w[ a b ]
      ])
    end

    it 'works  .setClass(sel, ".cla", boo)' do

      expect(run(%{
        H.setClass('#sc > div', '.b', false);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        %w[ ], %w[ ], %w[ a ], %w[ a ]
      ])
      expect(run(%{
        H.setClass('#sc > div', '.b', true);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        %w[ b ], %w[ b ], %w[ a b ], %w[ a b ]
      ])
    end

    it 'works  .setClass(sel, ".cla", fun)' do

      expect(run(%{
        var fun = function(e) { return ! H.hasClass(e, 'a'); };
        H.setClass('#sc > div', '.b', fun);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        %w[ b ], %w[ b ], %w[ a ], %w[ a ]
      ])
    end

    it 'works  .setClass(sel, ".cla", undefined)' do

      expect(run(%{
        H.setClass('#sc > div', '.b', undefined);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        %w[ ], %w[ ], %w[ a ], %w[ a ]
      ])
    end
  end

  describe '.renameClass' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .renameClass(sel, cla0, cla1)' do

      expect(run(%{
        H.renameClass('.europe', '.europe', '.old-europe');
        H.renameClass('.japan', 'japan', 'crazy-japan');
        return [
          H.elt('.europe'),
          H.elt('.japan'),
          H.elt('.old-europe').className,
          H.elt('.crazy-japan').className,
        ];
      })).to eq(
        [ nil, nil, 'old-europe', 'car mazda crazy-japan' ]
      )
    end

    it 'works  .renameClass(sta, sel, cla0, cla1)' do

      expect(run(%{
        var c = H.elt('#cars');
        H.renameClass(c, '.europe', '.europe', '.old-europe');
        H.renameClass(c, '.japan', 'japan', 'crazy-japan');
        return [
          H.elt(c, '.europe'),
          H.elt(c, '.japan'),
          H.elt(c, '.old-europe').className,
          H.elt(c, '.crazy-japan').className,
        ];
      })).to eq(
        [ nil, nil, 'old-europe', 'car mazda crazy-japan' ]
      )
    end
  end

  describe '.classArray' do

    it 'returns the classList but as an array' do

      expect(run(%{
        var c = H.elt('.car.bentley');
        return [
          H.classArray(c),
          H.classArray('.car.bentley'),
          H.classArray(H.elt('body'), '.car.bentley')
        ];
      })).to eq([
        [ 'car', 'bentley' ],
        [ 'car', 'bentley' ],
        [ 'car', 'bentley' ]
      ])
    end
  end

  describe '.create' do

    it 'works  .create(tag, atts, text)' do

      expect(run(%{
        return H.create('span', { 'data-id': 123 }, 'hello').outerHTML;
      })).to eq(
        '<span data-id="123">hello</span>'
      )
    end

    it 'works  .create(tag#id, atts, text)' do

      expect(run(%{
        return H.create('span#xyz', { 'data-id': 123 }, 'hello').outerHTML;
      })).to eq(
        '<span id="xyz" data-id="123">hello</span>'
      )
    end

    it 'works  .create(tag#id.class, atts, text)' do

      expect(run(%{
        return H.create('span#xyz.ab.cd', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<span id="xyz" class="ab cd" data-id="123">xzy</span>'
      )
    end

    it 'works  .create(#id, atts, text)' do

      expect(run(%{
        return H.create('span#xyz', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<span id="xyz" data-id="123">xzy</span>'
      )
    end

    it 'works  .create(.class, atts, text)' do

      expect(run(%{
        return H.create('.cla', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<div class="cla" data-id="123">xzy</div>'
      )
    end
  end

  describe '.toNode' do

    it 'works' do

      expect(run(%{
        return H.toNode('<span id="x" class="y z">hello</span>').outerHTML;
      })).to eq(
        '<span id="x" class="y z">hello</span>'
      )
    end

    it 'leaves element untouched' do

      expect(run(%{
        return H.toNode(H.elt('#list-of-trains .asia')).outerHTML;
      })).to eq(%{
<div class="asia">
<div class="japan">shinkansen</div>
<div class="russia mongolia">transsiberian</div>
</div>
      }.strip)
    end

    it 'creates a node and applies sel' do

      expect(run(%{
        return H.toNode(
          '<div class="k"><span id="x" class="y z">hello</span></div>',
          'span'
        ).outerHTML;
      })).to eq(
        '<span id="x" class="y z">hello</span>'
      )
    end

    it 'leaves element untouched and applies sel' do

      expect(run(%{
        return H.toNode(H.elt('#list-of-trains .asia'), '.japan').outerHTML;
      })).to eq(
        '<div class="japan">shinkansen</div>'
      )
    end
  end

  describe '.on' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

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

  describe '.enable' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .enable(sel)' do

      expect(run(%{
        H.enable('input[name="first-name"]');
        return H.elt('input[name="first-name"]').outerHTML;
      })).to eq(%{
<input type="text" name="first-name">
      }.strip)
    end

    it 'works  .enable(sel, bool)' do

      expect(run(%{
        H.enable('input[name="name"]', false);
        H.enable('input[name="first-name"]', true);
        H.enable(H.elt('input[name="last-name"]'), false);
        return [
          H.elt('input[name="name"]').outerHTML,
          H.elt('input[name="first-name"]').outerHTML,
          H.elt('input[name="last-name"]').outerHTML
        ];
      })).to eq([
        '<input type="text" name="name" disabled="disabled">',
        '<input type="text" name="first-name">',
        '<input type="text" name="last-name" disabled="disabled">'
      ])
    end

    it 'works  .enable(elt, undefined)' do

      expect(run(%{
        H.enable(H.elt('input[name="last-name"]'), "".match(/nada/));
        return [
          H.elt('input[name="last-name"]').outerHTML
        ];
      })).to eq([
        '<input type="text" name="last-name" disabled="disabled">'
      ])
    end

    it 'works  .enable(sel, fun)' do

      expect(run(%{
        H.enable('#input input', function(e) {
          return e.getAttribute('name').match(/name/);
        });
        return H.elt('#input form').innerHTML;
      })).to eq(%{
<input type="text" name="name">
<input type="text" name="first-name">
<input type="text" name="last-name">
<input type="number" name="age" disabled="disabled">

<input class="i" type="text" name="alpha" disabled="disabled">
<input class="i disabled" type="text" name="bravo" disabled="disabled">
<input class="i disabled" type="text" name="charly" disabled="disabled">
      }.strip)
    end

    it 'works  .enable(start, sel)' do

      expect(run(%{
        var i = H.elt('#input');
        H.enable(i, 'input[name="first-name"]');
        return H.elt(i, 'input[name="first-name"]').outerHTML;
      })).to eq(%{
<input type="text" name="first-name">
      }.strip)
    end

    it 'works  .enable(start, sel, bool)' do

      expect(run(%{
        var i = H.elt('#input');
        H.enable(i, 'input[name="name"]', false);
        H.enable(i, 'input[name="first-name"]', true);
        return [
          H.elt(i, 'input[name="name"]').outerHTML,
          H.elt(i, 'input[name="first-name"]').outerHTML
        ];
      })).to eq([
        '<input type="text" name="name" disabled="disabled">',
        '<input type="text" name="first-name">'
      ])
    end
  end

  describe '.disable' do

    it 'works  .disable(sel, fun)' do

      expect(run(%{
        H.disable('#input input', function(e) {
          return ! e.getAttribute('name').match(/name/);
        });
        return H.elt('#input form').innerHTML;
      })).to eq(%{
<input type="text" name="name">
<input type="text" name="first-name">
<input type="text" name="last-name">
<input type="number" name="age" disabled="disabled">

<input class="i" type="text" name="alpha" disabled="disabled">
<input class="i disabled" type="text" name="bravo" disabled="disabled">
<input class="i disabled" type="text" name="charly" disabled="disabled">
      }.strip)
    end
  end

  describe '.show' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .show(sel)' do

      expect(run(%{
        H.show('#test0');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .show(sel, something_undefined)' do

      expect(run(%{
        var h = {};
        H.show('#test1', h.something);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .show(sel, bool)' do

      expect(run(%{
        H.show('#test0', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w{
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      })
    end

    it 'works  .show(start, sel)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.show(has, '#test0');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .show(sel, fun)' do

      expect(run(%{
        H.show('.t', function(e) {
          return parseInt(e.id.substring(4, 5), 10) % 2 == 0;
        });
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t
        #test2.t.hidden.shown
        #test3.t.hidden
      ])
    end

    it 'works  .show(start, sel, fun)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.show(has, '.t', function(e) {
          return parseInt(e.id.substring(4, 5), 10) % 2 == 1;
        });
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden.shown
      ])
    end

    it 'works  .show(sel, bool)' do

      expect(run(%{
        H.show('.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden.shown
        #test3.t.hidden.shown
      ])

      expect(run(%{
        H.show('.t', false);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .show(start, sel, bool)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.show(has, '.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden.shown
        #test3.t.hidden.shown
      ])

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.show(has, '.t', false);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t
        #test2.t.hidden
        #test3.t.hidden
      ])
    end
  end

  describe '.hide' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .hide(sel)' do

      expect(run(%{
        H.hide('#test0');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .hide(sel, bool)' do

      expect(run(%{
        H.hide('#test0', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w{
        #test0.t.hidden
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      })
    end

    it 'works  .hide(start, sel)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.hide(has, '#test0');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown
        #test2.t.hidden
        #test3.t.hidden
      ])
    end

    it 'works  .hide(sel, fun)' do

      expect(run(%{
        H.hide('.t', function(e) {
          return parseInt(e.id.substring(4, 5), 10) % 2 == 0;
        });
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown
        #test2.t.hidden
        #test3.t
      ])
    end

    it 'works  .hide(start, sel, fun)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.hide(has, '.t', function(e) {
          return parseInt(e.id.substring(4, 5), 10) % 2 == 1;
        });
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown.hidden
        #test2.t
        #test3.t.hidden
      ])
    end

    it 'works  .hide(sel, bool)' do

      expect(run(%{
        H.hide('.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown.hidden
        #test2.t.hidden
        #test3.t.hidden
      ])

      expect(run(%{
        H.hide('.t', false);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown
        #test2.t
        #test3.t
      ])
    end

    it 'works  .hide(start, sel, bool)' do

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.hide(has, '.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown.hidden
        #test2.t.hidden
        #test3.t.hidden
      ])

      expect(run(%{
        var has = H.elt('#hide_and_show');
        H.hide(has, '.t', false);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown
        #test2.t
        #test3.t
      ])
    end
  end

  describe '.cenable' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works .cenable(sel)' do

      expect(run(%{
        H.cenable('input.i');
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i" type="text" name="alpha">
<input class="i" type="text" name="bravo">
<input class="i" type="text" name="charly">
      }.strip)
    end

    it 'works .cenable(sel, bool)' do

      expect(run(%{
        H.cenable('input.i', true);
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i" type="text" name="alpha">
<input class="i" type="text" name="bravo">
<input class="i" type="text" name="charly">
      }.strip)
    end

    it 'works .cenable(sel, fun)' do

      expect(run(%{
        H.cenable('#input input', function(e) {
          return e.getAttribute('name') === 'charly';
        });
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i disabled" type="text" name="alpha">
<input class="i disabled" type="text" name="bravo">
<input class="i" type="text" name="charly">
      }.strip)
    end

    it 'works .cenable(start, sel)' do

      expect(run(%{
        var i = H.elt('#input');
        H.cenable(i, 'input.i');
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i" type="text" name="alpha">
<input class="i" type="text" name="bravo">
<input class="i" type="text" name="charly">
      }.strip)
    end

    it 'works .cenable(start, sel, bool)' do

      expect(run(%{
        var i = H.elt('#input');
        H.cenable(i, 'input.i', false);
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i disabled" type="text" name="alpha">
<input class="i disabled" type="text" name="bravo">
<input class="i disabled" type="text" name="charly">
      }.strip)
    end
  end

  describe '.cdisable' do

    it 'works .cdisable(start, sel, bool)' do

      expect(run(%{
        var i = H.elt('#input');
        H.cdisable(i, 'input.i', true);
        return H.elts('input.i')
          .map(function(e) { return e.outerHTML.trim(); })
          .join('\\n');
      })).to eq(%{
<input class="i disabled" type="text" name="alpha">
<input class="i disabled" type="text" name="bravo">
<input class="i disabled" type="text" name="charly">
      }.strip)
    end
  end

  describe '.prepend' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .prepend(sel, elt)' do

      expect(run(%{
        var e = H.create('div.america', {}, '');
        H.prepend('#cars .europe', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="europe">/
      )
    end

    it 'works  .prepend(start, sel, elt)' do

      expect(run(%{
        var cars = H.elt('#cars');
        var e = H.create('div.america', {}, '');
        H.prepend(cars, '.europe', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="europe">/
      )
    end
  end

  describe '.clean' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

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
      }).gsub(/\n+/, '')).to eq(%{
<div class="europe"></div>
      }.strip)
    end

    it 'works  .clean(start, sel, ".cla")' do

      expect(run(%{
        H.clean('#cars', '.europe', '.car');
        return H.elt('#cars .europe').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div class="europe"></div>
      }.strip)
    end
  end

  describe '.remove' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .remove(sta)' do

      expect(run(%{
        H.remove('#cars > div');
        return H.elt('#cars').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div id="cars"></div>
      }.strip)
    end

    it 'works  .remove(sta, sel)' do

      expect(run(%{
        H.remove('#hide_and_show', '.t');
        return H.elt('#hide_and_show').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div id="hide_and_show"></div>
      }.strip)
    end

    it 'works  .remove(sta, boo)' do

      expect(run(%{
        H.remove('#sc > div', false);
        return H.elt('#sc').outerHTML;
      })).to eq(%{
<div id="sc">
<div id="sc-test-0"></div>
<div id="sc-test-1"></div>
<div id="sc-test-2" class="a"></div>
<div id="sc-test-3" class="a"></div>
</div>
      }.strip)

      expect(run(%{
        H.remove('#sc > div', true);
        return H.elt('#sc').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div id="sc"></div>
      }.strip)
    end

    it 'works  .remove(sta, bof)' do

      expect(run(%{
        H.remove('#sc > div', function(e) { return H.hasClass(e, 'a'); });
        return H.elt('#sc').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div id="sc"><div id="sc-test-0"></div><div id="sc-test-1"></div></div>
      }.strip)
    end

    it 'works  .remove(sta, sel, bof)' do

      expect(run(%{
        H.remove('#sc', 'div', function(e) { return H.hasClass(e, 'a'); });
        return H.elt('#sc').outerHTML;
      }).gsub(/\n+/, '')).to eq(%{
<div id="sc"><div id="sc-test-0"></div><div id="sc-test-1"></div></div>
      }.strip)
    end

    it 'works  .remove("#gone")' do

      expect(run(%{
        H.remove('#gone');
        return 1;
      })).to eq(1)
    end
  end

  describe '.dim' do

    it 'returns the dimensions of the target elt' do

      expect(run(%{
        return H.dim('#cars');
      }).collect { |k, v| "#{k}:#{v}" }.sort).to eq(%w{
        bottom:98 height:90 left:8 right:392 top:8 width:384
      })
    end
  end

  describe '.tdim' do

    it 'returns the dimensions of the target elt' do

      expect(run(%{
        return H.tdim('#cars');
      }).collect { |k, v| "#{k}:#{v}" }.sort).to eq(%w{
        bottom:98 height:90 left:8 right:392 top:8 width:384
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

  describe '.capitalize' do

    it 'works' do

      expect(run(%{
        return H.capitalize('jeff');
      })).to eq(
        'Jeff'
      )
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

    it 'capitalizes if requested' do

      expect(run(%{
        return [
          H.toCamelCase('ab-cd-ef', true), H.toCamelCase('gh_ij-kl', true)
        ];
      })).to eq(%w[
        AbCdEf GhIjKl
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


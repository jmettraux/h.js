
#
# spec'ing h.js
#
# Wed Nov 18 13:20:55 JST 2015
#

require 'spec_helpers.rb'


describe 'H' do

  describe '.elt' do

    it 'works  .elt(selector)' do

      expect(evaluate(%{
        return H.elt('.car.bentley .blue').textContent;
      })).to eq(
        'blue bentley'
      )
    end

    it 'works  .elt(start, selector)' do

      expect(evaluate(%{
        var t = H.elt('.train');
        return H.elt(t, '.japan').textContent;
      })).to eq(
        'shinkansen'
      )
    end

    it 'works  .elt(sel, sel)' do

      expect(evaluate(%{
        return H.elt('.train', '.japan').textContent;
      })).to eq(
        'shinkansen'
      )
    end

    it 'works  .elt(start, "^x")  (closest)' do

      expect(evaluate(%{
        var t = H.elt('.japan');
        return H.elt(t, '^#cars').id;
      })).to eq(
        'cars'
      )

      expect(evaluate(%{
        return H.elt('.japan', '^#cars').id;
      })).to eq(
        'cars'
      )
    end

    it 'works  .elt(start, "^x y")  (closest then)' do

      expect(evaluate(%{
        var e = H.elt('.germany');
        return H.elt(e, '^.train .japan').textContent;
      })).to eq(
        'shinkansen'
      )

      expect(evaluate(%{
        return H.elt('.germany', '^.train .japan').textContent;
      })).to eq(
        'shinkansen'
      )
    end

    it 'works  .elt("[-xyz]")' do

      expect(evaluate(%{
        return H.elt('[-hjs-alpha]').className;
      })).to eq(
        'gaa'
      )
    end

    it 'works  .elt(start, "[-xyz]")' do

      expect(evaluate(%{
        var s = H.elt('#for-getAtt');
        return H.elt(s, '[-hjs-bravo]').className;
      })).to eq(
        'gab'
      )
    end

    it 'works  .elt(start, >.option[-hjs-value="[-999,28]"]<)' do

      expect(evaluate(%{
        return H.elt('.option[-hjs-value="[-999,28]"]').className;
      })).to eq(
        'option dash-data'
      )
    end

    it 'works  .elt(e, "^[-xyz]")  (closest)' do

      expect(evaluate(%{
        var e = H.elt('#in-charly');
        return H.elt(e, '^[-hjs-data-prefix]').className;
      })).to eq(
        'cinnamon'
      )
    end

    it 'works  .elt(null, sel)' do

      expect(evaluate(%{
        return H.elt(null, '.car.bentley .blue').textContent;
      })).to eq(
        'blue bentley'
      )
    end

    it 'works  .elt(null, elt)' do

      expect(evaluate(%{
        return H.elt(null, H.elt('.car.bentley .blue')).textContent.trim();
      })).to eq(
        'blue bentley'
      )
    end

    it 'works  .elt(null, null)' do

      expect(evaluate(%{
        return H.elt(null, null);
      })).to eq(
        nil
      )
    end

    it 'works  .elt(arguments)' do

      expect(evaluate(%{
        var e = H.elt('.car.volkswagen');
        var f = function() { return H.elt(arguments); };
        return [
          f('.car.bentley .blue').textContent.trim(),
          f('.car', '.blue').textContent.trim(),
          f(e, '.yellow').textContent.trim()
        ];
      })).to eq([
        'blue bentley',
        'blue bentley',
        'yellow volkswagen'
      ])
    end

    it 'works  .elt(ev)' do

      expect(evaluate(%{
        return [
          H.elt({ target: H.elt('.car .blue') }).textContent.trim(),
          H.text({ target: H.elt('.car .blue') }),
        ];
      })).to eq([
        'blue bentley',
        'blue bentley',
      ])
    end

    it 'works  .elt(ev, sel)' do

      expect(evaluate(%{
        return [
          H.elt({ target: H.elt('.car') }, '.red').textContent.trim(),
          H.text({ target: H.elt('.car') }, '.red'),
        ];
      })).to eq([
        'red mazda',
        'red mazda',
      ])
    end
  end

  describe '.elts' do

    it 'works  .elts(selector)' do

      expect(evaluate(%{
        return H.elts('.car .blue')
          .map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'blue bentley', 'blue volkswagen'
      ])
    end

    it 'works  .elts(start, selector)' do

      expect(evaluate(%{
        var t = H.elt('.train');
        return H.elts(t, '.europe > div')
          .map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end

    it 'works  .elts(sel, sel)' do

      expect(evaluate(%{
        return H.elts('.train', '.europe > div')
          .map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end

    it 'works  .elts(start, "^x")  (closest)' do

      expect(evaluate(%{
        var t = H.elt('.japan');
        return H.elts(t, '^.asia').map(function(e) { return e.className; });
      })).to eq([
        'asia'
      ])

      expect(evaluate(%{
        return H.elt('.bentley', '^[id]').id;
      })).to eq(
        'cars'
      )
    end

    it 'works  .elts(start, "^x y")  (closest then)' do

      expect(evaluate(%{
        var e = H.elt('.japan.mazda');
        return H.elts(e, '^[id] .car')
          .map(function(e) { return e.className; });
      })).to eq([
        'car japan mazda', 'car bentley', 'car volkswagen'
      ])

      expect(evaluate(%{
        return H.elts('.bentley', '^[id] .car')
          .map(function(e) { return e.className; });
      })).to eq([
        'car japan mazda', 'car bentley', 'car volkswagen'
      ])
    end

    it 'works  .elts("[-xyz]")' do

      expect(evaluate(%{
        return H.elts('[-hjs-data-prefix]')
          .map(function(e) { return e.getAttribute('data-hjs-data-prefix'); });
      })).to eq(%w[
        alice bob charly
      ])
    end

    it 'works  .elts(start, "[-xyz]")' do

      expect(evaluate(%{
        var e = H.elt('#for-data-prefix');
        return H.elts(e, '[-hjs-data-prefix]')
          .map(function(e) { return e.getAttribute('data-hjs-data-prefix'); });
      })).to eq(%w[
        alice bob charly
      ])
    end

    it 'works  .elts(elements, selectors)' do

      expect(evaluate(%{
        var es = H.elts([ '#cars > div ', '#list-of-trains > div' ]);
        return es.map(function(e) { return H.path(e); });
      })).to eq([
        '#cars > div.asia',
        '#cars > div.europe',
        '#list-of-trains > div.asia',
        '#list-of-trains > div.europe',
      ])
    end

    it 'works  .elts(arguments)' do

      expect(evaluate(%{
        var f = function() { return H.elts(arguments); };
        return f('#cars > div').map(function(e) { return H.path(e); });
      })).to eq([
        '#cars > div.asia',
        '#cars > div.europe',
      ])
    end
  end

  describe '.count' do

    it 'returns 0 if there are no such elements' do

      expect(evaluate(%{ return H.count('.nada'); })).to eq(0)
    end

    it 'returns the count of matching elements' do

      expect(evaluate(%{
        var e = H.elt('#for-data-prefix');
        return H.count(e, '[-hjs-data-prefix]');
      })).to eq(3)
    end
  end

  describe '.matches' do

    it 'returns true when it matches' do

      expect(evaluate(%{
        var e = H.elt('#list-of-trains');
        return H.matches(e, '.train');
      })).to eq(
        true
      )
    end

    it 'returns false else' do

      expect(evaluate(%{
        var e = H.elt('#list-of-trains');
        return H.matches(e, '.car');
      })).to eq(
        false
      )
    end

    it 'works  .matches(e, sel, sel)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
        var t = H.elt('.japan');
        return H.closest(t, '#cars').id;
      })).to eq(
        'cars'
      )
    end

    it 'works  .closest(start, selector, selector)' do

      expect(evaluate(%{
        var t = H.elt('#list-of-trains');
        return H.closest(t, '.asia', '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'returns start if it matches' do

      expect(evaluate(%{
        return H.closest('#list-of-trains', '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'returns start if it matches (2)' do

      expect(evaluate(%{
        var t = H.elt('#list-of-trains');
        return H.closest(t, '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'returns start + selector if it matches' do

      expect(evaluate(%{
        return H.closest(H.elt('body'), '.train', '.train').id;
      })).to eq(
        'list-of-trains'
      )
    end

    it 'works with an implicit "data" prefix' do

      expect(evaluate(%{
        return H.closest(H.elt('#in-charly'), '[-hjs-data-prefix]').className;
      })).to eq(
        'cinnamon'
      )
    end
  end

  describe '.forEach' do

    it 'works  .forEach(sel, fun)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
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

  describe '.map' do

    it 'works  .map(sel, fun)' do

      expect(evaluate(%{
        return H.map('.train .europe > div', function(e) {
          return e.textContent.trim();
        });
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end

    it 'works  .map(start, sel, fun)' do

      expect(evaluate(%{
        var s = H.elt('#list-of-trains');
        return H.map(s, '.europe > div', function(e) {
          return e.textContent.trim();
        });
      })).to eq([
        'ice', 'tgv', 'pendolino'
      ])
    end
  end

  describe '.find' do

    it 'works  .find(sel, fun)' do

      expect(evaluate(%{
        return H.find('.train .europe > div', function(e) {
          return e.textContent.trim() === 'tgv';
        }).textContent.trim();
      })).to eq(
        'tgv'
      )
    end

    it 'works  .find(start, sel, fun)' do

      expect(evaluate(%{
        var s = H.elt('#list-of-trains');
        return H.find(s, '.europe > div', function(e) {
          return e.textContent.match(/pendolino/);
        }).textContent.trim();
      })).to eq(
        'pendolino'
      )
    end
  end

  describe '.filter' do

    it 'works  .filter(sel, fun)' do

      expect(evaluate(%{
        return H.filter('.train .europe > div', function(e) {
          return e.textContent.match(/i/);
        }).map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'ice', 'pendolino'
      ])
    end

    it 'works  .filter(start, sel, fun)' do

      expect(evaluate(%{
        var s = H.elt('#list-of-trains');
        return H.filter(s, '.europe > div', function(e) {
          return e.textContent.match(/i/);
        }).map(function(e) { return e.textContent.trim(); });
      })).to eq([
        'ice', 'pendolino'
      ])
    end
  end

  describe '.reduce' do

    it 'works  .reduce(sel, fun, [])' do

      expect(evaluate(%{
        return H.reduce(
          '.train .europe > div',
          function(a, e) {
            if (e.textContent.match(/i/)) a.push(e.textContent.trim());
            return a; },
          []);
      })).to eq([
        'ice', 'pendolino'
      ])
    end

    it 'works  .reduce(start, sel, fun, [])' do

      expect(evaluate(%{
        var s = H.elt('#list-of-trains');
        return H.reduce(
          s, '.europe > div',
          function(a, e) {
            if (e.textContent.match(/i/)) a.push(e.textContent.trim());
            return a; },
          []);
      })).to eq([
        'ice', 'pendolino'
      ])
    end
  end

  describe '.hasClass' do

    it 'works  .hasClass(sel, "clas")' do

      expect(evaluate(%{
        return [
          H.hasClass('.bentley', 'train'),
          H.hasClass('.bentley', 'car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(sel, ".clas")' do

      expect(evaluate(%{
        return [
          H.hasClass('.bentley', '.train'),
          H.hasClass('.bentley', '.car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(start, sel, "clas")' do

      expect(evaluate(%{
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

      expect(evaluate(%{
        var s = H.elt('#cars');
        return [
          H.hasClass(s, '.bentley', '.train'),
          H.hasClass(s, '.bentley', '.car')
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .hasClass(ev, ".clas")' do

      expect(evaluate(%{
        var ev = { target: H.elt('#cars .bentley') };
        return [
          H.hasClass(ev, '.train'),
          H.hasClass(ev, '.car')
        ];
      })).to eq([
        false, true
      ])
    end
  end

  describe '.toggleClass' do

    before :each do

      $browser.execute(%{ H.removeClass('#test', '.klass'); })
    end

    it 'works  .toggleClass(sel, "cla")' do

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.addClass('.car.japan', 'vehicle');
        return H.elt('.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vehicle ])
      )
    end

    it 'works  .addClass(sel, "cla", boo)' do

      expect(evaluate(%{
        H.addClass('.car.mazda', 'vehicle', false);
        H.addClass('.car.bentley', 'vehicle', true);
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        class_list(%w[ car japan mazda ]),
        class_list(%w[ car bentley vehicle ])
      ])
    end

    it 'works  .addClass(sel, "cla", fun)' do

      expect(evaluate(%{
        H.addClass('.car.mazda', 'vehicle', function(e) { return false; });
        H.addClass('.car.bentley', 'vehicle', function(e) { return true; });
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        class_list(%w[ car japan mazda ]),
        class_list(%w[ car bentley vehicle ])
      ])
    end

    it 'works  .addClass(sel, ".cla")' do

      expect(evaluate(%{
        H.addClass('.car.japan', '.vehicle');
        return H.elt('.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vehicle ])
      )
    end

    it 'works  .addClass(sel, ".cla0.cla1")' do

      expect(evaluate(%{
        H.addClass('.car.japan', '.vehicle.vhc');
        return H.elt('.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vehicle vhc ])
      )
    end

    it 'works  .addClass(sel, [ ".cla0", "cla1" ])' do

      expect(evaluate(%{
        H.addClass('.car.japan', [ '.vhc1', 'vhc2' ]);
        return H.elt('.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vhc1 vhc2 ])
      )
    end

    it 'works  .addClass(start, sel, "cla")' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.japan', 'vehicle');
        return H.elt(e, '.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vehicle ])
      )
    end

    it 'works  .addClass(start, sel, "cla", boo)' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.mazda', 'vehicle', false);
        H.addClass(e, '.car.bentley', 'vehicle', true);
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        class_list(%w[ car japan mazda ]),
        class_list(%w[ car bentley vehicle ])
      ])
    end

    it 'works  .addClass(start, sel, "cla", fun)' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.mazda', 'vehicle', function(e) { return false; });
        H.addClass(e, '.car.bentley', 'vehicle', function(e) { return true; });
        return [
          H.elt('.car.mazda').classList,
          H.elt('.car.bentley').classList
        ];
      })).to eq([
        class_list(%w[ car japan mazda ]),
        class_list(%w[ car bentley vehicle ])
      ])
    end

    it 'works  .addClass(start, sel, ".cla")' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.addClass(e, '.car.japan', '.vehicle');
        return H.elt(e, '.car.japan').classList;
      })).to eq(
        class_list(%w[ car japan mazda vehicle ])
      )
    end
  end

  describe '.removeClass' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .removeClass(sel, "cla")' do

      expect(evaluate(%{
        H.removeClass('.car.japan', 'japan');
        return H.elt('.car.mazda').classList;
      })).to eq(
        class_list(%w[ car mazda ])
      )
    end

    it 'works  .removeClass(sel, ".cla0.cla1")' do

      expect(evaluate(%{
        H.removeClass('.car.japan', '.car.japan');
        return H.elt('.mazda').classList;
      })).to eq(
        class_list(%w[ mazda ])
      )
    end

    it 'works  .removeClass(sel, [ ".cla0", "cla1" ])' do

      expect(evaluate(%{
        H.removeClass('.car.japan', [ '.car', 'japan' ]);
        return H.elt('.mazda').classList;
      })).to eq(
        class_list(%w[ mazda ])
      )
    end

    it 'works  .removeClass(sel, ".cla")' do

      expect(evaluate(%{
        H.removeClass('.car.japan', '.japan');
        return H.elt('.car.mazda').classList;
      })).to eq(
        class_list(%w[ car mazda ])
      )
    end

    it 'works  .removeClass(start, sel, "cla")' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.removeClass(e, '.car.japan', 'japan');
        return H.elt(e, '.car.mazda').classList;
      })).to eq(
        class_list(%w[ car mazda ])
      )
    end

    it 'works  .removeClass(start, sel, ".cla")' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.removeClass(e, '.car.japan', '.japan');
        return H.elt(e, '.car.mazda').classList;
      })).to eq(
        class_list(%w[ car mazda ])
      )
    end
  end

  describe '.setClass' do

    it 'works  .setClass(sel, ".cla")' do

      expect(evaluate(%{
        H.setClass('#sc > div', '.b');
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        class_list(%w[ b ]), class_list(%w[ b ]), class_list(%w[ a b ]),
        class_list(%w[ a b ])
      ])
    end

    it 'works  .setClass(sel, ".cla", boo)' do

      expect(evaluate(%{
        H.setClass('#sc > div', '.b', false);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        class_list(%w[ ]), class_list(%w[ ]), class_list(%w[ a ]),
        class_list(%w[ a ])
      ])
      expect(evaluate(%{
        H.setClass('#sc > div', '.b', true);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        class_list(%w[ b ]), class_list(%w[ b ]), class_list(%w[ a b ]),
        class_list(%w[ a b ])
      ])
    end

    it 'works  .setClass(sel, ".cla", fun)' do

      expect(evaluate(%{
        var fun = function(e) { return ! H.hasClass(e, 'a'); };
        H.setClass('#sc > div', '.b', fun);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        class_list(%w[ b ]), class_list(%w[ b ]), class_list(%w[ a ]),
        class_list(%w[ a ])
      ])
    end

    it 'works  .setClass(sel, ".cla", undefined)' do

      expect(evaluate(%{
        H.setClass('#sc > div', '.b', undefined);
        var a = [];
        H.forEach('#sc > div', function(e) { a.push(e.classList); });
        return a;
      })).to eq([
        class_list(%w[ ]), class_list(%w[ ]), class_list(%w[ a ]),
        class_list(%w[ a ])
      ])
    end
  end

  describe '.renameClass' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .renameClass(sel, cla0, cla1)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

  describe '.classFrom' do

    it 'returns undefined when no match' do

      expect(evaluate(%{
        var cs = H.elt('.cars');
        var c = H.elt('.car.bentley');
        return [
          H.classFrom(c, [ 'mazda', 'ford' ]),
          H.classFrom('.car.bentley', [ 'mazda', 'ford' ]),
          H.classFrom(cs, '.bentley', [ 'mazda', 'ford' ]),
        ];
      })).to eq([
        nil, nil, nil
      ])
    end

    it 'returns the first classname included in the array' do

      expect(evaluate(%{
        var cs = H.elt('.cars');
        var c = H.elt('.car.bentley');
        return [
          H.classFrom(c, [ 'mazda', 'ford', 'bentley' ]),
          H.classFrom('.car.bentley', [ 'mazda', 'ford', 'bentley' ]),
          H.classFrom(cs, '.bentley', [ 'mazda', 'ford', 'bentley' ]),
        ];
      })).to eq([
        'bentley', 'bentley', 'bentley'
      ])
    end
  end

  describe '.create' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .create(tag, atts, text)' do

      expect(evaluate(%{
        return H.create('span', { 'data-id': 123 }, 'hello').outerHTML;
      })).to eq(
        '<span data-id="123">hello</span>'
      )
    end

    it 'works  .create(tag#id, atts, text)' do

      expect(evaluate(%{
        return H.create('span#xyz', { 'data-id': 123 }, 'hello').outerHTML;
      })).to eq(
        '<span id="xyz" data-id="123">hello</span>'
      )
    end

    it 'works  .create(tag#id.class, atts, text)' do

      expect(evaluate(%{
        return H.create('span#xyz.ab.cd', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<span id="xyz" class="ab cd" data-id="123">xzy</span>'
      )
    end

    it 'works  .create(#id, atts, text)' do

      expect(evaluate(%{
        return H.create('span#xyz', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<span id="xyz" data-id="123">xzy</span>'
      )
    end

    it 'is OK with -id instead of data-id for attributes' do

      expect(evaluate(%{
        return H.create('span#xyz', { '-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<span id="xyz" data-id="123">xzy</span>'
      )
    end

    it 'works  .create(.class, atts, text)' do

      expect(evaluate(%{
        return H.create('.cla', { 'data-id': 123 }, 'xzy').outerHTML;
      })).to eq(
        '<div class="cla" data-id="123">xzy</div>'
      )
    end

    it 'works .create(parent, "x", atts, text)' do

      expect(evaluate(%{
        var p = H.elt('#for-create');
        H.create(p, '.aaa', { 'data-bbb': 345 }, 'ccc');
        return p.outerHTML;
      })).to eqh(%{
        <div id="for-create">
        <div class="aaa" data-bbb="345">ccc</div>
        </div>
      })
    end

    it 'works .create(parent, "x", undefined)' do

      expect(evaluate(%{
        var p = H.elt('#for-create');
        H.create(p, '.zzz', undefined);
        return p.outerHTML;
      })).to eqh(%{
        <div id="for-create">
        <div class="zzz"></div>
        </div>
      })
    end
  end

  describe '.toNode' do

    it 'works' do

      expect(evaluate(%{
        return H.toNode('<span id="x" class="y z">hello</span>').outerHTML;
      })).to eq(
        '<span id="x" class="y z">hello</span>'
      )
    end

    it 'leaves element untouched' do

      expect(evaluate(%{
        return H.toNode(H.elt('#list-of-trains .asia')).outerHTML;
      })).to eqh(%{
        <div class="asia">
          <div class="japan">shinkansen</div>
          <div class="russia mongolia">transsiberian</div>
        </div>
      })
    end

    it 'creates a node and applies sel' do

      expect(evaluate(%{
        return H.toNode(
          '<div class="k"><span id="x" class="y z">hello</span></div>',
          'span'
        ).outerHTML;
      })).to eq(
        '<span id="x" class="y z">hello</span>'
      )
    end

    it 'leaves element untouched and applies sel' do

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.on('#cars', '.europe .car', 'click', function(ev) {
          ev.target.remove();
        });
        H.elt('.car.bentley').click();
        return H.elt('#cars .europe').innerHTML;
      })).to eqh(%{
        <div class="car volkswagen">
          <div class="blue">blue volkswagen</div>
          <div class="yellow">yellow volkswagen</div>
          <div class="purple">1234</div>
          <div class="red">1234.09</div>
        </div>
      })
    end

    it 'works  .on(sel, ev, fun)' do

      expect(evaluate(%{
        H.on('#cars .europe .car', 'click', function(ev) {
          ev.target.remove();
        });
        H.elt('.car.bentley').click();
        return H.elt('#cars .europe').innerHTML;
      })).to eqh(%{
        <div class="car volkswagen">
          <div class="blue">blue volkswagen</div>
          <div class="yellow">yellow volkswagen</div>
          <div class="purple">1234</div>
          <div class="red">1234.09</div>
        </div>
      })
    end

    it 'works  .on(sel, [ evname0, evname1 ], fun)' do

      expect(evaluate(%{
        var a = [];
        H.on('#cars .europe .car', [ 'click', 'foo' ], function(ev) {
          a.push(event.type);
        });
        H.elt('.car.bentley').click();
        H.elt('.car.bentley').dispatchEvent(new Event('foo'));
        H.elt('.car.bentley').dispatchEvent(new Event('bar'));
        return a;
      })).to eq(%w[
        click foo
      ])
    end

    it 'works  .on(sel, "change, keyup", fun)' do

      expect(evaluate(%{
        var a = [];
        H.on('#cars .europe .car', 'click,foo/baz hoge', function(ev) {
          a.push(event.type);
        });
        H.elt('.car.bentley').click();
        H.elt('.car.bentley').dispatchEvent(new Event('foo'));
        H.elt('.car.bentley').dispatchEvent(new Event('bar'));
        H.elt('.car.bentley').dispatchEvent(new Event('baz'));
        H.elt('.car.bentley').dispatchEvent(new Event('hogo'));
        H.elt('.car.bentley').dispatchEvent(new Event('hoge'));
        return a;
      })).to eq(%w[
        click foo baz hoge
      ])
    end

    it 'fails if there is no event handler' do

      expect(evaluate(%{
        var a = [];
        try {
          H.on('#cars .europe .car', function(ev) {});
          a.push('ok');
        }
        catch(err) {
          a.push(err);
        }
        return a;
      })).to eq([ %{
        eventHandler is missing
      }.strip ])
    end

    it 'works  .on(sel, "click.", fun) (do not trigger for children elts)' do

      expect(evaluate(%{
        var a = [];
        H.on('#cars .europe', 'click', function(ev) { a.push(0); });
        H.on('#cars .europe', 'click.', function(ev) { a.push(1); });
        H.elt('#cars').click();
        H.elt('#cars .europe').click();
        H.elt('#cars .europe .bentley').click();
        H.elt('#cars .europe').click();
        return a;
      })).to eq([
        0, 1, 0, 0, 1
      ])
    end
  end

  describe '.enable' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .enable(sel)' do

      expect(evaluate(%{
        H.enable('input[name="first-name"]');
        return H.elt('input[name="first-name"]').outerHTML;
      })).to eq(%{
<input type="text" name="first-name">
      }.strip)
    end

    it 'works  .enable(sel, bool)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.enable(H.elt('input[name="last-name"]'), "".match(/nada/));
        return [
          H.elt('input[name="last-name"]').outerHTML
        ];
      })).to eq([
        '<input type="text" name="last-name" disabled="disabled">'
      ])
    end

    it 'works  .enable(sel, fun)' do

      expect(evaluate(%{
        H.enable('#input input', function(e) {
          return e.getAttribute('name').match(/name/);
        });
        return H.elt('#input form').innerHTML;
      })).to eqh(%{
        <input type="text" name="name">
        <input type="text" name="first-name">
        <input type="text" name="last-name">
        <input type="number" name="age" disabled="disabled">
        <input class="i" type="text" name="alpha" disabled="disabled">
        <input class="i disabled" type="text" name="bravo" disabled="disabled">
        <input class="i disabled" type="text" name="charly" disabled="disabled">
      })
    end

    it 'works  .enable(start, sel)' do

      expect(evaluate(%{
        var i = H.elt('#input');
        H.enable(i, 'input[name="first-name"]');
        return H.elt(i, 'input[name="first-name"]').outerHTML;
      })).to eq(%{
<input type="text" name="first-name">
      }.strip)
    end

    it 'works  .enable(start, sel, bool)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.disable('#input input', function(e) {
          return ! e.getAttribute('name').match(/name/);
        });
        return H.elt('#input form').innerHTML;
      })).to eqh(%{
        <input type="text" name="name">
        <input type="text" name="first-name">
        <input type="text" name="last-name">
        <input type="number" name="age" disabled="disabled">
        <input class="i" type="text" name="alpha" disabled="disabled">
        <input class="i disabled" type="text" name="bravo" disabled="disabled">
        <input class="i disabled" type="text" name="charly" disabled="disabled">
      })
    end
  end

  describe '.show' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .show(sel)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.show('.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden.shown
        #test3.t.hidden.shown
      ])

      expect(evaluate(%{
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

      expect(evaluate(%{
        var has = H.elt('#hide_and_show');
        H.show(has, '.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.shown
        #test1.t.shown
        #test2.t.hidden.shown
        #test3.t.hidden.shown
      ])

      expect(evaluate(%{
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

  describe '.unshow' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .show(sel)' do

      expect(evaluate(%{
        H.unshow('#test1');
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
        H.hide('.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown.hidden
        #test2.t.hidden
        #test3.t.hidden
      ])

      expect(evaluate(%{
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

      expect(evaluate(%{
        var has = H.elt('#hide_and_show');
        H.hide(has, '.t', true);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown.hidden
        #test2.t.hidden
        #test3.t.hidden
      ])

      expect(evaluate(%{
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

    it 'works when called by forEach' do

      expect(evaluate(%{
        var es = H.elts('#hide_and_show .t');
//return es.map(function(e) { return e.className; });
        es.forEach(H.hide);
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t.hidden
        #test1.t.shown.hidden
        #test2.t.hidden
        #test3.t.hidden
      ])
    end
  end

  describe '.unhide' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .unhide(sel)' do

      expect(evaluate(%{
        H.unhide('#test2');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown
        #test2.t
        #test3.t.hidden
      ])
    end

    it 'works  .unhide(start, sel)' do

      expect(evaluate(%{
        var has = H.elt('#hide_and_show');
        H.unhide(has, '#test2');
        return H.elts('.t').map(function(e) { return e.idAndClasses(); });
      })).to eq(%w[
        #test0.t
        #test1.t.shown
        #test2.t
        #test3.t.hidden
      ])
    end
  end

  describe '.isHidden' do

    it 'works  .isHidden(sel)' do

      expect(evaluate(%{
        return [
          H.isHidden('#test0'),
          H.isHidden('#test2'),
        ];
      })).to eq([
        false, true
      ])
    end

    it 'works  .isHidden(start, sel)' do

      expect(evaluate(%{
        var s = H.elt('#hide_and_show');
        return [
          H.isHidden(s, '.t'),
          H.isHidden(s, '.t:nth-child(3)'),
        ];
      })).to eq([
        false, true
      ])
    end
  end

  describe '.cenable' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works .cenable(sel)' do

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

      expect(evaluate(%{
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

  describe '.isDisabled' do

    it 'works .isDisabled(start)' do

      expect(evaluate(%{
        return [
          H.isDisabled('#input input[name="name"]'),
          H.isDisabled('#input input[name="age"]'),
          H.isDisabled('#input input[name="last-name"]'),
          H.isDisabled('#input input[name="bravo"]'),
        ]
      })).to eq([
        false, true, false, true
      ])
    end

    it 'works .isDisabled(start, sel)' do

      expect(evaluate(%{
        var f = H.elt('#input');
        return [
          H.isDisabled(f, 'input[name="name"]'),
          H.isDisabled(f, 'input[name="age"]'),
          H.isDisabled(f, 'input[name="last-name"]'),
          H.isDisabled(f, 'input[name="bravo"]'),
        ]
      })).to eq([
        false, true, false, true
      ])
    end
  end

  describe '.prepend' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .prepend(sel, elt)' do

      expect(evaluate(%{
        var e = H.create('div.america', {}, '');
        H.prepend('#cars .europe', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="europe">/
      )
    end

    it 'works  .prepend(start, sel, elt)' do

      expect(evaluate(%{
        var cars = H.elt('#cars');
        var e = H.create('div.america', {}, '');
        H.prepend(cars, '.europe', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="europe">/
      )
    end
  end

  describe '.postpend' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .postpend(sel, elt)' do

      expect(evaluate(%{
        var e = H.create('div.america', {}, '');
        H.postpend('#cars .asia', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div>\s*<div class="europe">/
      )
    end

    it 'works  .postpend(start, sel, elt)' do

      expect(evaluate(%{
        var cars = H.elt('#cars');
        var e = H.create('div.america', {}, '');
        H.postpend(cars, '.asia', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div>\s*<div class="europe">/
      )
    end
  end

  describe '.appendAsFirstChild' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .appc(sel, elt)' do

      expect(evaluate(%{
        var e = H.create('div.america', {}, '');
        H.appc('#cars', e);
        return H.elt('#cars').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="asia">/
      )
    end

    it 'works  .appc(start, sel, elt)' do

      expect(evaluate(%{
        var cars = H.elt('#cars');
        var e = H.create('div.america', {}, '');
        H.appc(cars, '.europe', e);
        //return H.elt('#cars').innerHTML;
        return H.elt('#cars .europe').innerHTML;
      })).to match(
        /<div class="america"><\/div><div class="car bentley">/
      )
    end
  end

  describe '.clean' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .clean(sel)' do

      expect(evaluate(%{
        H.clean('#cars .europe');
        return H.elt('#cars').innerHTML;
      })).to eqh(%{
        <div class="asia">
          <div class="car japan mazda">
            <div class="red">red mazda</div>
          </div>
        </div>
        <div class="europe"></div>
      })
    end

    it 'works  .clean(start, sel)' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        H.clean(e, '.europe');
        return H.elt('#cars').innerHTML;
      })).to eqh(%{
        <div class="asia">
          <div class="car japan mazda">
            <div class="red">red mazda</div>
          </div>
        </div>
        <div class="europe"></div>
      })
    end

    it 'works  .clean(start, sel, "cla")' do

      expect(evaluate(%{
        H.clean('#cars', '.europe', 'car');
        return H.elt('#cars .europe').outerHTML;
      })).to eqh(%{
        <div class="europe"></div>
      })
    end

    it 'works  .clean(start, sel, ".cla")' do

      expect(evaluate(%{
        H.clean('#cars', '.europe', '.car');
        return H.elt('#cars .europe').outerHTML;
      })).to eqh(%{
        <div class="europe"></div>
      })
    end
  end

  describe '.remove' do

    before(:each) { reset_dom }
    after(:all) { reset_dom }

    it 'works  .remove(sta)' do

      expect(evaluate(%{
        H.remove('#cars > div');
        return H.elt('#cars').outerHTML;
      })).to eqh(%{
        <div id="cars"></div>
      })
    end

    it 'works  .remove(sta, sel)' do

      expect(evaluate(%{
        H.remove('#hide_and_show', '.t');
        return H.elt('#hide_and_show').outerHTML;
      })).to eqh(%{
        <div id="hide_and_show"></div>
      })
    end

    it 'works  .remove(sta, boo)' do

      expect(evaluate(%{
        H.remove('#sc > div', false);
        return H.elt('#sc').outerHTML;
      })).to eqh(%{
        <div id="sc">
          <div id="sc-test-0"></div>
          <div id="sc-test-1"></div>
          <div id="sc-test-2" class="a"></div>
          <div id="sc-test-3" class="a"></div>
        </div>
      })

      expect(evaluate(%{
        H.remove('#sc > div', true);
        return H.elt('#sc').outerHTML;
      })).to eqh(%{
        <div id="sc"></div>
      })
    end

    it 'works  .remove(sta, bof)' do

      expect(evaluate(%{
        H.remove('#sc > div', function(e) { return H.hasClass(e, 'a'); });
        return H.elt('#sc').outerHTML;
      })).to eqh(%{
        <div id="sc"><div id="sc-test-0"></div><div id="sc-test-1"></div></div>
      })
    end

    it 'works  .remove(sta, sel, bof)' do

      expect(evaluate(%{
        H.remove('#sc', 'div', function(e) { return H.hasClass(e, 'a'); });
        return H.elt('#sc').outerHTML;
      })).to eqh(%{
        <div id="sc"><div id="sc-test-0"></div><div id="sc-test-1"></div></div>
      })
    end

    it 'works  .remove("#gone")' do

      expect(evaluate(%{
        H.remove('#gone');
        return 1;
      })).to eq(1)
    end
  end

  describe '.replace' do

    it 'replaces an elt' do

      expect(evaluate(%{
        var e = H.create('.blue', '', 'blue honda');
        H.replace('#cars .car.japan .red', e);
        return H.elt('#cars .car.japan').innerHTML;
      })).to eqh(%{
        <div class="blue">blue honda</div>
      })
    end

    it 'fails if the target elt cannot be found'
  end

  describe '.dim' do

    it 'returns the dimensions of the target elt' do

      expect(
        evaluate(%{ return H.dim('#cars'); })
          .collect { |k, v| "#{k}:#{v}" }
          .sort
          .join(' ')
      ).to match(
        /\Abottom:\d+ height:\d+ left:\d right:\d+ top:\d width:\d+\z/
      )
    end
  end

  describe '.tdim' do

    it 'returns the dimensions of the target elt' do

      expect(
        evaluate(%{ return H.tdim('#cars'); })
          .collect { |k, v| "#{k}:#{v}" }
          .sort
          .join(' ')
      ).to match(
        /\Abottom:\d+ height:\d+ left:\d right:\d+ top:\d width:\d+\z/
      )
    end
  end

  describe '.bdim' do

    it 'returns the brect-derived dim/pos of the target elt' do

      expect(
        evaluate(%{ return H.bdim('#cars'); })
          .collect { |k, v| "#{k}:#{v}" }
          .sort
          .join(' ')
      ).to match(
        /\Abottom:\d+ height:\d+ left:\d right:\d+ top:\d width:\d+\z/
      )
    end
  end

  describe '.style' do

    it 'returns the style of the target elt' do

      expect(evaluate(%{
        var s = H.style('#list-of-trains');
        return [ s.fontSize, s.marginLeft ];
      })).to eq([
        '16px', '45px'
      ])
    end
  end

  describe '.path' do

    it 'returns null if the elt cannot be found' do

      expect(evaluate(%{
        return [ H.path('#nada'), H.path(document.body, '.nada') ];
      })).to eq([
        nil, nil
      ])
    end

    it 'returns a #path for an element' do

      expect(evaluate(%{
        return H.path('#list-of-trains');
      })).to eq('#list-of-trains')

      expect(evaluate(%{
        return H.path(document, 'body > div');
      })).to eq('#test')
      expect(evaluate(%{
        return H.path('body > div');
      })).to eq('#test')
    end

    it 'returns a pa.t.h for an element' do

      expect(evaluate(%{
        return H.path('#cars .bentley .blue');
      })).to eq(
        '#cars > div.europe > div.car.bentley > div.blue'
      )

      expect(evaluate(%{
        return (
          H.elt('#cars .bentley .blue').innerHTML ===
          H.elt('#cars > div.europe > div.car.bentley > div.blue').innerHTML)
      })).to eq(true)
    end

    it 'returns a pa[name="th"] for an element' do

      expect(evaluate(%{
        return H.path('input[type="number"]');
      })).to eq(%{
        #input > form[name="our-form"] > input[name="age"]
      }.strip)
    end

    it 'returns a :nth-child(x) path for an element' do

      expect(evaluate(%{
        return H.path('.container > span');
      })).to eq(%{
        #for-path > :nth-child(1) > div.container > :nth-child(1)
      }.strip)

      expect(evaluate(%{
        return [
          H.elt(
            '.container > span'
          ).innerHTML,
          H.elt(
            '#for-path > :nth-child(1) > div.container > :nth-child(1)'
          ).innerHTML ];
      })).to eq(%w[
        c c
      ])

      expect(evaluate(%{
        var e = H.elts('.container')[1];
        return H.path(e, 'span');
      })).to eq(%{
        #for-path > :nth-child(2) > :nth-child(2) > div.container > :nth-child(1)
      }.strip)
    end
  end

  describe '.capitalize' do

    it 'works' do

      expect(evaluate(%{
        return H.capitalize('jeff');
      })).to eq(
        'Jeff'
      )
    end
  end

  describe '.decapitalize' do

    it 'works' do

      expect(evaluate(%{
        return H.decapitalize('JEFF');
      })).to eq(
        'jEFF'
      )
    end
  end

  describe '.toCamelCase' do

    it 'works' do

      expect(evaluate(%{
        return [
          H.toCamelCase('ab-cd-ef'), H.toCamelCase('gh_ij-kl')
        ];
      })).to eq(%w[
        abCdEf ghIjKl
      ])
    end

    it 'capitalizes if requested' do

      expect(evaluate(%{
        return [
          H.toCamelCase('ab-cd-ef', true), H.toCamelCase('gh_ij-kl', true)
        ];
      })).to eq(%w[
        AbCdEf GhIjKl
      ])
    end
  end

  describe '.setAtt' do

    it 'sets an attribute' do

      expect(evaluate(%{
        var v = H.setAtt('#for-setAtt .saa', 'att0', 'vvv');
        return [ v, H.getAtt('#for-setAtt .saa', 'att0') ];
      })).to eq([
        'vvv', 'vvv'
      ])
    end

    it 'sets an attribute for all matching elements' do

      expect(evaluate(%{
        var v = H.setAtt('#for-setAtt div', 'att0', 'vvv');
        return [
          v,
          H.getAtt('#for-setAtt .saa', 'att0'),
          H.getAtt('#for-setAtt .sab', 'att0') ];
      })).to eq([
        'vvv', 'vvv', 'vvv'
      ])
    end

    it 'sets attributes as strings of course' do

      expect(evaluate(%{
        var v = H.setAtt('#for-setAtt div', 'att0', 123);
        return [
          v,
          H.getAtt('#for-setAtt .saa', 'att0'),
          H.getAtt('#for-setAtt .sab', 'att0') ];
      })).to eq([
        123, '123', '123'
      ])
    end

    it 'sets attributes for elt, string, att' do

      expect(evaluate(%{
        var e = H.elt('#for-setAtt');
        var v = H.setAtt(e, '.sac .sac1', 'att0', 456);
        return [
          v,
          H.getAtt('#for-setAtt .sac1', 'att0'),
          H.getAtt('#for-setAtt .sac1', 'att0') ];
      })).to eq([
        456, '456', '456'
      ])
    end

    it 'prefixes "data" to "-stuff"' do

      expect(evaluate(%{
        var v = H.setAtt('#for-setAtt div', '-att0', 'xyz');
        return [
          v,
          H.getAtt('#for-setAtt .saa', '-att0'),
          H.getAtt('#for-setAtt .sab', '-att0'),
          H.getAtt('#for-setAtt .saa', 'data-att0'),
          H.getAtt('#for-setAtt .sab', 'data-att0') ];
      })).to eq([
        'xyz', 'xyz', 'xyz', 'xyz', 'xyz'
      ])
    end

    it 'removes the attribute when the value is null' do

      expect(evaluate(%{
        H.setAtt('#for-setAtt .saa', 'att0', 'xyz');
        H.setAtt('#for-setAtt .sab', '-att1', 'xyz');
        var a = [];
        a.push(H.getAtt('#for-setAtt .saa', 'att0'));
        a.push(H.getAtt('#for-setAtt .sab', '-att1'));
        H.setAtt('#for-setAtt .saa', 'att0', null);
        H.setAtt('#for-setAtt .sab', '-att1', null);
        a.push(H.getAtt('#for-setAtt .saa', 'att0'));
        a.push(H.getAtt('#for-setAtt .sab', '-att1'));
        return a;
      })).to eq([
        'xyz', 'xyz', nil, nil
      ])
    end
  end

  describe '.setAtts' do

    before(:each) { reset_dom }

    it 'sets attributes' do

      expect(evaluate(%{
        var h0 = H.elt('#for-setAtt .saa').outerHTML;
        H.setAtts('#for-setAtt .saa', { att0: 'x', att1: 1, '-b': 'b' });
        var h1 = H.elt('#for-setAtt .saa').outerHTML;
        return [ h0, h1 ];
      })).to eq([
        '<div class="saa"></div>',
        '<div class="saa" att0="x" att1="1" data-b="b"></div>'
      ])
    end

    it 'unsets attributes when null' do

      expect(evaluate(%{
        var h0 = H.elt('#for-setAtt .saa').outerHTML;
        H.setAtts('#for-setAtt .saa', { att0: 'x', att1: 1 });
        var h1 = H.elt('#for-setAtt .saa').outerHTML;
        H.setAtts('#for-setAtt .saa', { att1: null, att2: 2 });
        var h2 = H.elt('#for-setAtt .saa').outerHTML;
        return [ h0, h1, h2 ];
      })).to eq([
        '<div class="saa"></div>',
        '<div class="saa" att0="x" att1="1"></div>',
        '<div class="saa" att0="x" att2="2"></div>'
      ])
    end
  end

  describe '.remAtt' do

    it 'removes an attribute' do

      expect(evaluate(%{
        H.setAtt('#for-setAtt .saa', 'att0', 'xyz');
        H.setAtt('#for-setAtt .sab', '-att1', 'xyz');
        H.setAtt('#for-setAtt .sab', 'att2', 'xyz');
        H.setAtt('#for-setAtt .sab', 'att3', 'xyz');
        var a = [];
        a.push(H.getAtt('#for-setAtt .saa', 'att0'));
        a.push(H.getAtt('#for-setAtt .sab', '-att1'));
        a.push(H.getAtt('#for-setAtt .sab', 'att2'));
        a.push(H.getAtt('#for-setAtt .sab', 'att3'));
        H.remAtt('#for-setAtt .saa', 'att0');
        H.remAtt('#for-setAtt .sab', '-att1');
        H.remAtt(H.elt('#for-setAtt'), '.sab', 'att2');
        H.remAtt('#for-setAtt', '.sab', 'att3');
        a.push(H.getAtt('#for-setAtt .saa', 'att0'));
        a.push(H.getAtt('#for-setAtt .sab', '-att1'));
        a.push(H.getAtt('#for-setAtt .sab', 'att2'));
        a.push(H.getAtt('#for-setAtt .sab', 'att3'));
        return a;
      })).to eq([
        'xyz', 'xyz', 'xyz', 'xyz', nil, nil, nil, nil
      ])
    end
  end

  describe '.getAtt' do

    it 'returns an attribute value' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtt(e, '.gaa', 'data-hjs-alpha');
      })).to eq(%{
        alpha
      }.strip)
    end

    it 'returns null else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtt(e, '.gaa', 'data-hjs-omega');
      })).to eq(
        nil
      )
    end

    it 'returns the given default else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtt(e, '.gaa', 'data-hjs-omega', 'omega');
      })).to eq(%{
        omega
      }.strip)
    end

    it 'automatically prefixes "-x-y-z" into "data-x-y-z"' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return [
          H.getAtt(e, '.gaa', '-hjs-alpha'),
          H.getAtt(e, '.gaa', '-hjs-omega'),
          H.getAtt(e, '.gaa', '-hjs-omega', 'omega')
        ];
      })).to eq([
        'alpha', nil, 'omega'
      ])
    end

    it 'works  H.getAtt(sta, "[data-hjs-data-prefix]")' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return [
          H.getAtt(e, '[data-hjs-alpha]'),
          H.getAtt(e, '[data-hjs-alpha]', 'non-alpha'),
          H.getAtt(e, '[data-hjs-omega]'),
          H.getAtt(e, '[data-hjs-omega]', 'omega'),
          H.getAtt(e, '[-hjs-alpha]'),
          H.getAtt(e, '[-hjs-alpha]', 'non-alpha'),
          H.getAtt(e, '[-hjs-omega]'),
          H.getAtt(e, '[-hjs-omega]', 'omega'),
        ];
      })).to eq([
        'alpha', 'alpha', nil, 'omega',
        'alpha', 'alpha', nil, 'omega'
      ])
    end

    it 'works  H.getAtt(sta, ".nest [data-hjs-data-prefix]")' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return [
          H.getAtt(e, '.nest [data-hjs-gamma]'),
          H.getAtt(e, '.nest [data-hjs-gamma]', 'non-gamma'),
          H.getAtt(e, '.nest [data-hjs-omega]'),
          H.getAtt(e, '.nest [data-hjs-omega]', 'omega'),
          H.getAtt(e, '.nest [-hjs-gamma]'),
          H.getAtt(e, '.nest [-hjs-gamma]', 'non-gamma'),
          H.getAtt(e, '.nest [-hjs-omega]'),
          H.getAtt(e, '.nest [-hjs-omega]', 'omega')
        ];
      })).to eq([
        'gogo', 'gogo', nil, 'omega',
        'gogo', 'gogo', nil, 'omega'
      ])
    end

    it 'works with ^' do

# var e = H.elt('#mandates span.target'); H.getAtt(e, '^div[-xx-uri]', '-xx-module')
      expect(evaluate(%{
        var b = window.body;
        var e = H.elt('#mandates span.target');
        return [
          H.getAtt('div[-xx-uri]', '-xx-module'),
          H.getAtt(b, 'div[-xx-uri]', '-xx-module'),
          H.getAtt(e, '^div', '-xx-module'),
          H.getAtt(e, '^div[-xx-uri]', '-xx-module'),
        ];
      })).to eq([
        'module', 'module', 'module', 'module'
      ])
    end
  end

  describe '.getAtti' do

    it 'returns an attribute value as an integer' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtti(e, '.gab', 'data-hjs-bravo');
      })).to eq(
        2
      )
      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtti(e, '.gac', 'data-hjs-charly');
      })).to eq(
        3
      )
    end

    it 'returns null else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtti(e, '.gaa', 'data-hjs-omega');
      })).to eq(
        nil
      )
    end

    it 'returns the given default else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAtti(e, '.gaa', 'data-hjs-omega', -12);
      })).to eq(
        -12
      )
    end

    it "doesn't mind 0 as the returned value" do

      expect(evaluate(%{
        var e = H.elt('#for-getAtti');
        return H.getAtti(e, '.gati-one', 'data-hjs-nada');
      })).to eq(
        0
      )
    end

    it "doesn't default when 0 is the value" do

      expect(evaluate(%{
        var e = H.elt('#for-getAtti');
        return H.getAtti(e, '.gati-one', 'data-hjs-nada', -99);
      })).to eq(
        0
      )
    end

    it 'automatically prefixes "-x-y-z" into "data-x-y-z"' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return [
          H.getAtti(e, '.gaa', '-hjs-alpha'),
          H.getAtti(e, '.gab', '-hjs-bravo'),
          H.getAtti(e, '.gac', '-hjs-charly'),
          H.getAtti(e, '.gad', '-hjs-delta'),
          H.getAtti(e, '.gaa', '-hjs-omega'),
          H.getAtti(e, '.gaa', '-hjs-omega', 77)
        ];
      })).to eq([
        nil, 2, 3, nil, nil, 77
      ])
    end
  end

  describe '.getAttf' do

    it 'returns an attribute value as a float' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAttf(e, '.gab', 'data-hjs-bravo');
      })).to eq(
        2.0
      )
      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAttf(e, '.gac', 'data-hjs-charly');
      })).to eq(
        3.3
      )
    end

    it 'returns null else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAttf(e, '.gaa', 'data-hjs-omega');
      })).to eq(
        nil
      )
    end

    it 'returns the given default else' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return H.getAttf(e, '.gaa', 'data-hjs-omega', -12);
      })).to eq(
        -12.0
      )
    end

    it 'automatically prefixes "-x-y-z" into "data-x-y-z"' do

      expect(evaluate(%{
        var e = H.elt('#for-getAtt');
        return [
          H.getAttf(e, '.gaa', '-hjs-alpha'),
          H.getAttf(e, '.gab', '-hjs-bravo'),
          H.getAttf(e, '.gac', '-hjs-charly'),
          H.getAttf(e, '.gad', '-hjs-delta'),
          H.getAttf(e, '.gaa', '-hjs-omega'),
          H.getAttf(e, '.gaa', '-hjs-omega', 77)
        ];
      })).to eq([
        nil, 2, 3.3, nil, nil, 77
      ])
    end

    it "doesn't mind 0 as the returned value" do

      expect(evaluate(%{
        var e = H.elt('#for-getAtti');
        return H.getAttf(e, '.gati-one', 'data-hjs-nada');
      })).to eq(
        0
      )
    end

    it "doesn't default when 0 is the value" do

      expect(evaluate(%{
        var e = H.elt('#for-getAtti');
        return H.getAttf(e, '.gati-one', 'data-hjs-nada', -99);
      })).to eq(
        0
      )
    end
  end

  describe '.getAttj' do

    it 'returns the JSON parsed content of the attribute' do

      expect(evaluate(%{
        var e = H.elt('#for-getAttj');
        return [
          H.getAttj(e, '.gatj-one', '-hjs-nada'),
          H.getAttj(e, '.gatj-two', '-hjs-nada'),
        ];
      })).to eq([
        [ 1, 2, { 'a' => 1 } ],
        nil
      ])
    end
  end

  describe '.text' do

    it 'returns the textContent of the target' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        return H.text(e, '.volkswagen .blue');
      })).to eq(%{
        blue volkswagen
      }.strip)
    end

    it 'returns the default if the textContent is empty' do

      expect(evaluate(%{
        return H.text('#empty', null, 'not empty');
      })).to eq(
        'not empty'
      )
    end

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.text('#empty', '.nada');
      }) }.to raise_error(
        'elt not found, no text'
      )
    end
  end

  describe '.getText' do

    it 'returns undefined if there is no elt' do

      expect(evaluate(%{
        return '' + H.getText('#empty', '.nada');
      })).to eq('undefined')
    end

    it 'returns the default if there is no elt' do

      expect(evaluate(%{
        return H.getText('#empty', '.nada', "role'n play");
      })).to eq("role'n play")
    end
  end

  describe '.texti' do

    it 'returns the textContent of the target turned into an integer' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        return H.texti(e, '.volkswagen .purple');
      })).to eq(
        1234
      )
    end

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.texti('#empty', '.nada');
      }) }.to raise_error(
        'elt not found, no text'
      )
    end

    it 'returns the last (default) value if the element is empty' do

      expect(evaluate(%{
        return [
          H.texti('#empty'),
          H.texti('#empty', -99),
          H.texti('#empty', 0),
          H.texti('#empty', 12),
          H.texti('#empty', 0.1) ];
      })).to eq([
        nil, -99, 0, 12, 0
      ])
    end
  end

  describe '.textf' do

    it 'returns the textContent of the target turned into a float' do

      expect(evaluate(%{
        var e = H.elt('#cars');
        return H.textf(e, '.volkswagen .red');
      })).to eq(
        1234.09
      )
    end

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.textf('#empty', '.nada');
      }) }.to raise_error(
        'elt not found, no text'
      )
    end

    it 'returns the last (default) value if the element is empty' do

      expect(evaluate(%{
        return [
          H.textf('#empty'),
          H.textf('#empty', -99),
          H.textf('#empty', 0),
          H.textf('#empty', 12),
          H.textf('#empty', 0.1) ];
      })).to eq([
        nil, -99, 0, 12, 0.1
      ])
    end
  end

  describe '.set' do

    it 'sets <input>' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="tzar"]', 'Nicolas II');
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        H.set('#for-set-and-get [name="tzar"]', null);
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        H.set('#for-set-and-get [name="tzar"]', undefined);
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        H.set('#for-set-and-get [name="tzar"]', 1.1);
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        return a;
      })).to eq([
        'Nicolas II', '', '', '1.1'
      ])
    end

    it 'sets <select>' do

      expect(evaluate(%{
        var a = [];
        a.push(H.elt('#for-set-and-get [name="era"]').value);
        H.set('#for-set-and-get [name="era"]', 'napo');
        a.push(H.elt('#for-set-and-get [name="era"]').value);
        H.set('#for-set-and-get [name="era"]', 'NADA');
        a.push(H.elt('#for-set-and-get [name="era"]').value);
        H.set('#for-set-and-get [name="era"]', null);
        a.push(H.elt('#for-set-and-get [name="era"]').value);
        return a;
      })).to eq([
        'rena', 'napo', '', ''
      ])
    end

    it 'sets <textarea>' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="bio"]', "a and b");
        a.push(H.elt('#for-set-and-get [name="bio"]').value);
        H.set('#for-set-and-get [name="bio"]', 1);
        a.push(H.elt('#for-set-and-get [name="bio"]').value);
        return a;
      })).to eq([
        'a and b', '1'
      ])
    end
  end

  describe '.get' do

    it 'gets from <input>' do

      expect(evaluate(%{
        H.set('#for-set-and-get [name="tzar"]', 'Ivan IV Vasilyevich');
        return H.get('#for-set-and-get [name="tzar"]');
      })).to eq(
        'Ivan IV Vasilyevich'
      )
    end

    it 'gets from <select>' do

      expect(evaluate(%{
        H.set('#for-set-and-get [name="era"]', 'vict');
        return H.get('#for-set-and-get [name="era"]');
      })).to eq(
        'vict'
      )
    end

    it 'gets from <textarea>' do

      expect(evaluate(%{
        H.set('#for-set-and-get [name="bio"]', "a and b and c");
        return H.get('#for-set-and-get [name="bio"]');
      })).to eq(
        'a and b and c'
      )
    end

    it 'gets from <input> (false)' do

      expect(evaluate(%{
        var start = H.elt('#for-set-and-get');
        H.set('#for-set-and-get [name="tzar"]', '');
        return H.get(start, '[name="tzar"]', false);
      })).to eq(
        nil
      )
    end

    it 'gets from <select> (false)' do

      expect(evaluate(%{
        H.set('#for-set-and-get [name="era"]', '');
        return H.get('#for-set-and-get [name="era"]', false);
      })).to eq(
        nil
      )
    end

    it 'gets from <textarea> (false)' do

      expect(evaluate(%{
        H.set('#for-set-and-get [name="bio"]', '');
        return H.get('#for-set-and-get [name="bio"]', false);
      })).to eq(
        nil
      )
    end
  end

  describe '.getb' do

    it 'gets a boolean' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="bio"]', 'true');
        a.push(H.getb('#for-set-and-get [name="bio"]'));
        H.set('#for-set-and-get [name="bio"]', 'false');
        a.push(H.getb('#for-set-and-get [name="bio"]'));
        H.set('#for-set-and-get [name="bio"]', 'yes');
        a.push(H.getb('#for-set-and-get [name="bio"]'));
        H.set('#for-set-and-get [name="bio"]', 'no');
        a.push(H.getb('#for-set-and-get [name="bio"]'));
        H.set('#for-set-and-get [name="bio"]', '');
        a.push(H.getb('#for-set-and-get [name="bio"]'));
        return a;
      })).to eq([
        true, false, true, false, false
      ])
    end

    it 'gets a boolean (default)' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="bio"]', '');
        a.push(H.getb('#for-set-and-get [name="bio"]', true));
        a.push(H.getb('#for-set-and-get [name="bio"]', false));
        H.set('#for-set-and-get [name="bio"]', 'true');
        a.push(H.getb('#for-set-and-get [name="bio"]', true));
        a.push(H.getb('#for-set-and-get [name="bio"]', false));
        H.set('#for-set-and-get [name="bio"]', 'false');
        a.push(H.getb('#for-set-and-get [name="bio"]', true));
        a.push(H.getb('#for-set-and-get [name="bio"]', false));
        return a;
      })).to eq([
        true, false, true, true, false, false
      ])
    end
  end
  describe '.getf' do

    it 'gets a float' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="tzar"]', '1.1');
        a.push(H.getf('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '1.0');
        a.push(H.getf('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '');
        a.push(H.getf('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '1');
        a.push(H.getf('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '.1');
        a.push(H.getf('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '');
        a.push(H.getf('#for-set-and-get [name="tzar"]', false));
        return a;
      })).to eq([
        1.1, 1, nil, 1, 0.1, nil
      ])
    end

    it 'gets a float (default)' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="tzar"]', null);
        a.push(H.getf('#for-set-and-get [name="tzar"]', 1.2));
        H.set('#for-set-and-get [name="tzar"]', 1.0);
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        a.push(H.getf('#for-set-and-get [name="tzar"]', 1.3));
        return a;
      })).to eq([
        1.2, '1', 1
      ])
    end
  end

  describe '.geti' do

    it 'gets an integer' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="tzar"]', '1.1');
        a.push(H.geti('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '1.0');
        a.push(H.geti('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '');
        a.push(H.geti('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '1');
        a.push(H.geti('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '.1');
        a.push(H.geti('#for-set-and-get [name="tzar"]'));
        H.set('#for-set-and-get [name="tzar"]', '');
        a.push(H.geti('#for-set-and-get [name="tzar"]', false));
        return a;
      })).to eq([
        1, 1, nil, 1, nil, nil
      ])
    end

    it 'gets an integer (default)' do

      expect(evaluate(%{
        var a = [];
        H.set('#for-set-and-get [name="tzar"]', null);
        a.push(H.geti('#for-set-and-get [name="tzar"]', 1.2));
        H.set('#for-set-and-get [name="tzar"]', 1.0);
        a.push(H.elt('#for-set-and-get [name="tzar"]').value);
        a.push(H.geti('#for-set-and-get [name="tzar"]', 1.3));
        return a;
      })).to eq([
        1, '1', 1
      ])
    end
  end

  describe '.getj' do

    it 'gets and parses some JSON' do

      expect(evaluate(%{
        var a = [];
        a.push(H.getj('#for-getj [name="fgja"]'));
        a.push(H.getj('#for-getj [name="fgja"]', -1));
        a.push(H.getj('#for-getj [name="fgjz"]', -2));
        a.push(H.getj('#for-getj', '[name="fgja"]'));
        a.push(H.getj('#for-getj', '[name="fgjz"]'));
        return a;
      })).to eq([
        { 'name' => 'Henri Gouraud' },
        { 'name' => 'Henri Gouraud' },
        -2,
        { 'name' => 'Henri Gouraud' },
        nil,
      ])
    end
  end

  describe '.textOrValue' do

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.textOrValue('#outthere');
      }) }.to raise_error(
        'elt not found, no text or value'
      )
    end

    it 'returns the text or the value' do

      expect(evaluate(%{
        return [
          H.textOrValue('[name="ftov0"]'),
          H.textOrValue('#ftov1'),
          H.textOrValue('#empty') ];
      })).to eq([
        'alpha', 'bravo', ''
      ])
    end
  end

  describe '.tov' do

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.tov('#outthere');
      }) }.to raise_error(
        'elt not found, no text or value'
      )
    end

    it 'returns the text or the value' do

      expect(evaluate(%{
        return [
          H.tov('[name="ftov0"]'),
          H.tov('#ftov1'),
          H.tov('#empty') ];
      })).to eq([
        'alpha', 'bravo', ''
      ])
    end

    it 'returns the default value when empty' do

      expect(evaluate(%{
        var s = H.elt('#for-tov');
        return [
          H.tov(s, '[name="ftovempty0"]', 'xxx'),
          H.tov(s, '#ftovempty1', 'yyy') ];
      })).to eq([
        'xxx', 'yyy'
      ])
    end
  end

  describe '.tovb' do

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.tovb('#outthere');
      }) }.to raise_error(
        'elt not found, no text or value'
      )
    end

    it 'returns the value or text as a float' do

      expect(evaluate(%{
        return [
          H.tovb('[name="ftovb0"]'),
          H.tovb('#ftovb1'),
          H.tovb('[name="ftovb2"]'),
          H.tovb('#ftovb3'),
          H.tovb('#empty') ];
      })).to eq([
        true, true, false, false, false
      ])
    end

    it 'returns the default value when empty' do

      expect(evaluate(%{
        var s = H.elt('#for-tov');
        return [
          H.tovb(s, '[name="ftovempty0"]', 'false'),
          H.tovb(s, '#ftovempty1', false),
          H.tovb(s, '[name="ftovempty0"]', true),
          H.tovb(s, '#ftovempty1', 'yes') ];
      })).to eq([
        false, false, true, true
      ])
    end
  end

  describe '.tovi' do

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.tovi('#outthere');
      }) }.to raise_error(
        'elt not found, no text or value'
      )
    end

    it 'returns the value or text as an integer' do

      expect(evaluate(%{
        return [
          H.tovi('[name="ftovi0"]'),
          H.tovi('#ftovi1'),
          H.tovi('#empty') ];
      })).to eq([
        123, 4321, nil
      ])
    end

    it 'returns the default value when empty' do

      expect(evaluate(%{
        var s = H.elt('#for-tov');
        return [
          H.tovi(s, '[name="ftovempty0"]', 123),
          H.tovi(s, '#ftovempty1', 1.2) ];
      })).to eq([
        123, 1
      ])
    end
  end

  describe '.tovf' do

    it 'fails if the elt does not exist' do

      expect { evaluate(%{
        return H.tovf('#outthere');
      }) }.to raise_error(
        'elt not found, no text or value'
      )
    end

    it 'returns the value or text as a float' do

      expect(evaluate(%{
        return [
          H.tovf('[name="ftovf0"]'),
          H.tovf('#ftovf1'),
          H.tovf('#empty') ];
      })).to eq([
        432.01, 41.01, nil
      ])
    end

    it 'returns the default value when empty' do

      expect(evaluate(%{
        var s = H.elt('#for-tov');
        return [
          H.tovf(s, '[name="ftovempty0"]', 123),
          H.tovf(s, '#ftovempty1', -1.2) ];
      })).to eq([
        123, -1.2
      ])
    end
  end

  describe '.setText' do

    it 'sets the .textContent' do

      expect(evaluate(%{
        var a = [];
        H.setText('#for-create', 'plus quam nada');
        a.push(H.elt('#for-create').textContent.trim());
        H.setText('body div', 'parasitoi');
        a.push(H.elt('#test').textContent.trim());
        return a;
      })).to eq([
        'plus quam nada',
        'parasitoi'
      ])
    end
  end

  describe '.onDocumentReady' do

    it 'works (well...)' do

      expect(evaluate(%{
        var s = 'not ready';
        H.onDocumentReady(function() { s = document.readyState; });
        return s;
      })).to eq(
        'complete'
      )
    end
  end

  describe '.isElement' do

    {
      '0' => false,
      'null' => false,
      'undefined' => false,
      'H.elt("div.europe")' => true,
      'document.body' => true,
      '[]' => false,
      '{}' => false,

    }.each do |k, v|

      it "returns #{v} for #{k}" do

        expect(evaluate(%{ return H.isElement(#{k}); })).to eq(v)
      end
    end
  end

  describe '.isHash' do

    {
      '{}' => true,
      '[]' => false,
      'null' => false,
      'undefined' => false,
      '0' => false,

    }.each do |k, v|

      it "returns #{v} for #{k}" do

        expect(evaluate(%{ return H.isHash(#{k}); })).to eq(v)
      end
    end
  end

  describe '.isArguments' do

    {
      '(function() { return arguments; })()' => true,
      '(function() { return {}; })()' => false,
      '{}' => false,
      '[]' => false,
      'null' => false,
      'undefined' => false,
      '0' => false,

    }.each do |k, v|

      it "returns #{v} for #{k}" do

        expect(evaluate(%{ return H.isArguments(#{k}); })).to eq(v)
      end
    end
  end
end


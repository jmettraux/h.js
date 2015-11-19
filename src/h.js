//
// Copyright (c) 2015-2015, John Mettraux, jmettraux@gmail.com
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

var H = (function() {

  var self = this;

  this.VERSION = '1.0.0';

  var toEltRefine = function(start, sel) {

    if ( ! sel) { sel = start; start = document; }

    if ( ! start) { start = document; }
    if ((typeof start) === 'string') start = document.querySelector(start);

    return [ start, sel ];
  };

  var toElt = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];

    return ((typeof sel) === 'string') ?  sta.querySelector(sel) : sel;
  };

  var toElts = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];
    var es = (typeof sel) === 'string' ?  sta.querySelectorAll(sel) : [ sel ];
    var r = []; for (var i = 0, l = es.length; i < l; i++) { r.push(es[i]); };

    return r;
  };

  this.elt = function(start, selector) { return toElt(start, selector); };
  this.elts = function(start, selector) { return toElts(start, selector); };

  this.forEach = function(start, selector, func) {

    if ((typeof selector) === 'function') { func = selector; selector = null; }

    var r = toElts(start, selector);
    r.forEach(func);

    return r;
  };

  this.dim = function(start, selector) {

    var e = toElt(start, selector);

    if ( ! e) return null;

    return {
      top: e.offsetTop,
      bottom: e.offsetTop + e.offsetHeight,
      left: e.offsetLeft,
      right: e.offsetLeft + e.offsetWidth,
      height: e.offsetHeight,
      width: e.offsetWidth,
    }
  }

  var onOrOff = function(dir, start, sel, eventName, eventHandler) {

    if ( ! eventHandler) {
      eventHandler = eventName; eventName = sel; sel = start; start = document;
    }

    var es = toElts(start, sel);
    for (var i = 0; ; i++) {
      var e = es[i]; if ( ! e) break;
      if (dir === 'on') e.addEventListener(eventName, eventHandler);
      else /* off */ e.removeEventListener(eventName, eventHandler);
    }
  };

  this.on = function(start, sel, eventName, eventHandler) {
    onOrOff('on', start, sel, eventName, eventHandler);
  };

  this.off = function(start, sel, eventName, eventHandler) {
    onOrOff('off', start, sel, eventName, eventHandler);
  };

  var indexNext = function(sel) {

    var d = sel.indexOf('.'); var s = sel.indexOf('#');
    if (d < 0) return s; if (s < 0) return d;
    return d < s ? d : s;
  };

  this.create = function(sel, atts, text) {

    sel = '%' + sel;
    if ((typeof atts) === 'string') { text = atts; atts = {}; }

    var e = document.createElement('div');

    for (var i = 0, l = sel.length; i < l; ) {

      var t = sel.substring(i, i + 1);
      var j = indexNext(sel.substring(i + 1));
      var s = j > -1 ? sel.substring(i + 1, i + 1 + j) : sel.substring(i + 1);

      if (s.length > 0) {
        if (t === '%') e = document.createElement(s);
        else if (t === '#') e.id = s;
        else if (t === '.') e.classList.add(s);
      }

      if (j < 0) break;
      i = i + 1 + j;
    }

    for (var k in atts) e.setAttribute(k, atts[k]);

    if (text) e.appendChild(document.createTextNode(text));

    return e;
  };

  this.toNode = function(html) {

    var e = document.createElement('div');
    e.innerHTML = html; // :-(

    return e.children[0];
  };

  var defaultOn = function(type, method, uri) {

    return function(res) {
      if (type === 'load') console.log([ method + ' ' + uri, res ]);
      else console.log([ meth + ' ' + uri + ' connection problem', res ]);
    }
  };

  this.request = function(method, uri, data, callbacks) {

    if ( ! callbacks) { callbacks = data; data = null; }
    if ((typeof callbacks) === 'function') callbacks = { onok: callbacks };

    var r = new XMLHttpRequest();
    r.open(method, uri, true);

    if (data) {
      if (data.constructor.toString().match(/FormData/)) {
        //r.setRequestHeader('Content-Type', 'application/form-data');
      }
      else {
        r.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
        data = (typeof data) === 'string' ? data : JSON.stringify(data);
      }
    }

    r.onload = function() {
      var o = { status: r.status, request: r };
      o.data = null; try { o.data = JSON.parse(r.responseText); } catch (ex) {};
      if (callbacks.onok && r.status === 200)
        callbacks.onok(o);
      else
        (callbacks.onload || defaultOn('load', method, uri))(o);
    };
    r.onerror = callbacks.onerror || defaultOn('error', method, uri);

    r.send(data);
  };

  this.upload = function(uri, inputFileElt_s, data, callbacks) {

    if ( ! callbacks) { callbacks = data; data = {}; }

    var fd = new FormData();

    for (var k in data) fd.append(k, data[k]);

    var isMulti = Array.isArray(inputFileElt_s);
    var elts = isMulti ? inputFileElt_s : [ inputFileElt_s ];

    var fcount = 0;

    elts.forEach(function(elt) {

      var files = elt.files;

      for (var i = 0, l = files.length; i < l; i++) {

        fcount = fcount + 1;

        var f = files[i];

        var l = null;
        for (var j = 0, al = elt.attributes.length; j < al; j++) {
          var a = elt.attributes.item(j);
          if (a.name.match(/^data-(.*-)?lang$/)) { l = a.value; break; }
        }

        var k = 'file-';
        if (l || isMulti) k = k + elt.name + '-';
        if (l) k = k + l + '-';
        k = k + i;

        fd.append(k, f, f.name);
      }
    });

    if (fcount < 1) return 0;

    var onok = callbacks.onok;
    callbacks.onok = function(res) {
      elts.forEach(function(elt) { elt.value = ''; });
      onok(res);
    };

    H.request('POST', uri, fd, callbacks);

    return fcount;
  };

  this.matches = function(elt, sel) {

    if (elt.matches) return elt.matches(sel);
    if (elt.matchesSelector) return elt.matchesSelector(sel);
    if (elt.msMatchesSelector) return elt.msMatchesSelector(sel);

    throw "browser doesn't support elt.matches() or elt.matchesSelector()";
  };

  this.closest = function(start, sel, sel1) {

    if ( ! sel1) { sel1 = sel; sel = start; start = null; }
    var elt = toElt(start, sel);

    if (H.matches(elt, sel1)) return elt;

    return elt.parentElement ? H.closest(elt.parentElement, sel1) : null;
  };

  // adapted from http://upshots.org/javascript/jquery-copy-style-copycss
  //
  this.style = function(start, sel) {

    var elt = toElt(start, sel);

    var r = {};
    var style = null;

    if (window.getComputedStyle) {

      style = window.getComputedStyle(elt, null);

      for (var i = 0, l = style.length; i < l; i++) {
        var p = style[i];
        var n = p.replace(
          /-([a-za])/g, function(a, b) { return b.toUpperCase(); })
        r[n] = style.getPropertyValue(p);
      }

      return r;
    }

    if (style = elt.currentStyle) {

      for (var p in style) r[p] = style[p];
      return r;
    }

    if (style = elt.style) {

      for (var p in style) {
        var s = style[p];
        if ((typeof s) !== 'function') r[p] = s;
      }

      //return r;
    }

    return r;
  };

  this.hasClass = function(start, sel, className) {

    if ( ! className) { className = sel; sel = start; start = null; }

    var elt = toElt(start, sel);
    if (className[0] === '.') className = className.substring(1);

    try {
      if (elt.classList) return elt.classList.contains(className);
      return (new RegExp('\\b' + className + '\\b')).test(elt.className);
    }
    catch (ex) {
      return false;
    }
  };

  var reclass = function(start, sel, cla, dir) {

    if ( ! cla) { cla = sel; sel = start; start = null; }

    if (cla[0] === '.') cla = cla.substring(1);

    toElts(start, sel).forEach(function(e) {
      e.classList[dir == 'r' ? 'remove' : 'add'](cla);
    });
  };

  this.addClass = function(start, sel, cla) { reclass(start, sel, cla, 'a'); }
  this.removeClass = function(start, sel, cla) { reclass(start, sel, cla, 'r'); };

  var visit = function(start, sel, bof, onTrue, onFalse) {

    H.forEach(start, sel, function(e) {

      var b = ((typeof bof) === 'function') ? bof(e) : bof;
      var fun = b ? onTrue : onFalse; if (fun) fun(e);
    });
  };

  var toggle = function(start, sel, bof, cla, inv) {

    var t = (typeof sel);
    if (t === 'function' || t === 'boolean') {
      bof = sel; sel = start; start = null;
    }
    if (bof === undefined) bof = true;

    var add = function(e) { self.addClass(e, cla); };
    var rem = function(e) { self.removeClass(e, cla); };

    visit(start, sel, bof, inv ? rem : add, inv ? add : rem);
  };

  this.toggleClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }

    toggle(start, sel, function(e) { return ! self.hasClass(e, cla); }, cla);
  };
  this.toggle = this.toggleClass;

  this.show = function(start, sel, bof) { toggle(start, sel, bof, '.shown'); };
  this.hide = function(start, sel, bof) { toggle(start, sel, bof, '.hidden'); };

  var able = function(start, sel, bof, dir) {

    var t = (typeof sel);
    if (t === 'function' || t === 'boolean') {
      bof = sel; sel = start; start = null;
    }
    else if (t === 'undefined') {
      sel = start; start = null;
    }
    if (bof === undefined) bof = true;

    var en = function(e) { e.removeAttribute('disabled') };
    var dis = function(e) { e.setAttribute('disabled', 'disabled'); };

    visit(start, sel, bof, dir === 'e' ? en : dis, dir === 'e' ? dis : en);
  };

  this.enable = function(start, sel, bof) { able(start, sel, bof, 'e'); };
  this.disable = function(start, sel, bof) { able(start, sel, bof, 'd'); };

  var cable = function(start, sel, bof, dir) {

    toggle(start, sel, bof, '.disabled', dir === 'd');
  };

  this.cenable = function(start, sel, bof) {

    toggle(start, sel, bof, '.disabled', true);
  };

  this.cdisable = function(start, sel, bof) {

    toggle(start, sel, bof, '.disabled', false);
  };

  this.toCamelCase = function(s) {

    return s.replace(
      /([_-][a-z])/g, function(x) { return x.substring(1).toUpperCase(); });
  };

  this.prepend = function(start, sel, child) {

    if ( ! child) { child = sel; sel = start; start = null; }
    var elt = toElt(start, sel);

    elt.parentNode.insertBefore(child, elt);
  };

  this.clean = function(start, sel, claName) {

    var elt = toElt(start, sel);
    if (claName && claName[0] !== '.') claName = '.' + claName;

    if (claName)
      H.forEach(elt, claName, function(e) { e.parentElement.removeChild(e); });
    else
      while (elt.firstChild) elt.removeChild(elt.firstChild);

    return elt;
  };

  this.onDocumentReady = function(f) {

    if (document.readyState != 'loading') f();
    else document.addEventListener('DOMContentLoaded', f);
  };

  //
  // over.

  return this;

}).apply({});


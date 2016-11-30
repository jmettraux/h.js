//
// Copyright (c) 2015-2016, John Mettraux, jmettraux@gmail.com
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

  "use strict";

  var self = this;

  this.VERSION = '1.0.3';

  var toArray = function(a) {

    var aa = []; for (var i = 0, l = a.length; i < l; i++) aa.push(a[i]);

    return aa;
  };

  var toEltRefine = function(start, sel) {

    if ( ! sel) { sel = start; start = document; }

    if ( ! start) { start = document; }
    if ((typeof start) === 'string') start = document.querySelector(start);

    return [ start, sel ];
  };

  var toElt = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];

    if ((typeof sel) !== 'string') return sel;

    var m = (sel.substring(0, 1) === '^') && sel.match(/^\^([^ ]+)(.*)$/);
    if (m) {
      sta = self.closest(sta, m[1]);
      sel = m[2].trim();
    }

    if ( ! sta) return null;
    if (sel) return sta.querySelector(sel);
    return sta;
  };

  var toElts = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];
    var es = (typeof sel) === 'string' ?  sta.querySelectorAll(sel) : [ sel ];
    var r = []; for (var i = 0, l = es.length; i < l; i++) { r.push(es[i]); };

    return r;
  };

  this.elt = function(start, sel) { return toElt(start, sel); };
  this.elts = function(start, sel) { return toElts(start, sel); };

  this.forEach = function(start, sel, fun) {

    if ((typeof sel) === 'function') { fun = sel; sel = null; }

    var r = toElts(start, sel);
    r.forEach(fun);

    return r;
  };

  this.tdim = function(start, sel) {

    var elt = toElt(start, sel); if ( ! elt) return null;

    var left = 0; var top = 0;
    var e = elt;

    while (e) {
      left += e.offsetLeft; top += e.offsetTop;
      e = e.offsetParent;
    }

    return {
      top: top, bottom: top + elt.offsetHeight,
      left: left, right: left + elt.offsetWidth,
      height: elt.offsetHeight, width: elt.offsetWidth
    }
  }

  this.dim = function(start, sel) {

    var e = toElt(start, sel);

    if ( ! e) return null;

    return {
      top: e.offsetTop,
      bottom: e.offsetTop + e.offsetHeight,
      left: e.offsetLeft,
      right: e.offsetLeft + e.offsetWidth,
      height: e.offsetHeight,
      width: e.offsetWidth
    }
  };

  this.path = function(start, sel) {

    var e = toElt(start, sel);
    if ( ! e) return null;

    if (e.id) return '#' + e.id;

    var pp = self.path(e.parentElement);
      // >
    var nn = e.nodeName.toLowerCase();
    var cs = self.classArray(e); cs = cs.length > 0 ? '.' + cs.join('.') : '';
    var an = e.getAttribute('name'); an = an ? '[name="' + an + '"]' : '';

    if (cs !== '' || an !== '') return pp + ' > ' + nn + cs + an;

    //var sb = e; var n = 0;
    //while (sb.nodeType === Node.ELEMENT_NODE && (sb = sb.previousSibling)) n++;
    var sb = e; var n = 0;
    while (sb) {
      if (sb.nodeType === 1) n++;
      sb = sb.previousSibling;
    }
      //
    return pp + ' > ' + ':nth-child(' + n + ')';
  };

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

  this.toNode = function(html, sel) {

    if ((typeof html) !== 'string') return sel ? self.elt(html, sel) : html;

    var e = document.createElement('div');
    e.innerHTML = html; // :-(
    e = e.children[0];

    return sel ? self.elt(e, sel) : e;
  };

  var defaultOn = function(type, method, uri) {

    return function(res) {
      if (type === 'load') console.log([ method + ' ' + uri, res ]);
      else console.log([ method + ' ' + uri + ' connection problem', res ]);
    }
  };

  var isHeaders = function(o) {

    if ((typeof o) !== 'object') return false;
    for (var k in o) {
      if ((typeof o[k]) !== 'string') return false;
      if ( ! k.match(/^[A-Z][A-Za-z0-9-]+$/)) return false;
    }
    return true;
  };

  this.request = function(method, uri, headers, data, callbacks) {

    // shuffle args

    var as = { met: method, uri: uri };
    if (arguments.length >= 5) {
      as.hds = headers; as.dat = data; as.cbs = callbacks;
    }
    else if (arguments.length === 4) {
      // met uri dat cbs || met uri hds cbs
      if (isHeaders(headers)) as.hds = headers; else as.dat = headers;
      as.cbs = data;
    }
    else if (arguments.length === 3) {
      as.cbs = headers;
    }
    else {
      throw "not enough arguments for H.request";
    }

    if ((typeof as.cbs) === 'function') as.cbs = { onok: as.cbs };
    if ( ! as.hds) as.hds = {};

    // prepare request

    var r = new XMLHttpRequest();
    r.open(as.met, as.uri, true);

    for (var k in as.hds) r.setRequestHeader(k, as.hds[k]);

    if (as.dat) {

      var con = as.dat.constructor.toString();
      var typ = typeof as.dat;
      var cot = as.hds['Content-Type'] || '/json';

      if (con.match(/FormData/)) {
        //r.setRequestHeader('Content-Type', 'application/form-data');
      }
      else if (cot.match(/\/json\b/) || typ !== 'string') {
        r.setRequestHeader('Content-Type', 'application/json; charset=UTF-8');
        as.dat = typ === 'string' ? as.dat : JSON.stringify(as.dat);
      }
      else {
        as.dat = as.dat.toString();
      }
    }

    // prepare callbacks

    r.onload = function() {
      var o = { status: r.status, request: r };
      o.data = null; try { o.data = JSON.parse(r.responseText); } catch (ex) {};
      if (as.cbs.onok && r.status === 200)
        as.cbs.onok(o);
      else
        (as.cbs.onload || defaultOn('load', as.met, as.uri))(o);
    };
    r.onerror = as.cbs.onerror || defaultOn('error', as.met, as.uri);

    // request

    r.send(as.dat);
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

  this.matches = function(start, sel, pat) {

    if ( ! pat) { pat = sel; sel = start; start = null; }
    var elt = toElt(start, sel);

    if (elt.matches) return elt.matches(pat);
    if (elt.matchesSelector) return elt.matchesSelector(pat);
    if (elt.msMatchesSelector) return elt.msMatchesSelector(pat);

    throw "H.js got fed something that doesn't respond to .matches() or .matchesSelector()";
  };

  this.closest = function(start, sel, sel1) {

    if ( ! sel1) { sel1 = sel; sel = start; start = null; }
    var elt = toElt(start, sel);

    if (H.matches(elt, sel1)) return elt;

    return elt.parentElement ? self.closest(elt.parentElement, sel1) : null;
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

  this.hasClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }

    var elt = toElt(start, sel);
    if (cla[0] === '.') cla = cla.substring(1);

    try {
      if (elt.classList) return elt.classList.contains(cla);
      return (new RegExp('\\b' + cla + '\\b')).test(elt.className);
    }
    catch (ex) {
      return false;
    }
  };

  this.isHidden = function(start, sel) {

    var a = toArray(arguments); a.push('.hidden');

    return self.hasClass.apply(null, a);
  };

  var visit = function(start, sel, bof, onTrue, onFalse) {

    H.forEach(start, sel, function(e) {

      var b = ((typeof bof) === 'function') ? bof(e) : bof;
      var fun = b ? onTrue : onFalse; if (fun) fun(e);
    });
  };

  var reClass = function(elt, cla, dir) {

    if (cla[0] === '.') cla = cla.substring(1);
    elt.classList[dir === 'r' ? 'remove' : 'add'](cla);
  };

  var rearg_sta_sel_cla_bof = function(args) {

    var a = args[0], b = args[1], c = args[2], d = args[3];

    if (args.length < 2) throw "rearg_sta_sel_cla_bof() not enough arguments";

    if (args.length === 2) return { sta: a, sel: null, cla: b, bof: true };
    if (args.length > 3) return { sta: a, sel: b, cla: c, bof: d };

    // sta/sel/cla or sta/cla/bof ?

    if ((typeof c) === 'string' && c.match(/^\.?[^ ]+$/))
      return { sta: a, sel: b, cla: c, bof: true };

    return { sta: a, sel: null, cla: b, bof: c };
  };

  var toggle = function(start, sel, cla, bof, mod) {

    var add = function(e) { reClass(e, cla, 'a'); };
    var rem = function(e) { reClass(e, cla, 'r'); };

    var pos = add, neg = rem;
    if (mod === 'ra') { pos = rem; neg = add; }
    else if (mod === 'a') { neg = null; }
    else if (mod === 'r') { pos = rem; neg = null; }

    visit(start, sel, bof, pos, neg);
  };

  this.addClass = function(start, sel, cla, bof) {
    var as = rearg_sta_sel_cla_bof(arguments);
    toggle(as.sta, as.sel, as.cla, as.bof, 'a');
  }
  this.removeClass = function(start, sel, cla, bof) {
    var as = rearg_sta_sel_cla_bof(arguments);
    toggle(as.sta, as.sel, as.cla, as.bof, 'r');
  };

  this.toggleClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }
    var bof = function(e) { return ! self.hasClass(e, cla); };

    toggle(start, sel, cla, bof, 'ar');
  };
  this.toggle = this.toggleClass;

  this.setClass = function(start, sel, cla, bof) {
    var as = rearg_sta_sel_cla_bof(arguments);
    toggle(as.sta, as.sel, as.cla, as.bof, 'ar');
  };

  this.renameClass = function(start, sel, cla0, cla1) {

    if ( ! cla1) { cla1 = cla0; cla0 = sel; sel = start; start = null; }

    var bof = function(e) { return H.hasClass(e, cla0); };
    var fun = function(e) { H.removeClass(e, cla0); H.addClass(e, cla1); };

    visit(start, sel, bof, fun, null);
  };

  this.classArray = function(start, sel) {

    var e = H.elt(start, sel);
    var l = e.classList || e.className.split(' ');

    var a = [];
    for (var i = 0, l = e.classList.length; i < l; i++) a.push(e.classList[i]);

    return a;
  };

  var rearg_sta_sel_bof = function(args) {

    var a = args[0], b = args[1], c = args[2];

    if (args.length === 1) return { sta: a, sel: null, bof: true };
    if (args.length > 2) return { sta: a, sel: b, bof: c };

    if (args.length === 2) {
      if ((typeof b) === 'string') return { sta: a, sel: b, bof: true };
      return { sta: a, sel: null, bof: b };
    }

    throw "rearg_sta_sel_bof() called without arguments";
  };

  this.show = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.shown', as.bof, 'ar');
  };
  this.unshow = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.shown', as.bof, 'ra');
  };
  this.hide = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.hidden', as.bof, 'ar');
  };
  this.unhide = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.hidden', as.bof, 'ra');
  };

  var able = function(start, sel, bof, dir) {

    var en = function(e) { e.removeAttribute('disabled') };
    var dis = function(e) { e.setAttribute('disabled', 'disabled'); };

    visit(start, sel, bof, dir === 'e' ? en : dis, dir === 'e' ? dis : en);
  };

  this.enable = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    able(as.sta, as.sel, as.bof, 'e');
  };
  this.disable = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    able(as.sta, as.sel, as.bof, 'd');
  };

  this.cenable = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.disabled', as.bof, 'ra');
  };
  this.cdisable = function(start, sel, bof) {
    var as = rearg_sta_sel_bof(arguments);
    toggle(as.sta, as.sel, '.disabled', as.bof, 'ar');
  };

  this.isDisabled = function(start, sel) {

    var elt = toElt(start, sel);

    return (
      (elt.getAttribute('disabled') === 'disabled') ||
      H.hasClass(elt, '.disabled')
    );
  };

  this.capitalize = function(s) {

    return s.charAt(0).toUpperCase() + s.slice(1);
  };

  this.toCamelCase = function(s, cap) {

    var s = s.replace(
      /([_-][a-z])/g, function(x) { return x.substring(1).toUpperCase(); });

    return cap ? self.capitalize(s) : s;
  };

  this.prepend = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    var e = toElt(start, sel);

    e.parentNode.insertBefore(elt, e);
  };

  this.postpend = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    var e = toElt(start, sel);

    e.parentNode.insertBefore(elt, e.nextSibling);
  };

  this.remove = function(start, sel, bof) {

    var as = rearg_sta_sel_bof(arguments);

    toElts(as.sta, as.sel).forEach(function(e) {
      if ((typeof as.bof) === 'function' ? as.bof(e) : as.bof) {
        e.parentElement.removeChild(e);
      }
    });
  };

  this.clean = function(start, sel, cla) {

    var elt = toElt(start, sel);
    if (cla && cla[0] !== '.') cla = '.' + cla;

    if (cla)
      H.forEach(elt, cla, function(e) { e.parentElement.removeChild(e); });
    else
      while (elt.firstChild) elt.removeChild(elt.firstChild);

    return elt;
  };

  this.onDocumentReady = function(fev) {

    if (document.readyState != 'loading') fev();
    else document.addEventListener('DOMContentLoaded', fev);
  };

  //
  // over.

  return this;

}).apply({});


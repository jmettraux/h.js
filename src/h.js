//
// Copyright (c) 2015-2020, John Mettraux, jmettraux@gmail.com
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
// Made in Japan
//

var H = (function() {

  "use strict";

  var self = this;

  this.VERSION = '1.2.0';

  this.toArray = function(a) {

    return Array.prototype.slice.call(a);
  };

  var dashData = function(s) {

    return s.replace(/\[-([-_a-zA-Z0-9]+)(=|\])/g, '[data-$1$2');
  };

  var qs = function(start, sel, all) {

    sel = dashData(sel);

    return all ? start.querySelectorAll(sel) : start.querySelector(sel);
  };

  var toEltRefine = function(start, sel) {

    if ( ! sel) { sel = start; start = document; }

    if ( ! start) { start = document; }
    if ((typeof start) === 'string') start = qs(document, start);

    return [ start, sel ];
  };

  var toElt = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];

    if ((typeof sel) !== 'string') return sel;

    var m = sel.match(/^\^([^ ]+)(.*)$/);
    if (m) { sta = self.closest(sta, m[1]); sel = m[2].trim(); }

    if ( ! sta) return null;
    if (sel) return qs(sta, sel);
    return sta;
  };

  var toElts = function(start, sel) {

    var se = toEltRefine(start, sel); var sta = se[0], sel = se[1];

    var es = null;
    if ((typeof sel) === 'string') {
      var m = sel.match(/^\^([^ ]+)(.*)$/);
      if (m) { sta = self.closest(sta, m[1]); sel = m[2].trim(); }
      es = sel.length > 0 ? qs(sta, sel, true) : [ sta ];
    }
    else {
      es = [ sel ];
    }

    var r = []; for (var i = 0, l = es.length; i < l; i++) { r.push(es[i]); };

    return r;
  };

  this.isElement = function(o) {

    return (
      (typeof o === 'object') &&
      (typeof o.tagName === 'string') &&
      (typeof o.getElementsByClassName === 'function'));
  };
  this.isElt = this.isElement;

  this.elt = function(start, sel) { return toElt(start, sel); };
  this.elts = function(start, sel) { return toElts(start, sel); };

  this.count = function(start, sel) { return toElts(start, sel).length; };

  this.forEach = function(start, sel, fun) {

    if ((typeof sel) === 'function') { fun = sel; sel = null; }

    var r = toElts(start, sel);
    r.forEach(fun);

    return r;
  };

  this.map = function(start, sel, fun) {

    if ((typeof sel) === 'function') { fun = sel; sel = null; }

    return toElts(start, sel).map(fun);
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
      height: elt.offsetHeight, width: elt.offsetWidth };
  }

  this.dim = function(start, sel) {

    var e = toElt(start, sel); if ( ! e) return null;

    return {
      top: e.offsetTop,
      bottom: e.offsetTop + e.offsetHeight,
      left: e.offsetLeft,
      right: e.offsetLeft + e.offsetWidth,
      height: e.offsetHeight, width: e.offsetWidth };
  };

  this.bdim = function(start, sel) {

    var e = toElt(start, sel); if ( ! e) return null;

    var er = e.getBoundingClientRect();
    var br = self.elt('body').getBoundingClientRect();

    return {
      top: er.top - br.top,
      bottom: br.bottom - er.bottom,
      left: er.left - br.left,
      right: br.right - er.right,
      height: e.offsetHeight, width: e.offsetWidth };
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

    var ens = Array.isArray(eventName) ? eventName : [ eventName ];

    var es = toElts(start, sel);

    for (var i = 0; ; i++) {

      var e = es[i]; if ( ! e) break;

      ens.forEach(function(en) {
        if (dir === 'on') e.addEventListener(en, eventHandler);
        else /* off */ e.removeEventListener(en, eventHandler);
      });
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

    var t0 = performance.now();

    r.onload = function() {
      var o = {
        status: r.status,
        request: r,
        duration: (performance.now() - t0) / 1000 }; // seconds
      o.data = null; try {
        o.data = JSON.parse(r.responseText); } catch (ex) {};
      if (as.cbs.onok && r.status === 200)
        as.cbs.onok(o);
      else
        (as.cbs.onload || defaultOn('load', as.met, as.uri))(o);
    };
    r.onerror = as.cbs.onerror || defaultOn('error', as.met, as.uri);

    if (as.cbs.ontimeout || as.cbs.timeout) {
      r.timeout = as.cbs.timeout || 10 * 1000; // milliseconds
      r.ontimeout = as.cbs.ontimeout;
    }

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
      if (callbacks.clear !== false) {
        elts.forEach(function(elt) { elt.value = ''; });
      }
      onok(res);
    };

    self.request('POST', uri, fd, callbacks);

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

    sel1 = dashData(sel1);

    if (self.matches(elt, sel1)) return elt;

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
  this.hasc = this.hasClass;

  this.isHidden = function(start, sel) {

    var a = self.toArray(arguments); a.push('.hidden');

    return self.hasClass.apply(null, a);
  };

  this.isInvalid = function(start, sel) {

    return self.matches(toElt(start, sel), ':invalid');
  };

  this.isValid = function(start, sel) {

    return ! self.matches(toElt(start, sel), ':invalid');
  };

  var visit = function(start, sel, bof, onTrue, onFalse) {

    self.forEach(start, sel, function(e) {

      var b = (typeof bof === 'function') ? bof(e) : bof;
      var fun = b ? onTrue : onFalse; if (fun) fun(e);
    });
  };

  var reClass = function(elt, cla, dir) {

    if (cla[0] === '.') cla = cla.substring(1);
    elt.classList[dir === 'r' ? 'remove' : 'add'](cla);
  };

  var rearg_sta_sel_nam_las = function(args, las) {

    var a = args[0], b = args[1], c = args[2], d = args[3];

    if (args.length < 2) throw "at least 2 arguments required";

    if (args.length === 2) return { sta: a, sel: null, nam: b, las: las };
    if (args.length > 3) return { sta: a, sel: b, nam: c, las: d };

    // sta/sel/nam or sta/nam/las ?

    if ((typeof c) === 'string' && c.match(/^\.?[^ ]+$/))
      return { sta: a, sel: b, nam: c, las: las };

    return { sta: a, sel: null, nam: b, las: c };
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
    var as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'a');
  }
  this.addc = this.addClass;

  this.removeClass = function(start, sel, cla, bof) {
    var as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'r');
  };
  this.remClass = this.removeClass;
  this.remc = this.removeClass;

  this.toggleClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }
    var bof = function(e) { return ! self.hasClass(e, cla); };

    toggle(start, sel, cla, bof, 'ar');
  };
  this.toggle = this.toggleClass;
  this.togc = this.toggleClass;

  this.setClass = function(start, sel, cla, bof) {
    var as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'ar');
  };
  this.setc = this.setClass;

  this.renameClass = function(start, sel, cla0, cla1) {

    if ( ! cla1) { cla1 = cla0; cla0 = sel; sel = start; start = null; }

    var bof = function(e) { return self.hasClass(e, cla0); };
    var fun = function(e) { self.removeClass(e, cla0); self.addClass(e, cla1); };

    visit(start, sel, bof, fun, null);
  };

  this.classArray = function(start, sel) {

    var e = self.elt(start, sel);
    var l = e.classList || e.className.split(' ');

    var a = [];
    for (var i = 0, l = e.classList.length; i < l; i++) a.push(e.classList[i]);

    return a;
  };

  var rearg_sta_sel_las = function(args, las) {

    var a = args[0], b = args[1], c = args[2];

    if (args.length === 1) return { sta: a, sel: null, las: las };
    if (args.length > 2) return { sta: a, sel: b, las: c };

    if (args.length === 2) {
      if ((typeof b) === 'string') return { sta: a, sel: b, las: las };
      return { sta: a, sel: null, las: b };
    }

    throw "called without arguments";
  };

  var resol_sta_sel_las = function(args, las) {

    var as = rearg_sta_sel_las(args, las);

    as.elt = self.elt(as.sta, as.sel);
    if (as.elt) {
      as.v = ('value' in as.elt) ? as.elt.value : undefined;
      if (as.v) as.v = as.v.trim();
      as.t = as.elt.textContent.trim();
      as.tov = isVoid(as.v) ? as.t : as.v;
    }

    return as;
  };

  this.show = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.shown', as.las, 'ar');
  };
  this.unshow = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.shown', as.las, 'ra');
  };
  this.hide = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.hidden', as.las, 'ar');
  };
  this.unhide = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.hidden', as.las, 'ra');
  };

  var able = function(start, sel, bof, dir) {

    var en = function(e) { e.removeAttribute('disabled') };
    var dis = function(e) { e.setAttribute('disabled', 'disabled'); };

    visit(start, sel, bof, dir === 'e' ? en : dis, dir === 'e' ? dis : en);
  };

  this.enable = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    able(as.sta, as.sel, as.las, 'e');
  };
  this.disable = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    able(as.sta, as.sel, as.las, 'd');
  };

  this.cenable = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.disabled', as.las, 'ra');
  };
  this.cdisable = function(start, sel, bof) {
    var as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.disabled', as.las, 'ar');
  };

  this.isDisabled = function(start, sel) {

    var elt = toElt(start, sel);

    return (
      (typeof elt.getAttribute('disabled')) === 'string' ||
      self.hasClass(elt, '.disabled')
    );
  };

  this.setAtt = function(start, sel, aname, value) {

    if (arguments.length < 4) { value = aname; aname = sel; sel = null; }
    if (aname.slice(0, 1) === '-') { aname = 'data' + aname; }

    toElts(start, sel)
      .forEach(
        value === null ?
        function(e) { e.removeAttribute(aname); } :
        function(e) { e.setAttribute(aname, value); });

    return value;
  };

  this.satt = this.setAtt;

  this.remAtt = function(start, sel, aname) {

    var as = rearg_sta_sel_nam_las(arguments, undefined);
    if (as.nam.slice(0, 1) === '-') as.nam = 'data' + as.nam;

    toElts(as.sta, as.sel).forEach(function(e) { e.removeAttribute(as.nam); });
  };

  this.ratt = this.remAtt;

  this.getAtt = function(start, sel, aname/*, default*/) {

    var as = rearg_sta_sel_nam_las(arguments, undefined);

    var r = /(.*\[([-_a-zA-Z0-9]+)\].*)+/;
    var ms = as.sel && as.sel.match(r);
    var mn = as.nam && as.nam.match(r);

    if ( ! as.sel && as.nam && mn) {
      as.sel = as.nam; as.nam = mn[mn.length - 1];
    }
    else if (ms) {
      as.las = as.nam; as.nam = ms[ms.length - 1];
    }

    var e = self.elt(as.sta, as.sel);
    //if ( ! e) throw "elt not found, cannot read attributes";
    if ( ! e) return as.las;

    if (as.nam && as.nam.substr(0, 1) === '-') as.nam = 'data' + as.nam;

    var av = e.getAttribute(as.nam)
    return av === null ? as.las : av;
  };

  this.getAtti = function(start, sel, aname/*, default*/) {
    var v = self.getAtt.apply(null, arguments);
    v = parseInt('' + v, 10);
    return isFalsy(v) ? null : v;
  };

  this.getAttf = function(start, sel, aname/*, default*/) {
    var v = self.getAtt.apply(null, arguments);
    v = parseFloat('' + v);
    return isFalsy(v) ? null : v;
  };

  this.att = this.getAtt;
  this.atti = this.getAtti;
  this.attf = this.getAttf;

  var FALSIES = [ false, null, undefined, NaN, '' ];
  var isFalsy = function(v) { return FALSIES.indexOf(v) > -1; }

  this.text = function(start, sel/*, default*/) {
    var as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    var t = as.elt.textContent.trim();
    return (t === '' && as.las) ? as.las : t;
  };

  this.texti = function(start, sel/*, default*/) {
    var as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    var t = as.elt.textContent.trim(); if (t === '') t = '' + as.las;
    return parseInt(t, 10);
  };

  this.textf = function(start, sel/*, default*/) {
    var as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    var t = as.elt.textContent.trim(); if (t === '') t = '' + as.las;
    return parseFloat(t);
  };

  this.get = function(start, sel/*, false */) {

    var a = self.toArray(arguments);
    var l = true; if (typeof a[a.length - 1] === 'boolean') l = a.pop();
    var e = self.elt.apply(null, a);
    var v = e ? e.value : null; v = v ? v.trim() : '';
    return l === false && v.length === 0 ? null : v;
  };

  var isTrue = function(o) {
    if (typeof o === 'string') o = o.toLowerCase();
    return o === true || o === 'true' || o === 'yes';
  };
  this.isTrue = isTrue;

  var isVoid = function(o) { return o === null || o === undefined; };
  this.isVoid = isVoid;

  this.getb = function(start, sel/*, default */) {

    var a = self.toArray(arguments);
    var d = null; if (typeof a[a.length - 1] === 'boolean') d = a.pop();
    var v = self.get.apply(null, a).toLowerCase();
    if (d !== null && v === '') return d;
    return isTrue(v);
  };

  this.getf = function(start, sel/*, default */) {

    var a = self.toArray(arguments);
    var l = a[a.length - 1];
    var d = null;
    if (typeof l === 'number') d = a.pop();
    if (d !== null) a.push(false);
    var v = self.get.apply(null, a);
    if (v === null) { if (l === false) return v; if (d) return d; v = '0.0' }
    return parseFloat(v);
  };

  this.geti = function(start, sel/*, default */) {

    var a = self.toArray(arguments);
    var l = a[a.length - 1];
    var d = null;
    if (typeof l === 'number') d = a.pop();
    if (d !== null) a.push(false);
    var v = self.get.apply(null, a);
    if (v === null) { if (l === false) return v; v = d ? '' + d : '0' }
    return parseInt(v, 10);
  };

  this.getj = function(start, sel/*, default */) {

    var d = undefined;
    var a = self.toArray(arguments);
    var l = a[a.length - 1];
    if (a.length > 2) { d = a[2]; }
    else if (a.length > 1 && (typeof l) !== 'string') { d = a.pop(); }
    var v = self.get.apply(null, a);
    try { return JSON.parse(v); } catch(e) { return d; }
  };

  this.set = function(start, sel, value) {

    var a = self.toArray(arguments);
    var v = a.pop(); v = (v === null || v === undefined) ? '' : '' + v;

    var e = self.elt.apply(null, a);
    if (e) e.value = v;

    return v;
  };

  this.setText = function(start, sel, text) {

    var a = self.toArray(arguments);
    var t = a.pop();
    var e = self.elt.apply(null, a)
    if (e) e.textContent = t;

    return t;
  };

  this.textOrValue = function(start, sel/*, default */) {
    var as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text or value";
    return (as.tov === '' && (typeof as.las === 'string')) ? as.las : as.tov;
  };
  this.tov = this.textOrValue;

  this.tovb = function(start, sel/*, default */) {
    var as = resol_sta_sel_las(arguments);
    if (as.elt) return isTrue(as.tov || '' + as.las);
    throw "elt not found, no text or value";
  };
  this.tovi = function(start, sel/*, default */) {
    var as = resol_sta_sel_las(arguments);
    if (as.elt) return parseInt(as.tov || '' + as.las, 10);
    throw "elt not found, no text or value";
  };
  this.tovf = function(start, sel/*, default */) {
    var as = resol_sta_sel_las(arguments);
    if (as.elt) return parseFloat(as.tov || '' + as.las);
    throw "elt not found, no text or value";
  };

  this.capitalize = function(s) {

    return s.charAt(0).toUpperCase() + s.slice(1);
  };

  this.decapitalize = function(s) {

    return s.charAt(0).toLowerCase() + s.slice(1);
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

    var as = rearg_sta_sel_las(arguments, true);

    toElts(as.sta, as.sel).forEach(function(e) {
      if ((typeof as.las === 'function') ? as.las(e) : as.las) {
        e.parentElement.removeChild(e);
      }
    });
  };
  this.rem = this.remove;
  this.del = this.remove;

  this.replace = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    var e = toElt(start, sel);
    var p = e.parentNode;

    p.insertBefore(elt, e);
    p.removeChild(e);
  };
  this.rep = this.replace;

  this.clean = function(start, sel, cla) {

    var elt = toElt(start, sel);
    if (cla && cla[0] !== '.') cla = '.' + cla;

    if (cla)
      self.forEach(elt, cla, function(e) { e.parentElement.removeChild(e); });
    else
      while (elt.firstChild) elt.removeChild(elt.firstChild);

    return elt;
  };

  this.onDocumentReady = function(fev) {

    if (document.readyState != 'loading') fev();
    else document.addEventListener('DOMContentLoaded', fev);
  };

  this.makeGrower = function(name) {
    var scan = function(s) {
      var m, r = [];
      s.replace(/([#.][^#.]+)/g, function(x) {
        r.push({ k: x[0], n: x.substring(1, x.length) });
      });
      return r;
    };
    return function() {
      var e = document.createElement(name);
      for (var i = 0, l = arguments.length; i < l; i++) {
        var a = arguments[i];
        if (a === false) return null; // skip this subtree
        if (a === null) continue; // ignore null (skipped) children
        var s = (typeof a === 'string');
        if (s && (a[0] === '.' || a[0] === '#') && ! a.match(/^\s*$/)) {
          scan(a).forEach(function(x) {
            if (x.k === '#') e.id = x.n; else e.classList.add(x.n);
          });
        } else if (s) {
          e.appendChild(document.createTextNode(a));
        } else if (a.nodeType !== undefined && a.innerHTML !== undefined) {
          e.appendChild(a);
        } else if (typeof a === 'object') {
          for (var k in a) {
            e.setAttribute(k.slice(0, 1) === '-' ? 'data' + k : k, a[k]); };
        } else {
          e.appendChild(document.createTextNode('' + a));
        }
      }
      return e;
    };
  };

  this.create = function(/* parent, */tagname/*, rest */) {

    var par = null; var off = 1;
    if (typeof tagname === 'object' && tagname.tagName) {
      off = 2; par = tagname; tagname = arguments[1];
    }

    var as = Array.prototype.slice.call(arguments, off);

    var m = tagname.match(/^([a-zA-Z0-9]+)?([.#].+)$/)
    if (m) { tagname = m[1] || 'div'; as.unshift(m[2]); }

    var elt = self.makeGrower(tagname).apply(null, as);

    if (par) par.appendChild(elt);

    return elt;
  };

  var growers =
    'var ' +
    'a abbr address area article aside audio b base bdi bdo blockquote br button canvas caption cite code col colgroup datalist dd del details dfn dialog div dl dt em embed fieldset figcaption figure footer form h1 h2 h3 h4 h5 h6 header hr i iframe img input ins kbd keygen label legend li main map mark menu menuitem meta meter nav noscript object ol optgroup option output p param picture pre progress q rp rt ruby s samp script section select small source span strong style sub summary sup table tbody td textarea tfoot th thead time title tr track u ul video wbr'
      .split(' ')
      .map(function(t) { return t + '=H.makeGrower("' + t + '")' })
      .join(',') +
    ';';

  this.grow = function(fun) {

    var f = fun.toString().trim();
    f = f.substring(f.indexOf('{') + 1, f.lastIndexOf('}'));

    return eval(growers + f);
  };

  this.makeTemplate = function(fun) {

    return eval('(' + fun.toString().replace(/\{/, '{' + growers) + ')');
  };

  this.delay = function(ms, fun) {

    var t = null;

    return function() {
      var as = arguments;
      window.clearTimeout(t);
      t = window.setTimeout(function() { fun.apply(this, as) }, ms);
    };
  };

  this.makeWorker = function(workerFunction/*, wrap=true*/) {

    var s = workerFunction.toString();
    var w = arguments[1]; w = (w === undefined) || ( !! w);
    if (w) s = "self.addEventListener('message', " + s + ", false);";
    else s = s.substring(s.indexOf('{') + 1, s.lastIndexOf('}'));

    var r = document && document.location && document.location.href;
    if (r) {
      var j = r.lastIndexOf('/'); if (j < 0) j = r.length - 1;
      r = r.substring(0, j) + '/';
      s = "var rootUrl = \"" + r + "\";" + s;
    }

    var b = new Blob([ s ]);

    var w = new Worker(window.URL.createObjectURL(b));
    w.on = function(t, cb) { w.addEventListener(t, cb, false); };

    return w;
  };

  //
  // done.

  return this;

}).apply({}); // end H


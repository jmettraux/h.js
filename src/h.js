
var H = (function() {

  "use strict";

  let self = this;

  this.VERSION = '1.2.0';

  this.toArray = function(a) {

    return Array.prototype.slice.call(a);
  };

  let dashData = function(s) {

    return s.replace(/\[-([-_a-zA-Z0-9]+)(=|\])/g, '[data-$1$2');
  };

  let aconcat = function(a, a1) { a1.forEach(function(e) { a.push(e); }); };

  let qs = function(start, sel, limit) {

    if (start === null && sel === null) return [];

    start = start || document;

    if ((typeof sel) !== 'string') return [ start ];

    sel = dashData(sel);

    if (sel.substr(0, 1) === '^') {
      let m = sel.match(/^\^([^\s]+)(.*)$/);
      start = start.closest(m[1]); sel = m[2];
    }

    if (sel.trim() === '') return [ start ];
    if (limit) return [ start.querySelector(sel) ];
    return start.querySelectorAll(sel);
  };

  let resolveSels = function(sel, limit) {

    if (sel === undefined || sel === null) return [ null ];
    return Array.isArray(sel) ? sel : [ sel ];
  };

  let resolveStarts = function(start, limit) {

    let r = [];
      (Array.isArray(start) ? start : [ start ])
        .forEach(function(e) {
          if ((typeof e) === 'string') aconcat(r, qs(document, e, limit));
          else if (H.isEv(e)) r.push(e.target);
          else r.push(e);
        });

    return r;
  };

  let toElts = function(start, sel, limit) {

      // lets function pass their arguments pseudo-array directly to h.js
      //
    if (self.isArgs(start)) {
      let a = Array.from(start);
      start = a[0]; sel = a[1]; limit = a[2];
    }

    let starts = resolveStarts(start, limit);
    let sels = resolveSels(sel, limit);

    let r = [];
      starts.forEach(function(start) {
        sels.forEach(function(sel) {
          if (limit && r.length >= limit) return;
          if (self.isElt(sel)) r.push(sel);
          else if (self.isEvent(sel)) r.push(sel.target);
          else aconcat(r, qs(start, sel, limit));
        });
      });

    return r;
  };

  let toEltv = function(start, sel) { return toElts(start, sel).values(); };

  let toElt = function(start, sel) { return toElts(start, sel, 1)[0]; };

  this.isElement = function(o) {

    return (
      (o !== null) &&
      (typeof o === 'object') &&
      (typeof o.tagName === 'string') &&
      (typeof o.getElementsByClassName === 'function'));
  };
  this.isElt = this.isElement;

  this.isString = function(x) { return (typeof x === 'string'); };
  this.isStr = this.isString;
  this.isS = this.isString;

  this.isHash = function(o) {

    if (typeof o !== 'object') return false;
    if (o === null || Array.isArray(o)) return false;

    return true;
  };
  this.isH = this.isHash;

  this.isArguments = function(o) {

    return(
      self.isH(o) &&
      Object.prototype.hasOwnProperty.call(o, 'callee') &&
      ! Object.prototype.propertyIsEnumerable.call(o, 'callee'));
  };
  this.isArgs = this.isArguments;

  //this.isEvent = function(o) {
  //  let c = o.constructor;
  //  return(
  //    H.isElt(o.target) &&
  //    H.isS(o.type) &&
  //    c && c.toString().match(/Event\(\)/))
  //};
  this.isEvent = function(o) {

    return self.isH(o) && self.isElt(o.target);
  };
  this.isEv = this.isEvent;

  this.elt = toElt;
  this.elts = toElts;
  this.eltv = toEltv;
  this.e = toElt;
  this.es = toElts;
  this.ev = toEltv;

  this.last = function(start, sel) {

    let es = toElts(start, sel);

    return es[es.length - 1];
  };

  this.count = function(start, sel) { return toElts(start, sel).length; };

  this.click = function(start, sel) { toElt(start, sel).click(); };
  this.k = this.click;

  // Warning: there is a H.each(array_or_hash, fun) below...
  //
  this.forEach = function(start, sel, fun, thisArg) {

    if ((typeof sel) === 'function') { thisArg = fun; fun = sel; sel = null; }

    let r = toElts(start, sel);
    r.forEach(fun, thisArg);

    return r;
  };

  this.map = function(start, sel, fun, thisArg) {

    if ((typeof sel) === 'function') { thisArg = fun; fun = sel; sel = null; }

    return toElts(start, sel).map(fun, thisArg);
  };

  this.filter = function(start, sel, fun) {

    if ((typeof sel) === 'function') { fun = sel; sel = null; }

    return toElts(start, sel).filter(fun);
  };

  this.find = function(start, sel, fun) {

    if ((typeof sel) === 'function') { fun = sel; sel = null; }

    return toElts(start, sel).find(fun);
  };

  this.reduce = function(start, sel, fun, initial) {

    if ((typeof sel) === 'function') { initial = fun; fun = sel; sel = null; }

    return toElts(start, sel).reduce(fun, initial);
  };

  this.tdim = function(start, sel) {

    let elt = toElt(start, sel); if ( ! elt) return null;

    let left = 0; let top = 0;
    let e = elt;

    while (e) {
      left += e.offsetLeft; top += e.offsetTop;
      e = e.offsetParent;
    }

    return {
      top: top, bottom: top + elt.offsetHeight,
      left: left, right: left + elt.offsetWidth,
      height: elt.offsetHeight, width: elt.offsetWidth };
  }

  this.width = function(start, sel) {

    let e = toElt(start, sel); return e ? e.offsetWidth : null;
  }
  this.height = function(start, sel) {

    let e = toElt(start, sel); return e ? e.offsetHeight : null;
  }
  this.w = this.width;
  this.h = this.height;

  this.dim = function(start, sel) {

    let e = toElt(start, sel); if ( ! e) return null;

    return {
      top: e.offsetTop,
      bottom: e.offsetTop + e.offsetHeight,
      left: e.offsetLeft,
      right: e.offsetLeft + e.offsetWidth,
      height: e.offsetHeight, width: e.offsetWidth };
  };

  this.bdim = function(start, sel) {

    let e = toElt(start, sel); if ( ! e) return null;

    let er = e.getBoundingClientRect();
    let br = self.elt('body').getBoundingClientRect();

    return {
      top: er.top - br.top,
      bottom: br.bottom - er.bottom,
      left: er.left - br.left,
      right: br.right - er.right,
      height: e.offsetHeight, width: e.offsetWidth };
  };

  this.path = function(start, sel) {

    let e = toElt(start, sel);
    if ( ! e) return null;

    if (e.id) return '#' + e.id;

    let pp = self.path(e.parentElement);

    //let nn = e.nodeName.toLowerCase();
    //let cs = self.classArray(e); cs = cs.length > 0 ? '.' + cs.join('.') : '';
    //let an = e.getAttribute('name'); an = an ? '[name="' + an + '"]' : '';
    //  //
    //if (cs !== '' || an !== '') return pp + ' > ' + nn + cs + an;
      //
      // No, it may be ambiguous, remember table.data ( .section-star )

    //var sb = e; let n = 0;
    //while (
    //  sb.nodeType === Node.ELEMENT_NODE && (sb = sb.previousSibling)) n++;

    let sb = e; let n = 0;
    while (sb) {
      if (sb.nodeType === 1) n++;
      sb = sb.previousSibling;
    }

    return pp + ' > ' + ':nth-child(' + n + ')';
  };

  this.eltTagSignature = function(sta, sel) {

    let e = self.elt(sta, sel);

    let s = '<' + e.tagName;
    for (let i = 0, l = e.attributes.length; i < l; i++) {
      let a = e.attributes[i];
      s = s + ' ' + a.name + '=' + JSON.stringify(a.value);
    }

    return s + '>';
  };

  this.eltSignature = function(sta, sel) {

    let e = self.elt(sta, sel);

    let t = e.tagName.toLowerCase();
    if (t === 'body') return t;

    let c = Array.from(e.classList)
      .map(function(c) { return '.' + c; })
      .join('');

    let i = e.id; if (i) i = '#' + i;

    if (t === 'div' && (c || i)) t = '';
    if (i) c = '';

    return t + i + c;
  };

  let eltPath = function(s, e) {

    if ( ! e) return undefined;
    if ( ! e.parentElement) return s.trim();

    let s0 = self.eltSignature(e);
    s = s ? s0 + ' > ' + s : s0;

    if (s.slice(0, 1) === '#') return s;

    return eltPath(s, e.parentElement);
  };

  this.eltPath = function(sta, sel) {

    return eltPath('', self.elt(sta, sel));
  }

  // ensure that the eventHandler is called only if the event
  // directly targets the element to which it is bound
  //
  // used by
  //
  //   H.on(start, sel, 'click!', function(ev) {});
  //
  let restrictEventHandler = function(eh) {

    return function(ev) { if (this === ev.target) eh(ev); };
  }

  let onOrOff = function(dir, start, sel, eventName, eventHandler) {

    if ( ! eventHandler) {
      eventHandler = eventName; eventName = sel; sel = start; start = document;
    }

    if (typeof eventHandler !== 'function') throw "eventHandler is missing";

    let ens =
      (Array.isArray(eventName) ? eventName : eventName.split(/[,\/ ]+/))
        .map(function(e) { return e.trim(); });

    let es = toElts(start, sel);

    for (let i = 0; ; i++) {

      let e = es[i]; if ( ! e) break;

      ens.forEach(function(en) {

        let m = en.match(/^(.+)\.$/);
        if (m) { en = m[1]; eventHandler = restrictEventHandler(eventHandler); }

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

  this.onClick = function(start, sel, eventHandler) {
    let as = Array.from(arguments);
    as.splice(as.length - 1, 0, 'click'); as.unshift('on');
    onOrOff.apply(null, as);
  };
  this.onc = this.onClick;

  this.onChange = function(start, sel, eventHandler) {
    let as = Array.from(arguments);
    as.splice(as.length - 1, 0, 'change'); as.unshift('on');
    onOrOff.apply(null, as);
  };
  this.onh = this.onChange;

  let onKey = function(dir, as) {
    as = Array.from(as); as.splice(as.length - 1, 0, dir); as.unshift('on');
    onOrOff.apply(null, as); };
      //
  this.onKeydown = function(start, sel, eventHandler) {
    onKey('keydown', arguments); };
  this.onKeyup = function(start, sel, eventHandler) {
    onKey('keyup', arguments); };
      //
  this.onkd = this.onKeydown;
  this.onk = this.onKeyup;

  this.onKeyOrChange = function(start, sel, eventHandler) {
    let as = Array.from(arguments);
    as.splice(as.length - 1, 0, [ 'keyup', 'change' ]); as.unshift('on');
    onOrOff.apply(null, as);
  };
  this.onkc = this.onKeyOrChange;
  this.onkh = this.onKeyOrChange;


  let indexNext = function(sel) {

    let d = sel.indexOf('.'); let s = sel.indexOf('#');
    if (d < 0) return s; if (s < 0) return d;
    return d < s ? d : s;
  };

  this.toNode = function(html, sel) {

    if ((typeof html) !== 'string') return sel ? self.elt(html, sel) : html;

    let e = document.createElement('div');
    e.innerHTML = html; // :-(
    e = e.children[0];

    return sel ? self.elt(e, sel) : e;
  };

  let defaultOn = function(type, method, uri) {

    return function(res) {
      if (type === 'load') console.log([ method + ' ' + uri, res ]);
      else console.log([ method + ' ' + uri + ' connection problem', res ]);
    }
  };

  let isHeaders = function(o) {

    if ((typeof o) !== 'object') return false;
    for (let k in o) {
      if ((typeof o[k]) !== 'string') return false;
      if ( ! k.match(/^[A-Z][A-Za-z0-9-]+$/)) return false;
    }
    return true;
  };

  let splitResponseHeaders = function(req) {

    let tok = function(s) { return s.toLowerCase().replaceAll(/-/g, '_'); };

    return req.getAllResponseHeaders()
      .split(/\r\n/)
      .reduce(
        function(h, l) {
          if (l.indexOf(':') > 0) {
            let x = l.split(/:\s*/);
            h[tok(x[0])] = x[1]; }
          return h; },
        {});
  };

  this.request = function(method, uri, headers, data, callbacks) {

    // shuffle args

    let as = { met: method, uri: uri };
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

    let r = new XMLHttpRequest();
    r.open(as.met, as.uri, true);

    for (let k in as.hds) r.setRequestHeader(k, as.hds[k]);

    if (as.dat) {

      let con = as.dat.constructor.toString();
      let typ = typeof as.dat;
      let cot = as.hds['Content-Type'] || '/json';

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

    let t0 = performance.now();

    r.onload = function() {
      let o = {
        status: r.status,
        request: r,
        duration: (performance.now() - t0) / 1000, // seconds
        headers: splitResponseHeaders(r) };
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
    if ( ! data) data = {};

    let fd = new FormData();

    for (let k in data) {

      let v = data[k]; v =
        ((typeof v === 'string') || (v instanceof Blob)) ? v :
        (v === undefined) ? 'null' :
        JSON.stringify(v);

      fd.append(k, v);
    }

    let isMulti = Array.isArray(inputFileElt_s);
    let elts = isMulti ? inputFileElt_s : [ inputFileElt_s ];

    let fcount = 0;

    elts.forEach(function(elt) {

      let files = elt.files;

      for (let i = 0, l = files.length; i < l; i++) {

        fcount = fcount + 1;

        let f = files[i];

        let l = null;
        for (let j = 0, al = elt.attributes.length; j < al; j++) {
          let a = elt.attributes.item(j);
          if (a.name.match(/^data-(.*-)?lang$/)) { l = a.value; break; }
        }

        let k = 'file-';
        if (l || isMulti) k = k + elt.name + '-';
        if (l) k = k + l + '-';
        k = k + i;

        fd.append(k, f, f.name);
      }
    });

    //if (fcount < 1) return 0;
      // allow no posting any file, just data...

    let onok = callbacks.onok;
    callbacks.onok = function(res) {
      if (callbacks.clear !== false) {
        elts.forEach(function(elt) { elt.value = ''; });
      }
      onok(res); };

    self.request(data._method || 'POST', uri, fd, callbacks);

    return fcount;
  };

  this.matches = function(start, sel, pat) {

    if ( ! pat) { pat = sel; sel = start; start = null; }

    let elt = toElt(start, sel);
    if ( ! elt) throw "H.matches() couldn't locate elt pre-matching";

    let pat1 = dashData(pat);

    if (elt.matches) return elt.matches(pat1);
    if (elt.matchesSelector) return elt.matchesSelector(pat1);
    if (elt.msMatchesSelector) return elt.msMatchesSelector(pat1);

    throw "H.js elt doesn't respond to .matches() or .matchesSelector()";
  };

  this.closest = function(start, sel, sel1) {

    if ( ! sel1) { sel1 = sel; sel = start; start = null; }
    let elt = toElt(start, sel);

    sel1 = dashData(sel1);

    if (self.matches(elt, sel1)) return elt;

    return elt.parentElement ? self.closest(elt.parentElement, sel1) : null;
  };

  this.children = function(start, sel, sel1) {

    if ( ! sel1) { sel1 = sel; sel = start; start = null; }
    let elt = toElt(start, sel);

    return Array.from(elt.children)
      .filter(function(e) { return e.matches(sel1); });
  };

  this.child = function(start, sel, sel1) {

    if ( ! sel1) { sel1 = sel; sel = start; start = null; }
    let elt = toElt(start, sel);

    return Array.from(elt.children)
      .find(function(e) { return e.matches(sel1); });
  };

  // adapted from http://upshots.org/javascript/jquery-copy-style-copycss
  //
  this.style = function(start, sel/*, opts */) {

    let elt = toElt(start, sel);

    let opts = Array.from(arguments).reverse()[0];
    opts = this.isHash(opts) ? opts : {};

    let r = {};
    let style = null;

    let f = function(h) {
      let keys = opts.filter; if ( ! keys) return h;
      keys =
        (typeof keys === 'string') ?
          keys.split(',').map(function(e) { return e.trim(); }) :
        keys;
      return Object.keys(h)
        .reduce(
          function(hh, k) { if (keys.includes(k)) hh[k] = h[k]; return hh; },
          {}); };

    if (window.getComputedStyle) {

      style = window.getComputedStyle(elt, null);

      for (let i = 0, l = style.length; i < l; i++) {
        let p = style[i];
        let n = p.replace(
          /-([a-za])/g, function(a, b) { return b.toUpperCase(); })
        r[n] = style.getPropertyValue(p);
      }

      return f(r);
    }

    if (style = elt.currentStyle) {

      for (let p in style) r[p] = style[p];
      return f(r);
    }

    if (style = elt.style) {

      for (let p in style) {
        let s = style[p];
        if ((typeof s) !== 'function') r[p] = s;
      }
      //return f(r);
    }

    return f(r);
  };
  this.styles = this.style;

  this.hasClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }

    let elt = toElt(start, sel);
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

    let a = self.toArray(arguments); a.push('.hidden');

    return self.hasClass.apply(null, a);
  };
  this.hidden = this.isHidden;

  this.isHiddenUp = function(start, sel) {

    return !! self.elt(toElt(start, sel), '^.hidden');
  };
  this.hiddenUp = this.isHiddenUp;

  let notDisplayed = function(e) {
    if ( ! e) return false;
    //if (e.style && e.style.display === 'none') return true;
    if (window.getComputedStyle(e).display === 'none') return true;
    return notDisplayed(e.parentElement);
  };
    //
  this.isNotDisplayed = function(start, sel) {

    return notDisplayed(self.elt(toElt(start, sel)));
  };
  this.notDisplayed = this.isNotDisplayed;

  this.isVisible = function(start, sel) {

    let e = toElt(start, sel);

    if (e.offsetParent === null) return false;

    let r = e.getBoundingClientRect();

    if (
      r.width === 0 || r.height === 0
    ) return false;
    if (
      r.bottom < 0 || r.right < 0 ||
      r.left > window.innerWidth || r.top > window.innerHeight
    ) return false;

    let s = window.getComputedStyle(e);
    if (s.visibility === 'hidden' || s.opacity == '0') return false;

    return true;
  };

  this.isInvalid = function(start, sel) {

    return self.matches(toElt(start, sel), ':invalid');
  };

  this.isValid = function(start, sel) {

    return ! self.matches(toElt(start, sel), ':invalid');
  };

  let visit = function(start, sel, bof, onTrue, onFalse) {

    self.forEach(start, sel, function(e) {

      let b = (typeof bof === 'function') ? bof(e) : bof;
      let fun = b ? onTrue : onFalse; if (fun) fun(e);
    });
  };

  let reClass = function(elt, cla, dir) {

    (Array.isArray(cla) ? cla : cla.split(/[ .]+/))
      .forEach(function(c) {
        c = c.replace('.', '');
        if (c.length < 1) return;
        elt.classList[dir === 'r' ? 'remove' : 'add'](c); });
  };

  let rearg_sta_sel_nam_las = function(args, las) {

    let a = args[0], b = args[1], c = args[2], d = args[3];

    if (args.length < 2) throw "at least 2 arguments required";

    if (args.length === 2) return { sta: a, sel: null, nam: b, las: las };
    if (args.length > 3) return { sta: a, sel: b, nam: c, las: d };

    // sta/sel/nam or sta/nam/las ?

    if ((typeof c) === 'string' && c.match(/^\.?[^ ]+$/))
      return { sta: a, sel: b, nam: c, las: las };

    return { sta: a, sel: null, nam: b, las: c };
  };

  let toggle = function(start, sel, cla, bof, mod) {

    let add = function(e) { reClass(e, cla, 'a'); };
    let rem = function(e) { reClass(e, cla, 'r'); };

    let pos = add, neg = rem;
    if (mod === 'ra') { pos = rem; neg = add; }
    else if (mod === 'a') { neg = null; }
    else if (mod === 'r') { pos = rem; neg = null; }

    visit(start, sel, bof, pos, neg);
  };

  this.addClass = function(start, sel, cla, bof) {
    let as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'a');
  }
  this.addc = this.addClass;

  this.removeClass = function(start, sel, cla, bof) {
    let as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'r');
  };
  this.remClass = this.removeClass;
  this.remc = this.removeClass;

  this.toggleClass = function(start, sel, cla) {

    if ( ! cla) { cla = sel; sel = start; start = null; }
    let bof = function(e) { return ! self.hasClass(e, cla); };

    toggle(start, sel, cla, bof, 'ar');
  };
  this.toggle = this.toggleClass;
  this.togc = this.toggleClass;

  this.toggleHidden = function(start, sel) {

    let a = Array.from(arguments); a.push('.hidden');

    self.toggleClass.apply(null, a);
  };
  this.togh = this.toggleHidden;

  this.setClass = function(start, sel, cla, bof) {
    let as = rearg_sta_sel_nam_las(arguments, true);
    toggle(as.sta, as.sel, as.nam, as.las, 'ar');
  };
  this.setc = this.setClass;
  this.flipc = this.setClass;

  this.renameClass = function(start, sel, cla0, cla1) {

    if ( ! cla1) { cla1 = cla0; cla0 = sel; sel = start; start = null; }

    let bof = function(e) { return self.hasClass(e, cla0); };
    let fun = function(e) { self.removeClass(e, cla0); self.addClass(e, cla1); };

    visit(start, sel, bof, fun, null);
  };

  this.classArray = function(start, sel) {

    let e = self.elt(start, sel);
    let cs = e.classList || e.className.split(' ');

    let a = []; for (let i = 0, l = cs.length; i < l; i++) a.push(cs[i]);

    return a;
  };

  this.classFrom = function(/*start, sel, classNames*/) {

    let as = Array.from(arguments);

    let ns = as.pop()
      .filter(function(e) {
        return H.isS(e) || (e instanceof RegExp); })
      .map(function(e) {
        return (H.isS(e) && e.substr(0, 1) === '.') ? e.slice(1) : e; });

    if (H.isVacuous(as)) throw "H.classFrom() start/sel point to nothing";

    let e = self.elt.apply(null, as);
    let cs = e.classList || e.className.split(' ');

    for (let i = 0, l = cs.length; i < l; i++) { let c = cs[i];
      for (let j = 0, jl = ns.length; j < jl; j++) { let n = ns[j];
        if (c === n) return c;
        if (n instanceof RegExp && c.match(n)) return c;
      }
    }

    return undefined;
  };

  this.classNot = function(/*start, sel, classNames*/) {

    let as = Array.from(arguments);

    let ns = as.pop()
      .filter(function(e) {
        return H.isS(e) || (e instanceof RegExp); })
      .map(function(e) {
        return (H.isS(e) && e.substr(0, 1) === '.') ? e.slice(1) : e; });

    if (H.isVacuous(as)) throw "H.classNot() start/sel point to nothing";

    let e = self.elt.apply(null, as);
    let cs = e.classList || e.className.split(' ');

    for (let i = 0, l = cs.length; i < l; i++) { let c = cs[i];

      let match = false;

      for (let j = 0, jl = ns.length; j < jl; j++) { let n = ns[j];
        if (match) continue;
        if ((c === n) || (n instanceof RegExp && c.match(n))) match = true;
      }

      if ( ! match) return c;
    }

    return undefined;
  };

  let rearg_sta_sel_las = function(args, las) {

    let a = args[0], b = args[1], c = args[2];

    if (Number.isInteger(b) && b > -1 && Array.isArray(c)) {
      return { sta: a, sel: null, las: las }; }
        // to enable things like [ elt0, elt1 ].forEach(H.hide);  :-)

    if (args.length === 1) {
      return { sta: a, sel: null, las: las }; }
    if (args.length > 2) {
      return { sta: a, sel: b, las: c }; }

    if (args.length === 2) {
      if ((typeof b) === 'string') return { sta: a, sel: b, las: las };
      return { sta: a, sel: null, las: b };
    }

    throw "called without arguments";
  };

  let resol_sta_sel_las = function(args, las) {

    let as = rearg_sta_sel_las(args, las);

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
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.shown', as.las, 'ar');
  };
  this.unshow = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.shown', as.las, 'ra');
  };
  this.hide = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.hidden', as.las, 'ar');
  };
  this.unhide = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.hidden', as.las, 'ra');
  };

  let able = function(start, sel, bof, dir) {

    let en = function(e) { e.removeAttribute('disabled') };
    let dis = function(e) { e.setAttribute('disabled', 'disabled'); };

    visit(start, sel, bof, dir === 'e' ? en : dis, dir === 'e' ? dis : en);
  };

  this.enable = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    able(as.sta, as.sel, as.las, 'e');
  };
  this.disable = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    able(as.sta, as.sel, as.las, 'd');
  };

  this.cenable = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.disabled', as.las, 'ra');
  };
  this.cdisable = function(start, sel, bof) {
    let as = rearg_sta_sel_las(arguments, true);
    toggle(as.sta, as.sel, '.disabled', as.las, 'ar');
  };

  this.isDisabled = function(start, sel) {

    let elt = toElt(start, sel);

    return (
      (typeof elt.getAttribute('disabled')) === 'string' ||
      self.hasClass(elt, '.disabled')
    );
  };
  this.disabled = this.isDisabled;
  this.dised = this.isDisabled;

  this.isClassDisabled = function(start, sel) {

    return self.hasClass(H.e(start, sel), '.disabled');
  };
  this.cDisabled = this.isClassDisabled;
  this.cdisabled = this.isClassDisabled;

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

  this.setAtts = function(start, sel, attributes) {

    if (arguments.length < 3) { attributes = sel; sel = null; }

    Object.keys(attributes).forEach(function(k) {
      self.setAtt(start, sel, k, attributes[k]);
    });

    return attributes;
  };

  this.remAtt = function(start, sel, aname) {

    let as = rearg_sta_sel_nam_las(arguments, undefined);
    if (as.nam.slice(0, 1) === '-') as.nam = 'data' + as.nam;

    toElts(as.sta, as.sel).forEach(function(e) { e.removeAttribute(as.nam); });
  };

  this.ratt = this.remAtt;

  this.getAtt = function(start, sel, aname/*, default*/) {

    let as = rearg_sta_sel_nam_las(arguments, undefined);

    let r = /(.*\[([-_a-zA-Z0-9]+)\].*)+/;
    let ms = as.sel && as.sel.match(r);
    let mn = as.nam && as.nam.match(r);

    if ( ! as.sel && as.nam && mn) {
      as.sel = as.nam; as.nam = mn[mn.length - 1];
    }
    else if (ms) {
      as.las = as.nam; as.nam = ms[ms.length - 1];
    }

    let e = self.elt(as.sta, as.sel);

    //if ( ! e) throw "elt not found, cannot read attributes";
    if ( ! e) return as.las;

    if (as.nam && as.nam.substr(0, 1) === '-') as.nam = 'data' + as.nam;

    let l = as.las;
    if ((typeof l === 'string') && l.substr(0, 1) === '-') l = 'data' + l;

    let av = e.getAttribute((ms && e.hasAttribute(l)) ? l : as.nam);

    return av === null ? as.las : av;
  };

  this.getAtti = function(start, sel, aname/*, default*/) {
    let v = self.getAtt.apply(null, arguments);
    v = parseInt('' + v, 10);
    return isFalsy(v) ? null : v;
  };

  this.getAttf = function(start, sel, aname/*, default*/) {
    let v = self.getAtt.apply(null, arguments);
    v = parseFloat('' + v);
    return isFalsy(v) ? null : v;
  };

  this.getAttj = function(start, sel, aname/*, default*/) {
    let v = self.getAtt.apply(null, arguments);
    try { v = JSON.parse(v); } catch(err) { v = undefined; }
    return v;
  };

  this.getAttb = function(start, sel, aname/*, default*/) {
    let v = self.getAtt.apply(null, arguments);
    if (typeof v === 'string') v = v.toLowerCase();
    if (TRUES.indexOf(v) > -1) return true;
    if (FALSES.indexOf(v) > -1) return false;
    return undefined;
  };

  this.getAtta = function(start, sel, aname/*, default*/) {
    let v = self.getAtt.apply(null, arguments);
    if (v === undefined) return v;
    return(('' + v)
      .split(',')
      .reduce(
        function(a, e) { e = e.trim(); if (e.length > 0) a.push(e); return a; },
        []));
  };

  this.getAttai = function(start, sel, aname/*, default*/) {
    let a = self.getAtta.apply(null, arguments);
    return Array.isArray(a) ?
      a.map(function(e) { return parseInt('' + e, 10); }) :
      a;
  };

  this.att = this.getAtt;
  this.atti = this.getAtti;
  this.attf = this.getAttf;
  this.attj = this.getAttj;
  this.attb = this.getAttb;
  this.atta = this.getAtta;
  this.attai = this.getAttai;

  this.dataset = function(start, sel) {
    let as = resol_sta_sel_las(arguments);
    return as.elt ? as.elt.dataset : null;
  };
  this.ds = this.dataset;

  let FALSIES = [ false, null, undefined, '' ];
  let isFalsy = function(v) { return isNaN(v) || FALSIES.indexOf(v) > -1; }
  let TRUES = 'true yes on'.split(' ');
  let FALSES = 'false no off'.split(' ');

  this.text = function(start, sel/*, default*/) {
    let as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    let t = as.elt.textContent.trim();
    return (t === '' && as.las) ? as.las : t;
  };
  this.t = this.text;

  this.getText = function(start, sel/*, default*/) {
    let as = resol_sta_sel_las(arguments);
    if ( ! as.elt) return as.las;
    let t = as.elt.textContent.trim();
    return (t === '' && as.las) ? as.las : t;
  };

  this.texti = function(start, sel/*, default*/) {
    let as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    let t = as.elt.textContent.trim(); if (t === '') t = '' + as.las;
    return parseInt(t, 10);
  };

  this.textf = function(start, sel/*, default*/) {
    let as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text";
    let t = as.elt.textContent.trim(); if (t === '') t = '' + as.las;
    return parseFloat(t);
  };

  this.get = function(start, sel/*, false */) {

    let a = self.toArray(arguments);
    let l = true; if (typeof a[a.length - 1] === 'boolean') l = a.pop();
    let e = self.elt.apply(null, a);
    let v = e ? e.value : null; v = v ? v.trim() : '';
    return l === false && v.length === 0 ? null : v;
  };

  let isTrue = function(o) {
    if (typeof o === 'string') o = o.toLowerCase();
    return o === true || o === 'true' || o === 'yes';
  };
  this.isTrue = isTrue;
  this.trueish = isTrue;

  let isVoid = function(o) { return o === null || o === undefined; };
  this.isVoid = isVoid;

  this.getb = function(start, sel/*, default */) {

    let a = self.toArray(arguments);
    let d = null; if (typeof a[a.length - 1] === 'boolean') d = a.pop();
    let v = self.get.apply(null, a).toLowerCase();
    if (d !== null && v === '') return d;
    return isTrue(v);
  };

  this.getf = function(start, sel/*, default */) {

    let a = self.toArray(arguments);
    let l = a[a.length - 1];
    let d = null;
    if (typeof l === 'number') d = a.pop();
    if (d !== null) a.push(false);
    let v = self.get.apply(null, a);
    if (v === null) { if (l === false) return v; if (d) return d; v = '0.0' }
    return parseFloat(v);
  };

  this.geti = function(start, sel/*, default */) {

    let a = self.toArray(arguments);
    let l = a[a.length - 1];
    let d = null;
    if (typeof l === 'number') d = a.pop();
    if (d !== null) a.push(false);
    let v = self.get.apply(null, a);
    if (v === null) { if (l === false) return v; v = d ? '' + d : '0' }
    return parseInt(v, 10);
  };

  this.getj = function(start, sel/*, default */) {

    let d = undefined;
    let a = self.toArray(arguments);
    let l = a[a.length - 1];
    if (a.length > 2) { d = a[2]; }
    else if (a.length > 1 && (typeof l) !== 'string') { d = a.pop(); }
    let v = self.get.apply(null, a);
    try { return JSON.parse(v); } catch(e) { return d; }
  };

  this.valb = this.getb;
  this.valf = this.getf;
  this.val = this.get;
  this.vali = this.geti;
  this.valj = this.getj;

  this.setValue = function(start, sel, value) {

    let a = self.toArray(arguments);
    let v = a.pop(); v = (v === null || v === undefined) ? '' : '' + v;

    let e = self.elt.apply(null, a);
    if (e) e.value = v;

    return v;
  };
  this.setv = this.setValue;
  this.set = this.setValue;

  this.setText = function(start, sel, text) {

    let a = self.toArray(arguments);
    let t = a.pop();
    let e = self.elt.apply(null, a)
    if (e) e.textContent = t;

    return t;
  };
  this.sett = this.setText;

  this.textOrValue = function(start, sel/*, default */) {
    let as = resol_sta_sel_las(arguments);
    if ( ! as.elt) throw "elt not found, no text or value";
    return (as.tov === '' && (typeof as.las === 'string')) ? as.las : as.tov;
  };
  this.tov = this.textOrValue;

  this.tovb = function(start, sel/*, default */) {
    let as = resol_sta_sel_las(arguments);
    if (as.elt) return isTrue(as.tov || '' + as.las);
    throw "elt not found, no text or value";
  };
  this.tovi = function(start, sel/*, default */) {
    let as = resol_sta_sel_las(arguments);
    if (as.elt) return parseInt(as.tov || '' + as.las, 10);
    throw "elt not found, no text or value";
  };
  this.tovf = function(start, sel/*, default */) {
    let as = resol_sta_sel_las(arguments);
    if (as.elt) return parseFloat(as.tov || '' + as.las);
    throw "elt not found, no text or value";
  };

  this.capitalize = function(s) {

    return s.charAt(0).toUpperCase() + s.slice(1);
  };
  this.cap = this.capitalize;

  this.decapitalize = function(s) {

    return s.charAt(0).toLowerCase() + s.slice(1);
  };
  this.decap = this.decapitalize;

  this.toCamelCase = function(s, cap) {

    s = s.replace(
      /([_-][a-z])/g,
      function(x) { return x.substring(1).toUpperCase(); });

    return cap ? self.capitalize(s) : s;
  };

  this.prepend = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    let e = toElt(start, sel);

    e.parentNode.insertBefore(elt, e);

    return elt;
  };

  this.postpend = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    let e = toElt(start, sel);

    e.parentNode.insertBefore(elt, e.nextSibling);

    return elt;
  };

  this.remove = function(start, sel, bof) {

    let as = rearg_sta_sel_las(arguments, true);

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
    let e = toElt(start, sel);
    let p = e.parentNode;

    p.insertBefore(elt, e);
    p.removeChild(e);
  };
  this.rep = this.replace;

  this.appendAsFirstChild = function(start, sel, elt) {

    if ( ! elt) { elt = sel; sel = start; start = null; }
    let e = toElt(start, sel);

    if (e.children.length < 1) e.appendChild(e);
    else e.insertBefore(elt, e.children[0]);
  };
  this.appendFirst = this.appendAsFirstChild;
  this.appc = this.appendFirst;

  this.clean = function(start, sel/*, fun */) {

    let as = Array.from(arguments);
    let a9 = as[as.length - 1];

    let elt = toElt(start, sel);
    let fun = (typeof(a9) === 'function') ? a9 : null;

    if ( ! elt) throw new Error("Couldn't find H.clean() start elt");

    if (fun)
      for (let e of Array.from(elt.children)) {
        if (fun(e, elt)) elt.removeChild(e);
      }
    else
      while (elt.firstChild) {
        elt.removeChild(elt.firstChild);
      }

    return elt;
  };

  this.onDocumentReady = function(fev) {

    if (document.readyState != 'loading') fev();
    else document.addEventListener('DOMContentLoaded', fev);
  };

  this.makeGrower = function(name) {
    let scan = function(s) {
      let m, r = [];
      s.replace(/([#.][^#.]+)/g, function(x) {
        r.push({ k: x[0], n: x.substring(1, x.length) });
      });
      return r;
    };
    return function() {
      let e = document.createElement(name);
      for (let i = 0, l = arguments.length; i < l; i++) {
        let a = arguments[i];
        if (a === false) return null; // skip this subtree
        if (a === null || a === undefined) continue; // ignore skipped children
        let s = (typeof a === 'string');
        if (s && (a[0] === '.' || a[0] === '#') && ! a.match(/^\s*$/)) {
          scan(a).forEach(function(x) {
            if (x.k === '#') e.id = x.n; else e.classList.add(x.n);
          });
        } else if (s) {
          e.appendChild(document.createTextNode(a));
        } else if (a.nodeType !== undefined && a.innerHTML !== undefined) {
          e.appendChild(a);
        } else if (typeof a === 'object') {
          for (let k in a) {
            e.setAttribute(k.slice(0, 1) === '-' ? 'data' + k : k, a[k]); };
        } else {
          e.appendChild(document.createTextNode('' + a));
        }
      }
      return e;
    };
  };

  this.create = function(/* parent, */tagname/*, rest */) {

    let as = self.toArray(arguments); let par = null; let off = 1;
    if (self.isElt(tagname)) { off = 2; par = tagname; tagname = as[1]; }
    as = as.slice(off);

    if (typeof tagname !== 'string') {
      throw(
        "parent probably null or undefined, args:" +
        JSON.stringify(self.toArray(arguments))); }

    let m = tagname.match(/^([a-zA-Z0-9]+)?([.#].+)$/)
    if (m) { tagname = m[1] || 'div'; as.unshift(m[2]); }

    let elt = self.makeGrower(tagname).apply(null, as);

    if (par) par.appendChild(elt);

    return elt;
  };
  this.c = this.create;

  let TAGS = (
    'a abbr address area article aside audio b base bdi bdo blockquote body ' +
    'br button canvas caption cite code col colgroup data datalist dd del ' +
    'details dfn dialog div dl dt em embed fieldset figcaption figure footer ' +
    'form h1 h2 h3 h4 h5 h6 head header hr html i iframe img input ins kbd ' +
    'keygen label legend li link main map mark menu menuitem meta meter nav ' +
    'noscript object ol optgroup option output p param picture pre progress ' +
    'q rp rt ruby s samp script section select small source span strong ' +
    'style sub summary sup table tbody td textarea tfoot th thead time title ' +
    'tr track u ul video wbr'
      ).split(' ');
        //
        // removed the "var" tagname...

  let growers =
    'var ' +
    TAGS
      .map(function(t) { return t + '=H.makeGrower("' + t + '")' })
      .join(',') +
    ';';

  this.grow = function(fun) {

    let f = fun.toString().trim();
    f = f.substring(f.indexOf('{') + 1, f.lastIndexOf('}'));

    return eval(growers + f);
  };

  this.makeTemplate = function(fun) {

    return eval('(' + fun.toString().replace(/\{/, '{' + growers) + ')');
  };

  this.delay = function(ms, fun) {

    let t = null;

    return function() {
      let as = arguments;
      window.clearTimeout(t);
      t = window.setTimeout(function() { fun.apply(this, as) }, ms);
    };
  };

  this.schedule = function(/* scheduleArray, fun, failFun */) {

    let as = Array.from(arguments);

    let a = as.find(function(e) { return Array.isArray(e); });
    let i = as.find(function(e) { return typeof e === 'number'; }) || 0;
    let fs = as.filter(function(e) { return typeof e === 'function'; });

    let t = a.shift();
    if (t === undefined) { (fs[1] || function() {})(false); return; }

    window.setTimeout(
      function() {
        let r = (fs[0] || function() {})(i || 0, t);
        if ( ! r) self.schedule(a, fs[0], fs[1], i + 1); },
      t);
  };

  this.makeWorker = function(workerFunction/*, wrap=true*/) {

    let s = workerFunction.toString();
    let x = arguments[1]; x = (x === undefined) || ( !! x);
    if (x) s = "self.addEventListener('message', " + s + ", false);";
    else s = s.substring(s.indexOf('{') + 1, s.lastIndexOf('}'));

    let r = document && document.location && document.location.href;
    if (r) {
      let j = r.lastIndexOf('/'); if (j < 0) j = r.length - 1;
      r = r.substring(0, j) + '/';
      s = "var rootUrl = \"" + r + "\";" + s;
    }

    let b = new Blob([ s ]);

    let w = new Worker(window.URL.createObjectURL(b));
    w.on = function(t, cb) { w.addEventListener(t, cb, false); };

    return w;
  };

  this.validateEmail = function(s) {

    if (s.indexOf("@") < 0) return null;
    if (s.indexOf("\n") > -1 || s.indexOf("\r") > -1) return null;

    let m = s.match(/^[^<]+<([^>]+)>\s*$/);
    if (m) s = m[1];

    let id =
      '__h_js_email_validation_input_elt';
    let ie =
      document.getElementById(id) ||
      H.c(
        document.body,
        'input.' + id, { style: 'display: none;', type: 'email' });

    ie.value = s;

    return ie.validity.valid ? s : null;
  };

  this.isValidEmail = function(s) {

    return (typeof self.validateEmail(s) === 'string');
  };

  this.length = function(x) {

    if (x === null) return -1;
    if (Array.isArray(x)) return x.length;
    if (typeof x === 'string') return x.length;
    if (typeof x === 'object') return Object.keys(x).length;
    return -1;
  };
  this.len = this.length;
  this.size = this.length;

  this.isVacuous = function(x) {

    if (x === null || x === undefined)
      return false;
    if (Array.isArray(x))
      return ! x.find(function(e) { return e !== null && e !== undefined; });
    if (typeof x === 'object')
      return Object.keys(x).length < 1;

    return false;
  };

  let _iterate = function(iterator, array_or_hash, fun, thisArg) {

    fun = fun.bind(thisArg);

    if (Array.isArray(array_or_hash)) {
      return array_or_hash[iterator](
        fun);
    }
    if (self.isHash(array_or_hash)) {
      return Object.entries(array_or_hash)[iterator](
        function(kv, i) { return fun(kv[0], kv[1], i); });
    }

    throw new Error('Cannot iterate over >' + JSON.dump(array_or_hash) + '<');
  };

  // Warning: this is not equivalent to H.forEach(sta, sel, fun)
  //
  this.each = function(array_or_hash, fun, thisArg) {
    return _iterate('forEach', array_or_hash, fun, thisArg); };

  // Steal Ruby's "collect" and friends to differentiate from map/filter/...

  this.collect = function(array_or_hash, fun, thisArg) {
    return _iterate('map', array_or_hash, fun, thisArg); };

  let _elect = function(positive, array_or_hash, fun, thisArg) {

    if (Array.isArray(array_or_hash)) {
      return array_or_hash.filter(
        function(e, i) { return ( !! fun(e, i)) === positive; },
        thisArg);
    }
    if (self.isHash(array_or_hash)) {
      let h = {};
      Object.entries(array_or_hash).forEach(
        function(kv, i) {
          let k = kv[0], v = kv[1];
          if (( !! fun(k, v, i)) === positive) h[k] = v;
        },
        thisArg);
      return h;
    }

    throw new Error('Cannot iterate over >' + JSON.dump(array_or_hash) + '<');
  };

  this.select = function(array_or_hash, fun, thisArg) {
    return _elect(true, array_or_hash, fun, thisArg); };

  this.reject = function(array_or_hash, fun, thisArg) {
    return _elect(false, array_or_hash, fun, thisArg); };

  this.inject = function(array_or_hash, fun, acc, thisArg) {

    if (Array.isArray(array_or_hash)) {
      return array_or_hash.reduce(fun.bind(thisArg), acc);
    }
    if (self.isHash(array_or_hash)) {
      Object.entries(array_or_hash)
        .forEach(function(kv, i) { acc = fun(acc, kv[0], kv[1], i); }, thisArg);
      return acc;
    }

    throw new Error('Cannot iterate over >' + JSON.dump(array_or_hash) + '<');
  };

  this.filterByType = function() {

    let a = Array.from(arguments.length === 1 ? arguments[0] : arguments);

    let f = function(type) {
      return a.filter(function(e) { return (typeof e) === type; }); };

    let h = {
      strings: f('string'), functions: f('function'), numbers: f('number'),
      booleans: a.filter(function(e) { return e === false || e === true; }),
      arrays: a.filter(function(e) { return Array.isArray(e); }),
      hashes: a.filter(function(e) { return H.isH(e); }),
      a: a };
    h.integers =
      h.numbers.filter(function(e) { return Number.isInteger(e); });
    h.nonIntegers =
      h.numbers.filter(function(e) { return ! Number.isInteger(e); });

    return h;
  };

  //
  // done.

  return this;

}).apply({}); // end H


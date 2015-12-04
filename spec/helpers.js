
//
// methods missing from PhantomJS plus some other helpers
//


// from https://developer.mozilla.org/en/docs/Web/API/Element/matches
//
HTMLElement.prototype.matches = function(sel) {

  var es = (this.document || this.ownerDocument).querySelectorAll(sel);
  for (var i = 0, l = es.length; i < l; i ++) if (es[i] === this) return true;

  return false;
};

HTMLElement.prototype.remove = function() {

  this.parentElement.removeChild(this);
};

// http://stackoverflow.com/questions/15739263/phantomjs-click-an-element
//
HTMLElement.prototype.click = function() {

  var ev = document.createEvent('MouseEvent');
  ev.initMouseEvent(
    'click',
    true, true, // bubble, cancellable
    window, null,
    0, 0, 0, 0, // coordinates
    false, false, false, false, // modifier keys
    0, // button=left
    null);
  this.dispatchEvent(ev);
};

//  this.trigger = function(start, sel, eventName) {
//
//    if ( ! eventName) { eventName = sel; sel = start; start = null; }
//
//    var elt = toElt(start, sel);
//
//    var ev = document.createEvent('HTMLEvents');
//    ev.initEvent(eventName, true, false);
//
//    elt.dispatchEvent(ev);
//  };

HTMLElement.prototype.idAndClasses = function() {

  var a = []; for (var i = 0, l = this.classList.length; i < l; i++) {
    a.push(this.classList[i]);
  }

  return '' +
    (this.id ? '#' + this.id : '') +
    (a.length > 0 ? '.' + a.join('.') : '');
};

//
// faking XMLHttpRequest

XMLHttpRequest = function() {
  window._req = this;
  this.headers = {};
  this.data = null;
  this.sent = false;
};
XMLHttpRequest.prototype.open = function(meth, uri, bool) {
  this.method = meth;
  this.uri = uri;
};
XMLHttpRequest.prototype.setRequestHeader = function(key, val) {
  this.headers[key] = val;
};
XMLHttpRequest.prototype.send = function(data) {
  this.data = data;
  this.sent = true;
};
//
XMLHttpRequest.prototype.respond = function(status, text) {
  this.status = status;
  this.responseText = text;
  if (status) this.onload(); else this.onerror();
  return this;
};


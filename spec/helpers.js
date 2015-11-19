
//
// methods missing from PhantomJS
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


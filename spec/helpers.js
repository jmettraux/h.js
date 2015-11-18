
//Array.prototype.map = function(f) {
//
//  var r = [];
//  this.forEach(function(e) { r.push(f(e)); });
//
//  return r;
//};

// from https://developer.mozilla.org/en/docs/Web/API/Element/matches
//
HTMLElement.prototype.matches = function(sel) {

  var es = (this.document || this.ownerDocument).querySelectorAll(sel);
  for (var i = 0, l = es.length; i < l; i ++) if (es[i] === this) return true;

  return false;
}


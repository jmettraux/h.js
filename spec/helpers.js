
Array.prototype.map = function(f) {

  var r = [];
  this.forEach(function(e) { r.push(f(e)); });

  return r;
};


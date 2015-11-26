
# h.js

my Javascript foolbox.

Owes a great deal to http://youmightnotneedjquery.com/


## signatures

```js
// glossary
//
// bof: boolean or function, a boolean or a function returning a boolean
// boo: boolean
// cla: classname, may start with a dot "." or not
// elt: a DOM Element
// fun: a function, function(elt) {}
// sel: css selector
// sta: start point, either a DOM Element, either a CSS selector


// Returns a single Element
H.elt(sel);
H.elt(sta, sel);

// Returns a javascript array of elements
H.elts(sel);
H.elts(sta, sel);

// Returns true if the elt matches the sel
H.matches(elt, sel);

// Returns a single Element, stars from (sta[, sel]) up until it matches up-sel
H.closest(sta, up-sel);
H.closest(sta, sel, up-sel);

// Calls fun on each Element
H.forEach(sta, fun);
H.forEach(sta, sel, fun);
  // Shorter form of
  H.elts(sta, sel).forEach(fun);

// Returns true if the Element pointed at by (sta[, sel]) has the class cla
H.hasClass(sta, cla);
H.hasClass(sta, sel, cla);

// Sets a class on a set of Element instances of removes the class if already
// present
H.toggleClass(sta, cla);
H.toggleClass(sta, sel, cla);

H.addClass(sta, cla);
H.addClass(sta, sel, cla);
H.addClass(sta, cla, bof);
H.addClass(sta, sel, cla, bof);

H.removeClass(sta, cla);
H.removeClass(sta, sel, cla);
H.removeClass(sta, cla, bof);
H.removeClass(sta, sel, cla, bof);
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)


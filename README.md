
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
// evn: an event name, like 'click', 'keyup' or 'change'
// fev: a classical event function, function(evt) {}
// fun: a function, function(elt) {}
// sel: css selector
// sta: start point, either a DOM Element, either a CSS selector
// str: a String


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

// Adds a class to an Element or a set of Element. If a bof is given, will
// only add if the bof evals to true
H.addClass(sta, cla);
H.addClass(sta, sel, cla);
H.addClass(sta, cla, bof);
H.addClass(sta, sel, cla, bof);

// Removes a class to an Element or a set of Element. If a bof is given, will
// only remove if the bof evals to true
H.removeClass(sta, cla);
H.removeClass(sta, sel, cla);
H.removeClass(sta, cla, bof);
H.removeClass(sta, sel, cla, bof);

// Similar to H.addClass() but if the bof evals to false will remove the class
H.setClass(sta, cla);
H.setClass(sta, sel, cla);
H.setClass(sta, cla, bof);
H.setClass(sta, sel, cla, bof);

// Iterates a set of Element, when it finds class cla0, it removes it and
// replaces it with cla1
H.renameClass(sta, cla0, cla1);
H.renameClass(sta, sel, cla0, cla1);

// Creates an HTMLElement
H.create(tagName, attributes, textContent);
  //
  // for example:

  H.create('span', { 'data-id': 123 }, 'hello world');
    // yields: <span data-id="123">hello world</span>

  H.create('span.letter', {}, 'alpha');
    // yields: <span class="letter">alpha</span>

  H.create('span#first.letter.nato', {}, 'bravo');
    // yields: <span id="first" class="letter nato">bravo</span>

// Uses HTMLElement.innerHTML= to turn a string into an HTMLElement.
// Handle with care.
H.toNode(string);
  //
  H.toNode('<span data-id="123">hello</span>');

// Adds an event listener to an Element or a set of Element
H.on(sta, evn, fev);
H.on(sta, sel, evn, fev);

// Sets disabled="disabled" on an Element or a set of Element.
// If the bof is present and  yields false, disabled="disabled" will be removed.
// (behaviour similar to H.setClass() above).
H.disable(sta);
H.disable(sta, sel);
H.disable(sta, bof);
H.disable(sta, sel, bof);

// Like H.disable() but with an inverse effect.
H.enable(sta);
H.enable(sta, sel);
H.enable(sta, bof);
H.enable(sta, sel, bof);

// Like H.disable() and H.enable(), but instead of working with the "disabled"
// attribute, sets or removes the "disabled" class.
H.cdisable(sta);
H.cdisable(sta, sel);
H.cdisable(sta, bof);
H.cdisable(sta, sel, bof);
H.cenable(sta);
H.cenable(sta, sel);
H.cenable(sta, bof);
H.cenable(sta, sel, bof);

// Like H.cenable() but toggles the 'shown' class
H.show(sta);
H.show(sta, sel);
H.show(sta, bof);
H.show(sta, sel, bof);

// Like H.cenable() but toggles the 'hidden' class
H.hide(sta);
H.hide(sta, sel);
H.hide(sta, bof);
H.hide(sta, sel, bof);

// Turns "my_old-donkey" into "myOldDonkey"
H.toCamelCase(str);

// Inserts an Element before another one (the one pointed at by sta[, sel]).
H.prepend(sta, elt);
H.prepend(sta, sel, elt);

// Removes an Element or a set of Element. If bof is present, removes only
// if bof yields true.
H.remove(sta);
H.remove(sta, sel);
H.remove(sta, bof);
H.remove(sta, sel, bof);

// Given an element (the first to match (sta, sel)) removes all its children.
// If a classname is given, removes only those children that sport the
// classname.
H.clean(sta);
H.clean(sta, sel);
H.clean(sta, cla);
H.clean(sta, sel, cla);

// Runs fev as soon as the Document is ready,
// the evt passed to the function might be undefined
H.onDocumentReady(fev);
```

Two methods for inspecting style and dimensions of an element.

```
// Returns an object
// { top: p, bottom: p, left: p, right: p, height: p, width: p }
// where p are values in pixel
H.dim(sta);
H.dim(sta, sel);

// Returns an object with the computed style of an element
H.style(sta);
H.style(sta, sel);
```

H.js also sports a few functions wrapping XMLHttpRequest.

```
// H.request()
//
// meth: 'GET', 'POST', 'PUT', 'HEAD', 'DELETE', ...
// uri: "http://that.example.org/stuff"
//
// data:
//   TODO
//
// onok:
//   a function with the signature function(res) {}
//   a "res" object is a of the form { status: int, request: r, data: x }
//   TODO
// callbacks:
//   an object with at least an "onok" entry and at most "onok", "onload"
//   and "onerror" entries.
//   The 3 entries should point to a function with signature function(res) {}
//   As seen above, "onok" is called for responses with status code 200 OK.
//   "onload" is called for any non-200 status code responses.
//   "onerror" is called when the request failed (no response).
//
H.request(meth, uri, onok);
H.request(meth, uri, headers, onok);
H.request(meth, uri, data, onok);
H.request(meth, uri, headers, data, onok);
H.request(meth, uri, callbacks);
H.request(meth, uri, headers, callbacks);
H.request(meth, uri, data, callbacks);
H.request(meth, uri, headers, data, callbacks);

// H.upload()
//
// TODO
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)


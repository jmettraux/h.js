
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

// Adds an event listener to an Element or a set of Element.
H.on(sta, evn, fun);
H.on(sta, sel, evn, fun);
  //
  // the function here has the classical signature:
  function(event) {}
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)


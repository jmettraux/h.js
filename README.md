
# h.js

my Javascript foolbox.

Owes a great deal to http://youmightnotneedjquery.com/ and to the fall of IE.


## the "^" caret prefix to selectors

```js
H.elt(start, '^.tune');
  // is equivalent to
H.closest(start, '.tune');

H.elt(start, '^.tune .note');
  // is equivalent to
H.elt(H.closest(start, '.tune'), '.note');

H.enable(start, '^.tune');
  // is equivalent to
H.enable(H.closest(start, '.tune'));

// and so on...
```

The caret can only be placed at the beginning of a selector though.


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
// sta: start point: a DOM Element, a CSS selector (string), or an Event
// str: a String

// sta and sel may be arrays of DOM elements or CSS selectors (2022-02-24)
// sta may be a Javascript arguments instance (2022-03-15)


// Returns a single Element
H.elt(sta);
H.elt(sta, sel);
H.e(sta);
H.e(sta, sel);

  // note the equivalences:
  //   H.elt(japan, '^.asia') <--> H.closest(japan, '.asia')
  //   H.elt(japan, '^.asia .korea') <--> H.elt(H.closest(japan, '.asia'), '.korea')
  // H.js has this ^ "up above" operator, only works at the beginning of the
  // selector

// Returns a javascript array of elements
H.elts(sta);
H.elts(sta, sel);
H.es(sta);
H.es(sta, sel);

  // note the equivalences:
  //   H.elts(japan, '^.continent') <--> H.closest(japan, '.continent')
  //   H.elts(japan, '^.continent .country') <--> H.elt(H.closest(japan, '.continent'), '.country')
  // H.js has this ^ "up above" operator, only works at the beginning of the
  // selector

// Returns the count of matching elements
H.count(sta);
H.count(sta, sel);

// Returns true if the argument is a DOM Element
H.isElement(o);
H.isElt(o);

// Returns true if the argument is an object but not null and not an array
H.isHash(o);
H.isH(o);

// Returns true if the argument is a js Arguments instance
H.isArguments(o);
H.isArgs(o);

// Returns true if the elt matches the final sel
H.matches(sta, sel);
H.matches(sta, sel, sel);

// Returns a single Element, stars from (sta[, sel]) up until it matches up-sel
H.closest(sta, up-sel);
H.closest(sta, sel, up-sel);

// Calls fun on each Element
H.forEach(sta, fun);
H.forEach(sta, sel, fun);
  // Shorter form of
  H.elts(sta, sel).forEach(fun);

H.map(sta, fun);
H.map(sta, sel, fun);
  // Shorter form of
  H.elts(sta, sel).map(fun);

H.find(sta, fun);
H.find(sta, sel, fun);
  // Shorter form of
  H.elts(sta, sel).find(fun);

H.filter(sta, fun);
H.filter(sta, sel, fun);
  // Shorter form of
  H.elts(sta, sel).filter(fun);

H.reduce(sta, fun, initial);
H.reduce(sta, sel, fun, initial);
  // Shorter form of
  H.elts(sta, sel).reduce(fun, initial);

// Returns true if the Element pointed at by (sta[, sel]) has the class cla
H.hasClass(sta, cla);
H.hasClass(sta, sel, cla);
H.hasc // alias

// Sets a class on a set of Element instances of removes the class if already
// present
H.toggleClass(sta, cla);
H.toggleClass(sta, sel, cla);
H.toggle  // aliases
H.togc    //

// Shortcut for H.toggleClass(sta, sel, '.hidden');
H.toggleHidden(sta);
H.toggleHidden(sta, sel);
H.togh // alias

// Adds a class to an Element or a set of Element. If a bof is given, will
// only add if the bof evals to true
H.addClass(sta, cla);
H.addClass(sta, sel, cla);
H.addClass(sta, cla, bof);
H.addClass(sta, sel, cla, bof);
H.addc // alias
// cla can be "class0", ".class0", or even ".class0.class1"...
// cla can also be an array, like [ '.class0', 'class1' ]

// Removes a class to an Element or a set of Element. If a bof is given, will
// only remove if the bof evals to true
H.removeClass(sta, cla);
H.removeClass(sta, sel, cla);
H.removeClass(sta, cla, bof);
H.removeClass(sta, sel, cla, bof);
H.remClass  // aliases
H.remc      //
// cla can be "class0", ".class0", or even ".class0.class1"...
// cla can also be an array, like [ '.class0', 'class1' ]

// Similar to H.addClass() but if the bof evals to false will remove the class
H.setClass(sta, cla);
H.setClass(sta, sel, cla);
H.setClass(sta, cla, bof);
H.setClass(sta, sel, cla, bof);
H.setc // alias

// Iterates a set of Element, when it finds class cla0, it removes it and
// replaces it with cla1
H.renameClass(sta, cla0, cla1);
H.renameClass(sta, sel, cla0, cla1);

// Returns the array of class names for the targeted element.
// Returns a Javascript Array, not a DOMTokenList
H.classArray(sta);
H.classArray(sta, sel);

// Returns the first class name of the element that is also in classNameArray
// Returns undefined else
H.classFrom(sta, classNameArray);
H.classFrom(sta, sel, classNameArray);

// Creates an HTMLElement
H.create(tagName, attributes, textContent);
H.c(tagName, attributes, textContent);
  //
  // for example:

  H.create('span', { 'data-id': 123 }, 'hello world');
    // yields: <span data-id="123">hello world</span>

  H.create('span.letter', {}, 'alpha');
    // yields: <span class="letter">alpha</span>

  H.create('span#first.letter.nato', {}, 'bravo');
    // yields: <span id="first" class="letter nato">bravo</span>

H.create(parent, tagName, attributes, textContent);
  // creates an element, appends it to its parent and returns the element

// Uses HTMLElement.innerHTML= to turn a string into an HTMLElement.
// Handle with care.
// Returns the argument if it's not a string.
// If a selector is given, it's applied to the resulting node.
H.toNode(string);
H.toNode(string, sel);
  //
  H.toNode('<span data-id="123">hello</span>');

// Adds an event listener to an Element or a set of Element
H.on(sta, evn, fev);
H.on(sta, sel, evn, fev);
H.on(sta, sel, [ evn0, evn1 ], fev);
  // for example, bind 'change' and 'keyup' in one go
H.on(sta, sel, "evn0, evn1 / evn2", fev);
  // instead of an array of event names, list them in a string

// If an event name is followed by "." (dot), then it will not trigger
// for children of the elements it is bound to.
H.on(sta, sel, 'click.', fev);
  // short for
H.on(sta, sel, 'click', function(ev) { if (this === ev.target) fev(ev); });

// Clicks on an element
H.click(sta);
H.click(sta, sel);
H.k(sta);
H.k(sta, sel);

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

// Returns true if the elt has the attribute "disabled" set to "disabled" or
// if the elt has the class "disabled".
H.isDisabled(sta);
H.isDisabled(sta, sel);

// Like H.cenable() but toggles the 'shown' class
H.show(sta);
H.show(sta, sel);
H.show(sta, bof);
H.show(sta, sel, bof);

// Like H.show() but negative
H.unshow(sta);
H.unshow(sta, sel);
H.unshow(sta, bof);
H.unshow(sta, sel, bof);

// Like H.cenable() but toggles the 'hidden' class
H.hide(sta);
H.hide(sta, sel);
H.hide(sta, bof);
H.hide(sta, sel, bof);

// Like H.hide() but negative
H.unhide(sta);
H.unhide(sta, sel);
H.unhide(sta, bof);
H.unhide(sta, sel, bof);

// Returns true if the elt has the class 'hidden'
H.isHidden(sta);
H.isHidden(sta, sel);

// Returns true if the elt has the pseudo-class ':invalid' (or not)
H.isInvalid(sta);
H.isInvalid(sta, sel);
H.isValid(sta);
H.isValid(sta, sel);

// Turns 'jeff' into 'Jeff'
H.capitalize(str);

// Turns "my_old-donkey" into "myOldDonkey"
H.toCamelCase(str);
H.toCamelCase(str, cap); // when cap is true, capitalizes the first char

// Inserts an Element before another one (the one pointed at by sta[, sel]).
H.prepend(sta, elt);
H.prepend(sta, sel, elt);

// Inserts an Element after another one
H.postpend(sta, elt);
H.postpend(sta, sel, elt);

// Append elt as the first child of (sta, elt)
H.appendAsFirstChild(sta, elt);
H.appendAsFirstChild(sta, sel, elt);
H.appc(sta, elt);
H.appc(sta, sel, elt);

// Removes an Element or a set of Element. If bof is present, removes only
// if bof yields true.
H.remove(sta);
H.remove(sta, sel);
H.remove(sta, bof);
H.remove(sta, sel, bof);
H.rem(sta);
H.rem(sta, sel);
H.rem(sta, bof);
H.rem(sta, sel, bof);
H.del(sta);
H.del(sta, sel);
H.del(sta, bof);
H.del(sta, sel, bof);

// Replaces an element with another
H.replace(sta, elt);
H.replace(sta, sel, elt);
H.rep(sta, elt);
H.rep(sta, sel, elt);

// Given an element (the first to match (sta, sel)) removes all its children.
// If a classname is given, removes only those children that sport the
// classname.
H.clean(sta);
H.clean(sta, sel);
H.clean(sta, cla);
H.clean(sta, sel, cla);

// Short for H.elt(sta, sel).getAttribute(name);
H.getAtt(sta, name/*, default*/);
H.getAtt(sta, sel, name);
H.getAtt(sta, sel, name/*, default*/);
H.att(sta, name/*, default*/);
H.att(sta, sel, name);
H.att(sta, sel, name/*, default*/);
  //
// Short for parseInt(H.elt(sta, sel).getAttribute(name), 10);
H.getAtti(sta, sel, name);
H.getAtti(sta, sel, name/*, default*/);
H.atti(sta, sel, name);
H.atti(sta, sel, name/*, default*/);
  //
// Short for parseFloat(H.elt(sta, sel).getAttribute(name));
H.getAttf(sta, sel, name);
H.getAttf(sta, sel, name/*, default*/);
H.attf(sta, sel, name);
H.attf(sta, sel, name/*, default*/);
  //
// Short for JSON.parse(H.elt(sta, sel).getAttribute(name));
H.getAttj(sta, sel, name);
H.getAttj(sta, sel, name/*, default*/);
H.attj(sta, sel, name);
H.attj(sta, sel, name/*, default*/);

// Short for H.forEach(sta, sel, function(e) { e.setAttribute(name, value); });
H.setAtt(sta, name, value);
H.setAtt(sta, sel, name, value);
H.satt(sta, name, value);
H.satt(sta, sel, name, value);
  //
// setting to null actually removes the attribute
H.setAtt('#this-or-that', 'att-x', null);
H.satt('#this-or-that', 'att-x', null);

// setting multiple attributes by passing a dict
H.setAtts(sta, object);
H.setAtts(sta, sel, object);
  //
H.setAtts('#this-or-that', { att0: 'zero', att1: 1, att2: null /* to remove */ })

// Short for H.forEach(sta, sel, function(e) { e.removeAttribute(name); });
H.remAtt(sta, name);
H.remAtt(sta, sel, name);
H.ratt(sta, name);
H.ratt(sta, sel, name);

// Sets the value of an input, select or textarea
H.set(sta, val);
H.set(sta, sel, val);

// Gets the trimmed value of an input, select or textarea
H.get(sta);
H.get(sta, sel);
H.get(sta, sel, false); // returns null if the trimmed value length is zero

// Like get but returns true or false (true when 'true' or 'yes')
H.getb(sta);
H.getb(sta, sel);
H.getb(sta, sel, default);
H.getb(sta, sel, false); // returns null if the trimmed value length is zero

// Like get but returns a float
H.getf(sta);
H.getf(sta, sel);
H.getf(sta, sel, default);
H.getf(sta, sel, false); // returns null if the trimmed value length is zero

// Like getf but returns an integer
H.geti(sta);
H.geti(sta, sel);
H.geti(sta, sel, default);
H.geti(sta, sel, false); // returns null if the trimmed value length is zero

// Like get but attempts to parse as JSON the value
H.getj(sta);
H.getj(sta, sel);
H.getj(sta, sel, default);

// getX methods are aliased to valX...
H.val(sta);
H.valb(sta);
H.vali(sta);
H.valf(sta);
H.valj(sta);

// Short for H.elt(sta, sel).textContent.trim();
H.text(sta);
H.text(sta, sel);
H.text(sta, sel, default);

// Parsing the textContent in an element
H.texti(sta);
H.texti(sta, sel);
H.texti(sta, sel, default);
H.textf(sta);
H.textf(sta, sel);
H.textf(sta, sel, default);
  // the default values are forced into an int or a float respectively

// returns text or undefined, doesn't fail
H.getText(sta);
H.getText(sta, sel);
H.getText(sta, sel, default);
  // returns the trimmed textContext of an element
  // returns undefined or default if the element is not found or the text is ''

// Grabbing the value= or else, the textContent of an element
H.textOrValue(sta);
H.textOrValue(sta, sel);
H.textOrValue(sta, sel, default);
H.tov(sta);
H.tov(sta, sel);
H.tov(sta, sel, default); // string
H.tovb(sta);
H.tovb(sta, sel);
H.tovb(sta, sel, default); // boolean
H.tovi(sta);
H.tovi(sta, sel);
H.tovi(sta, sel, default); // integer
H.tovf(sta);
H.tovf(sta, sel);
H.tovf(sta, sel, default); // float

// Short for H.elt(sta, sel).textContent = text;
H.setText(sta, text);
H.setText(sta, sel, text);
H.sett(sta, text);
H.sett(sta, sel, text);

// Runs fev as soon as the Document is ready,
// the evt passed to the function might be undefined
H.onDocumentReady(fev);
```

Four methods for inspecting style and dimensions of an element.

```js
// Returns an object
// { top: p, bottom: p, left: p, right: p, height: p, width: p }
// where p are values in pixel (seemingly int)
//
// Doesn't work for object inside of a table (use tdim() for those)
//
H.dim(sta);
H.dim(sta, sel);

// Returns an object
// { top: p, bottom: p, left: p, right: p, height: p, width: p }
// where p are values in pixel (seemingly int)
//
// Computes iteratively from offsetParent to offsetParent (OK with elements
// inside of tables).
//
H.tdim(sta);
H.tdim(sta, sel);

// Returns an object
// { top: p, bottom: p, left: p, right: p, height: p, width: p }
// where p are values in pixel (seemingly float)
//
// Computes using Element#getBoundingRect() and comparing the elt with <body>.
//
H.bdim(sta);
H.bdim(sta, sel);

// Return the offsetHeight, respectively offsetWidth of an element. Returns
// null if the element cannot be found. Returns an integer (px).
H.height(sta);
H.height(sta, sel);
H.width(sta);
H.width(sta, sel);
H.h(sta);
H.h(sta, sel);
H.w(sta);
H.w(sta, sel);

// Returns an object with the computed style of an element
H.style(sta);
H.style(sta, sel);
H.styles(sta);
H.styles(sta, sel);
  # it returns a dictionary (hash) of all the computed style of the element
  #
  { // ...
    bottom: 'auto', boxShadow: 'none', boxSizing: 'content-box',
    breakAfter: 'auto', breakBefore: 'auto', breakInside: 'auto',
    bufferedRendering: 'auto', captionSide: 'top',
    caretColor: 'rgb(0, 0, 0)', clear: 'none', clip: 'auto', // ...
      }

H.style(sta, { filter: keys });
H.style(sta, sel, { filter: keys });
H.styles(sta, { filter: keys });
H.styles(sta, sel, { filter: keys });
  # where keys is an array of keys [ 'position', 'display', 'color' ]
  #               or a comma sep list of keys 'position,display,color'
  #
  # will return only the "filter" keys, useful when debugging CSS and
  # focusing on a range of CSS properties...
  #
  { position: 'absolute', display: 'none', color: 'rgb(0, 0, 0)' }
```

The `.path` method returns a "sure" path to an element.
(I use it mostly in my Selenium helper libraries).

```js
// Returns a path like, for example, "#for-path > :nth-child(2) > :nth-child(2)"
// which points to the element from the root of the DOM.
// Could be useful when an element was obtained by succession of queries and
// one wants a single string CSS path to it.
//
H.path(sta);
H.path(sta, sel);
```

`H.eltPath` returns a similar path but less "sure".

```js
// less "sure" than H.path, but indicative enough...
//
// example output "#for-path > div > .container > span"
//
H.eltPath(sta);
H.eltPath(sta, sel);
```

`H.eltSignature` returns a signature for an element, it's used by `H.eltPath`
for the component of each of its answers.

`H.eltTagSignature` returns, well, the outerHTML minus the innerHTML of the
targetted element. For example `<div id="nada" class="surf board">`.

H.js also sports a few functions wrapping XMLHttpRequest.

```js
// H.request()
//
// meth: 'GET', 'POST', 'PUT', 'HEAD', 'DELETE', ...
// uri: "http://that.example.org/stuff"
//
// data:
//   by default, h.js will consider data as something to turn into JSON
//   via JSON.stringify. If data is a string will simply pass it as is.
//
//   If the data is an instance of FormData, the data will be passed as is.
//
//   If a "Content-Type" request header that is doesn't contain "json" is
//   given, the data is turned into a string via toString() before being sent.
//
// onok:
//   a function with the signature function(res) {}
//   a "res" object is a of the form { status: int, request: r, data: x }
//
// callbacks:
//   an object with at least an "onok" entry and at most "onok", "onload"
//   and "onerror" entries.
//   The 3 entries should point to a function with signature function(res) {}
//   As seen above, "onok" is called for responses with status code 200 OK.
//   "onload" is called for any non-200 status code responses.
//   "onerror" is called when the request failed (no response).
//   "ontimeout" is called when the request times out (default timeout 10s)
//   "timeout" sets the timeout (milliseconds)
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

The function `makeWorker` takes a function and create a [web worker](https://developer.mozilla.org/en-US/docs/Web/API/Web_Workers_API/Using_web_workers) out of it. It also adds an extra `on()` function to the worker.
```js
var worker =
  H.makeWorker(
    function(m) {
      postMessage('worker got ' + JSON.stringify(m.data));
    });

worker.on('message', function(m) { console.log([ 'message from worker', m ]) });
worker.on('error', function(e) { console.log([ 'error in worker', e ]) });
```
Caution: the function for the worker is stringified, its closure is thus lost.

If the auto-wrapping of `makeWorker()` is getting in the way, passing false as a second argument disables it:
```js
var worker =
  H.makeWorker(
    function() {
      var counter = 0;
      onmessage = function(m) {
        counter = counter + 1;
        postMessage('worker called ' + count + ' times');
      };
    },
    false); // <-- disables the wrapping
```

Please note that `makeWorker()` sets a `rootUrl` variable to make importing scripts easier:
```js
var worker =
  H.makeWorker(
    function(m) {
      importScripts(rootUrl + 'scripts/a.js', rootUrl + 'scripts/b.js');
      postMessage('worker ready');
    });
```

There is a function called `grow` to generate HTML elements:
```js
H.grow(function() {

  div('#nada.surf',
    span('.a', 'alpha'),
    span('.b', 'bravo'),
    div('.c',
      false, // <-- effectively comments out the containing element `.c`
      span('.d', 'delta'),
      span('.e', 'echo')))

}).outerHTML;
  //
  // ==>
  //
  // <div id="nada" class="surf">
  //   <span class="a">alpha</span>
  //   <span class="b">bravo</span>
  // </div>
```
It has a `makeTemplate` sidekick:
```js
var templates = {}
templates.execution = H.makeTemplate(function(e) {
  div('.execution',
    span('.exid', e.exid),
    span('.actions',
      input({ type: 'submit' })));
});
// ...
H.elt('#executions').appendChild(templates.execution({ exid: 'abc-def' }));
```

Misc functions:
```js
H.toArray(x);

// (I mostly use it in code like
  var fun = function(/* sel, start, mode */ {
    var as = H.toArray(arguments);
    var mode = as.pop();
    var elt = H.elt.apply(null, as);
  }
// )
```

```js
H.delay(milliseconds, function);

// for example:

H.on('input[name="amount"]', 'keyup', H.delay(1400, reformat));
  // Call `reformat` 1.4 seconds after the last keyup event on the amount
  // field
  // Another keyup event cancels the current timeout, so it's really
  // 1.4 seconds after the *last* keyup event on the target element.
```

```js
H.isVoid(x)
  // returns true if x === null or x === undefined

H.isTrue(x)
  // returns true if x === true, x === 'true', or x === 'yes', case-insensitive
```


## LICENSE

MIT, see [LICENSE.txt](LICENSE.txt)


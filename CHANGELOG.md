
# h.js


## h.js 1.2.0  not yet released

* Accept H.each() .collect() .select() .reject() .inject() optional thisArg
* Accept H.map() optional thisArg
* Accept H.forEach() optional thisArg
* Go for H.setValue(sta, sel, val) and H.setv + H.set
* Alias H.t() to H.text()
* Add H.onkh(ev) for H.onKeyOrChange(ev)
* Introduce H.schedule(tArray, fun, finallyFun)
* Let H.classNot accept regular expressions
* Let H.classFrom accept regular expressions
* Introduce H.onKeyup() and H.onk()
* Let H.classFrom and .classNot fail if start/sel point to nothing
* alias H.setClass to H.flipc
* Letify
* Introduce H.eltv(sta, sel) and H.ev(sta, sel)
* Refine isFalsy() vs NaN
* Introduce H.getAtta(sta, sel, att) and H.atta()
* Introduce H.inject(array_or_hash, fun, acc)
* Introduce H.reject(array_or_hash, fun)
* Introduce H.select(array_or_hash, fun)
* Introduce H.collect(array_or_hash, fun)
* Introduce H.each(array_or_hash, fun)
* Ensure H.matches() accepts [-x] for [data-x]
* Introduce H.len() and its H.size() alias
* Introduce H.children() and H.child()
* Alias H.disabled() H.dised() to H.isDisabled()
* Split headers in res out of H.request()
* Introduce short H.onChange H.onh(sta, sel, fun)
* Introduce H.isValidEmail(s)
* Introduce H.validateEmail(s)
* Introduce H.isVisible(sta, sel)
* Introduce short H.onClick H.onc(sta, sel, fun)
* Alias H.cap to H.capitalize(string)
* Introduce H.isNotDisplayed(start, sel)
* Alias H.isHidden to .hidden and H.isHiddenUp to H.hiddenUp
* Introduce H.isHiddenUp(start, sel)
* Introduce H.width and its alias H.w (for e.offsetWidth)
* Introduce H.click and its alias H.k
* Introduce H.e and H.es aliases to H.elt and H.elts
* Introduce H.classFrom(start, sel, classNameArray)
* Ensure H.hasClass() and toElts work with an event as start
* Introduce H.toggleHidden(start, sel)
* Relax H.upload when no files and allow method other than POST
* Let prepend and postpend return the appended element
* Introduce H.reduce(start, sel, fun, initial)
* Introduce H.attj(start, sel, attname)
* Accept an Event as `sta` (start)
* Stop failing on H.create(e, '.cla', undefined)
* Let addClass and removeClass accept arrays of class names
* Introduce H.isObject(o) (false for null and arrays)
* Allow H.elt(arguments) and more
* Restrict event handler to elt (not its children) when H.on(x, 'click.', f)
* Accept arrays of elt and selectors as start or sel
* Introduce H.setAtts(start, sel, attributes)
* Allow H.elt('.that', 'keyup,change/this orthat', function(ev) {})
* Alias H.setText to H.sett
* Alias H.create to H.c
* Introduce H.filter(start, sel, function)
* Introduce H.find(start, sel, function)
* Let H.addc and H.remc accept '.class0.class1'
* Throw error when H.create(null, 'div', ...)
* Alias H.getX to H.valX
* Fail on missing eventHandler H.on
* Allow for [ elt0, elt1 ].forEach(H.hide)  :-)
* Introduce H.appendAsFirstChild(sta, sel, elt) H.appc()
* Revise H.getAtt() when double square brackets
* Introduce H.isElement() and .isElt()
* Introduce H.isInvalid() and .isValid()
* Unlock timeouts for H.request
* Add duration to request onok result
* Implement H.replace(start, sel, elt)
* Alias H.remove() to .rem() and .del()
* Alias H.setAtt() to .satt()
* Alias H.remAtt() to .ratt()
* Alias H.getAtt() to .att()
* Alias H.getAtti() and .getAttf() to .atti() and .attf()
* Accept H.create('div', { '-id': 3 }) for data-id
* Implement H.count
* Implement H.textOrValue, tov, tovb, tovi, and tovf
* Allow for multiple ev names in H.on(start, sel, evnames, fun)
* Introduce H.texti(start, sel) and H.textf(start, sel)
* Introduce H.bdim(start, sel) (bounding rect derived position from body)
* Allow giving the parent as 1st argument to H.create()
* Introduce H.getj(start, sel, default)
* Introduce H.setAtt(start, sel, aname, value)
* Fix .grow()/.makeTemplate() against non-strings
* Fix .grow()/.makeTemplate() against empty innerHTML
* Implement H.makeTemplate(f)
* Fix H.getAtti() and H.getAttf() vs "0"
* Introduce H.makeWorker()
* Introduce H.decapitalize()
* Let getAtt() and friends derive attribute name from selector
* Prevent getAtt() and friends from failing when no element
* Turn `[-x]` into `[data-x]` in H.closest() and `H.elt('^[-x]')`
* Turn `[-x]` into `[data-x]` in H.elt() and H.elts()
* Prefix '-xyz' with 'data' in getAtt(), getAtti() and getAttf()
* Introduce H.map()
* Introduce H.upload() clear: false


## h.js 1.1.1  released 2017/05/05

* Introduce H.getb(), H.getf() and H.geti()
* Introduce H.get() and H.set()
* Introduce H.text()
* Introduce H.getAtt(), .getAtti() and .getAttf()
* Grok `<a disabled="">` and `<a disabled="disabled">` in H.isDisabled()
* Introduce H.delay


## h.js 1.1.0  released 2017/01/28

* provide H.toArray(x) (mostly for arguments)
* introduce H.grow(f)


## h.js 1.0.3  released 2017/01/28

* integrate H.closest in H.elts via H.elts(sta, '^.sel .then')
* integrate H.closest in H.elt via H.elt(sta, '^.sel .then')
* implement H.path(start, sel)
* implement H.isDisabled(start, sel)
* implement H.isHidden(start, sel)
* implement H.unshow(start, sel) and H.unhide(start, sel)
* implement H.classArray(start, sel)
* implement H.postpend(start, sel, elt)
* let H.toNode() accept an optional selector
* let H.toNode(x) return x when x is not a string
* implement H.capitalize(s)
* implement H.toCamelCase(s, cap)
* implement H.classArray(start, sel)


## h.js 1.0.2  released 2016/06/17

* adopt H.matches(start, sel, pat)


## h.js 1.0.1  released 2016/05/27

* various enhancements


## h.js 1.0.0  released 2015/12/15

* initial release


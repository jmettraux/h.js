
# h.js


## h.js 1.2.0  not yet released

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


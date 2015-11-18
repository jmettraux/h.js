
VERSION:=$(shell grep VERSION src/h.js | ruby -e "puts gets.match(/VERSION = '([\d\.]+)/)[1]")

#SHA:=$(shell git log -1 --format="%H")
SHA:=$(shell git log -1 --format="%h")
NOW:=$(shell date)


v:
	@echo $(VERSION)

spec:
	bundle exec rspec

pkg_plain:
	mkdir -p pkg
	cp src/h.js pkg/h-$(VERSION).js
	echo "/* from commit $(SHA) on $(NOW) */" >> pkg/h-$(VERSION).js

pkg_mini:
	mkdir -p pkg
	printf "/* h-$(VERSION).min.js | MIT license: http://github.com/jmettraux/h.js/LICENSE.txt */" > pkg/h-$(VERSION).min.js
	java -jar tools/closure-compiler.jar --js src/h.js >> pkg/h-$(VERSION).min.js
	echo "/* minified from commit $(SHA) on $(NOW) */" >> pkg/h-$(VERSION).min.js

pkg: pkg_plain pkg_mini


.PHONY: spec pkg


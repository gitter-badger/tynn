default: test

docs: clean pages

clean:
	@rm -f docs/public/*.{html,md}

pages: $(patsubst docs/%.md, docs/public/%.html, $(wildcard docs/*.md))

docs/public/%.html: docs/%.md docs/layout.html
	@./docs/bin/build $< docs/layout.html > $@

install:
	@cat .gems | xargs gem install

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

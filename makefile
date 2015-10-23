default: test

docs: clean markdown pages rdoc

clean:
	@rm -f docs/public/api/*.html
	@rm -f docs/public/*.{html,md}

markdown: $(patsubst docs/%.md, docs/public/%.md, $(wildcard docs/*.md))

docs/public/%.md: docs/%.md
	@redcarpet --render with_toc_data --parse tables --parse fenced_code_blocks $< > $@

pages: $(patsubst docs/%.md, docs/public/%.html, $(wildcard docs/*.md))

docs/public/%.html: docs/public/%.md docs/layout.html
	@./docs/bin/build $< docs/layout.html > $@

install:
	@cat .gems | xargs gem install

publish:
	@./docs/bin/publish ./docs/public/

rdoc:
	@./docs/bin/api -o ./docs/public/api/ lib/ docs/rdoc/

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

default: test

install:
	@cat .gems | xargs gem install

pages:
	@rm -rf ./docs/public/*.html
	@rm -rf ./docs/public/guides/*.html
	@./docs/bin/page ./docs/public ./docs/*.md
	@./docs/bin/page ./docs/public/guides ./docs/guides/*.md

publish:
	@./docs/bin/publish ./docs/public/

rdoc:
	@rm -rf ./docs/public/api/*.html
	@./docs/bin/api -o ./docs/public/api/ lib/ docs/rdoc/

recipes:
	@./docs/bin/recipes ./recipes/ ./docs/public/recipes/

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs recipes test

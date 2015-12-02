default: help

s: server
t: test

help:
	@cat ./docs/tasks.txt

install:
	@gem install -g Gemfile

pages:
	@./docs/bin/page ./docs/public ./docs/*.md
	@./docs/bin/page ./docs/public/guides ./docs/guides/*.md

publish:
	@./docs/bin/publish ./docs/public/

rdoc:
	@./docs/bin/api -o ./docs/public/api/ lib/ docs/rdoc/

recipes:
	@./docs/bin/recipes ./recipes/ ./docs/public/recipes/

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs recipes test

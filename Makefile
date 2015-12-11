default: help

s: server
t: test

help:
	@cat ./docs/tasks.txt

pages:
	@./docs/bin/page ./docs/public ./docs/*.md
	@./docs/bin/page ./docs/public/guides ./docs/guides/*.md

publish:
	@./docs/bin/publish ./docs/public/

rdoc:
	@./docs/bin/api -o ./docs/public/api/ lib/ docs/rdoc/

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@./bin/cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

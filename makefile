default: test

docs: pages guides

install:
	@cat .gems | xargs gem install

pages:
	@rm -rf docs/public/*.html
	@./docs/bin/page ./docs/public ./docs/*.md

guides:
	@rm -rf docs/public/guides/*.html
	@./docs/bin/page ./docs/public/guides ./docs/guides/*.md

publish:
	@./docs/bin/publish ./docs/public/

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

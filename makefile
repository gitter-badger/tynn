default: test

docs: guides pages rdoc

guides:
	@rm -rf ./docs/public/guides/*.html
	@./docs/bin/page ./docs/public/guides ./docs/guides/*.md

pages:
	@rm -rf ./docs/public/*.html
	@./docs/bin/page ./docs/public ./docs/*.md

rdoc:
	@rm -rf ./docs/public/api/*.html
	@./docs/bin/api -o ./docs/public/api/ lib/ docs/rdoc/

publish:
	@./docs/bin/publish ./docs/public/

install:
	@cat .gems | xargs gem install

server:
	@ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

default: test

docs:
	@./docs/bin/build

install:
	@cat .gems | xargs gem install

server:
	ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: test

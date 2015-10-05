default: test

clean:
	@rm -rf ./docs/public/*.html

docs: clean
	@./docs/bin/build

install:
	@cat .gems | xargs gem install

server:
	ruby -run -e httpd ./docs/public -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: test

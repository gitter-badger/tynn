default: test

docs:
	@rdoc --markup markdown ./lib/

install:
	@cat .gems | xargs gem install

server:
	ruby -run -e httpd ./website -p 4000

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: test

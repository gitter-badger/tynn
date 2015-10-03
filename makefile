default: test

docs:
	@rdoc --markup markdown ./lib/

install:
	@cat .gems | xargs gem install

test:
	@cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: test

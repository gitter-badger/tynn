default: test

t: test

test:
	@bundle exec cutest -r ./test/helper.rb ./test/*_test.rb

.PHONY: docs test

.PHONY: tests clean test-erlang clean-erlang

help:
	@echo "tests - Run all tests"
	@echo "clean - Clean build related files

tests: test-erlang

clean: clean-erlang

test-erlang:
	cd erlang && rebar compile eunit

clean-erlang:
	cd erlang && rebar clean
	rm -rf erlang/ebin

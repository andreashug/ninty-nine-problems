.PHONY: clean

SRC=src
EBIN=ebin

all: clean tests

help:
	@echo "tests - run tests"
	@echo "clean - clean build files"

clean:
	rm -rf $(EBIN)/*

tests:
	mkdir $(EBIN)
	erlc -o $(EBIN) $(SRC)/*.erl
	erl -noshell -pa $(EBIN) \
		-eval 'eunit:test("$(EBIN)", [verbose])' \
		-s init stop

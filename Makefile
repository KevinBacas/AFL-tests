CC=clang
SRC=./src
DIST=./dist
BIN=$(DIST)/bin
AFL=./lib/afl/afl-clang
AFL_FUZZ=./lib/afl/afl-fuzz
TEST_CASE_DIR=./lib/afl/testcases/others/text/
FINDINGS_DIR=./findings

all: afl normal
	@echo "Work done!"

normal: $(BIN)/main.out
	@echo "Compiled binary with" $(CC)

$(BIN)/main.out: $(SRC)/main.c
	$(CC) $^ -O3 -o $@

afl: $(BIN)/main-afl.out
	@echo "Compiled binary with" $(AFL)

$(BIN)/main-afl.out: $(SRC)/main.c
	$(AFL) $^ -O3 -o $@

afl-test: afl
	$(AFL_FUZZ) -i $(TEST_CASE_DIR) -o $(FINDINGS_DIR) $(BIN)/main-afl.out

install:
	mkdir dist && mkdir dist/bin && findings && echo "OK" || echo "NOK"

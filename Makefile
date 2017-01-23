### thesis

all: thesis

thesis:
	./scripts/build.sh <nev>

hunspell:
	hunspell -d hu_HU -i utf-8 -t -p paper/hunspell/words paper/src/szakdolgozat.tex

install.deps:
	./scripts/install-deps.sh

install.deps.dev:
	./scripts/install-deps.sh --dev

clean:
	rm -rf build/*

dist.clean:
	rm -rf build

### code

code.fetch:
	./scripts/fetch-code.sh <repository> [<tag>]

code.remove:
	rm -rf code/<dir>

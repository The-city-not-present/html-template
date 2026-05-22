.PHONY: build init test run


build:
	./build-scripts/build.sh

build-only-static:
	./build-scripts/build.sh

init:
	./build-scripts/init.sh

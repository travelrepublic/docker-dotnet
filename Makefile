all: clean build

.PHONY:
clean: 
	rm -fR dotnet

.PHONY: build
build:
	./build.sh

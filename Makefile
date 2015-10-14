build: clean
	${GOPATH}/bin/hugo

deploy: build
	echo "todo: write deployment part of the Makefile"

clean:
	rm -fr public/*

master: build deploy

dev: build



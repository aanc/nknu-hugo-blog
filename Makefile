build: clean
	@echo
	@echo "---> Building ..."
	${GOPATH}/bin/hugo

deploy: 
	@echo
	@echo "---> Deploying ..."
	@echo "todo: write deployment part of the Makefile"

clean:
	@echo
	@echo "---> Cleaning ..."
	rm -fr public/*

master: build deploy

dev: build



#!/bin/bash

deploy() {
	echo
	echo "--> Deploying ..."
	echo "Todo: deploy to github pages"
}

build() {
	echo
	echo "--> Building ..."
	$GOPATH/bin/hugo
}

clean() {
	echo
	echo "--> Cleaning ..."
	[[ -d public ]] && rm -fr public/*
}

clean
build
[[ $TRAVIS_PULL_REQUEST == false ]] && [[ $TRAVIS_BRANCH == master ]] && deploy

echo
echo "The end."

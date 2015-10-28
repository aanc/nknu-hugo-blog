#!/bin/bash

staticSiteRepo="http://github.com/aanc/aanc.github.io.git"

deploy() {
	echo
	echo "--> Deploying to $staticSiteRepo ..."

	local commitMessage="Manual use of build.sh"

	cd public/
	if [[ -n $TRAVIS ]]; then
		git config user.name "Travis" && git config user.email travis@nknu.net
		commitMessage="Travis build #${TRAVIS_BUILD_NUMBER}"
	fi

	git status
	git add .
	git commit -m "${commitMessage}"
	git push origin master
}

build() {
	echo
	echo "--> Cloning existing site from $staticSiteRepo ..."
	git clone $staticSiteRepo public/

	echo
	echo "--> Building ..."
	$GOPATH/bin/hugo
}

clean() {
	echo
	echo "--> Cleaning ..."
	[[ -d public ]] && rm -fr public
}

[[ $1 == deploy ]] && DO_DEPLOY=yup

clean
build
if [[ $TRAVIS_PULL_REQUEST == false && $TRAVIS_BRANCH == master ]] || [[ -n $DO_DEPLOY ]]; then
	deploy
fi

echo
echo "The end."

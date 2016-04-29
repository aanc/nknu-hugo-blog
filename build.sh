#!/bin/bash

deploy() {
	echo
	echo "--> Deploying to $staticSiteRepo ..."

	local commitMessage="Manual use of build.sh"

	cd public/
	if [[ -n $TRAVIS ]]; then
		git config user.name "Travis" && git config user.email travis@nknu.net
		commitMessage="Travis build #${TRAVIS_BUILD_NUMBER}"
	fi

	set -e
	git status
	git add .
	git commit -m "${commitMessage}"
	git push --force "https://$GH_TOKEN@github.com/$targetSlug" master
	set +e
}

build() {
	echo "--> Hugo version:"
	$GOPATH/bin/hugo version
	echo
	echo "--> Cloning existing site from $staticSiteRepo ..."
	git clone http://github.com/$targetSlug public/

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

echo
env
echo
clean
build
if [[ $TRAVIS_PULL_REQUEST == false && $TRAVIS_BRANCH == master ]] || [[ -n $DO_DEPLOY ]]; then
	deploy
fi

echo
echo "The end."

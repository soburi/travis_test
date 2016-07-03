#!/bin/bash

GHREPO="https://github.com/${TRAVIS_REPO_SLUG}"
if [ "${TRAVIS_TAG}" == "" ] ; then
  PKGJSON=package_$(echo ${TRAVIS_REPO_SLUG} | sed 's/\//_/')-${TRAVIS_BRANCH}_index.json
  ARCHIVENAME=${TRAVIS_COMMIT}
  ARCHIVEURL="https://github.com/${TRAVIS_REPO_SLUG}/archive/${ARCHIVENAME}.zip"
  RELEASEVER=${TRAVIS_BRANCH}-$(ruby dist/ci_lastcommit.rb)
else
  PKGJSON=package_$(echo ${TRAVIS_REPO_SLUG} | sed 's/\//_/')_index.json
  ARCHIVENAME=$(basename ${TRAVIS_REPO_SLUG})-${TRAVIS_TAG}
  ARCHIVEURL="https://github.com/${TRAVIS_REPO_SLUG}/releases/download/${TRAVIS_TAG}/${ARCHIVENAME}.tar.bz2"
  RELEASEVER=${TRAVIS_TAG}
fi

echo GHREPO=${GHREPO}
echo ARCHIVENAME=${ARCHIVENAME}
echo ARCHIVEURL=${ARCHIVEURL}
echo PKGJSON=${PKGJSON}
echo RELEASEVER=${RELEASEVER}

echo $(git log -1 ${TRAVIS_COMMIT} --pretty=medium --format=%cd --date=format:%y)

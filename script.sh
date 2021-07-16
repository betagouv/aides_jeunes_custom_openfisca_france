#!/bin/bash

set -e

cd `dirname $0`

node index.js > branches

NEXT_PRD_BRANCH_NAME=prd_aj_`date --iso-8601=sec | sed -s 's/\+/_/g' | sed -s 's/:/_/g' | sed -s 's/-/_/g'`
TIMEBASE=$(date --date=2021-03-01 '+%s')
NOW=$(date '+%s')
VERSION=$(($NOW-$TIMEBASE))
echo $VERSION

cd openfisca-france
git reset --hard
git fetch --all
git checkout origin/master
git checkout -b $NEXT_PRD_BRANCH_NAME

# Rebase
for branch in $(cat ../branches)
do
  echo
  echo $branch

  git checkout $branch
  git reset --hard origin/$branch

  git rebase $NEXT_PRD_BRANCH_NAME

  git checkout $NEXT_PRD_BRANCH_NAME
  git reset --hard $branch
done

sed --in-place -s "s/version = .*$/version = \"52.$VERSION.0\",/g" setup.py
git commit -am "Monte la version mineur"
git push --set-upstream betagouv $NEXT_PRD_BRANCH_NAME
# git push --set-upstream betagouv prd_aj_2021-03-25T13_57_13_01_00

echo $NEXT_PRD_BRANCH_NAME

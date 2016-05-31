#!/bin/bash

rm -rf ../tmp-quocvu.github.com/*
cp -r _site/* ../tmp-quocvu.github.com
git checkout master

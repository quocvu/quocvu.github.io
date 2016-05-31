#!/bin/bash

rm -rf ../tmp-quocvu.github.io/*
cp -r _site/* ../tmp-quocvu.github.io
git checkout master

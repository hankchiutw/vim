#!/bin/bash

# grep file string under current location

TARGET=$1

grep $TARGET -nr .\
  --exclude=*.min.css\
  --exclude=*.min.js\
  --exclude=vendors.js \
  --exclude=bundle.js \
  --exclude-dir=minify\
  --exclude-dir=node_modules\
  --exclude-dir=bower_components \
  --exclude-dir=test \
  --exclude-dir=node_modules \
  --exclude-dir=.git

#!/bin/sh

# grep file string under current location

TARGET=$1

grep "$TARGET" -nr . -I \
  --exclude-dir=test \
  --exclude-dir=node_modules \
  --exclude-dir=.git \
  --exclude=vendors.js \
  --exclude=bundle.js

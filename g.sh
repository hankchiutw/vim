#!/bin/bash

# grep file string under current location

# ready to process full options user input
# e.g. To show the nearby lines too: g.sh someString -C num
grep "$@" -nrI .\
  --exclude=*.min.css\
  --exclude=*.min.js\
  --exclude=*.map\
  --exclude=*.svg\
  --exclude=vendors.js\
  --exclude=bundle.js\
  --exclude-dir=minify\
  --exclude-dir=node_modules\
  --exclude-dir=bower_components\
  --exclude-dir=test\
  --exclude-dir=node_modules\
  --exclude-dir=.git

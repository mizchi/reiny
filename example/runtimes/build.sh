#!/usr/bin/env sh

# $(npm bin)/reiny template.reiny -o template.js
$(npm bin)/reiny template.reiny -o mithril.js --target mithril
$(npm bin)/reiny template.reiny -o mercury.js --target mercury
$(npm bin)/reiny template.reiny -o react.js   --target react
browserify -t coffeeify --extension='.coffee' index.coffee -o bundle.js

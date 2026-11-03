#!/bin/sh
# Optional. If a FLEX_KEY environment variable is set on a Netlify site, bake it into index.html
# so that site always syncs that one person, with no ?u= link needed.
# With no variable set (the shared site), this does nothing.
if [ -n "$FLEX_KEY" ]; then
  KEY=$(printf '%s' "$FLEX_KEY" | tr 'A-Z' 'a-z' | tr -cd 'a-z0-9-' | cut -c1-40)
  sed -i "s|window.FLEX_KEY = '';|window.FLEX_KEY = '$KEY';|" index.html
  echo "Flex: baked key $KEY"
fi

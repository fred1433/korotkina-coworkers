#!/bin/zsh
# Rebuilds the plugin ZIP and the two skill ZIPs in dist/ (and copies them for the page in site/downloads/).
set -e
cd "${0:A:h}"
mkdir -p dist site/downloads
for f in dist/korotkina-coworkers-plugin.zip dist/custom-heirloom-inquiries.zip dist/repair-inquiries.zip; do [[ -f "$f" ]] && /bin/rm "$f"; done
zip -X -q -r dist/korotkina-coworkers-plugin.zip korotkina-coworkers -x '*.DS_Store'
(cd korotkina-coworkers/skills && zip -X -q -r ../../dist/custom-heirloom-inquiries.zip custom-heirloom-inquiries -x '*.DS_Store' && zip -X -q -r ../../dist/repair-inquiries.zip repair-inquiries -x '*.DS_Store')
cp dist/*.zip site/downloads/
shasum -a 256 dist/*.zip

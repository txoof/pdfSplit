#!/bin/bash

cat ./out.txt | zip -r ../reportSplit.zip --names-stdin
git commit -m "update app package zip file" ../reportSplit.zip
git push

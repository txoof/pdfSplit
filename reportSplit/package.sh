#!/bin/bash

zip -r ../reportSplit.zip ./ReportSplit.app/
git commit -m "update app package zip file" ../reportSplit.zip
git push

#!/usr/bin/env bash

set -e -o pipefail -u

gcloud info
DIRS=(pages courses contexts icons courseImages contentImages)
FILES=(revision authors.json companies.json)
gsutil rm -r "gs://$CONTENT_BUCKET/*"
for dir in "${DIRS[@]}"; do
  gsutil cp -r "$dir" "gs://$CONTENT_BUCKET"
done
for file in "${FILES[@]}"; do
  gsutil cp "$file" "gs://$CONTENT_BUCKET"
done

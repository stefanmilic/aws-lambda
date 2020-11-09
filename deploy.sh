#! /bin/bash

BRANCH=$1
STAGE=''

# exit when any command fails
set -e

if [ "$BRANCH" == "develop" ] ; then
  STAGE='dev'
elif [ "$BRANCH" == "master" ] ; then
  STAGE='prod'
fi

if [ ! -z "$STAGE" ] ; then
  echo "Deploying new version of pocket ciso on $STAGE"

  # echo "1. deploy aws resources"
  # npm run deploy:resources -- --stage $STAGE

  # echo "2. get cloudfront distribution domain"
  # CLOUDFRONT_DOMAIN="$(aws cloudfront list-distributions --query "DistributionList.Items[].{DomainName: DomainName, OriginDomainName: Origins.Items[0].DomainName}[?contains(OriginDomainName, '$POCKET_CISO_ASSETS_BUCKET-$STAGE')] | [0].DomainName" --out text)"
  # echo "CloudFront Domain: $CLOUDFRONT_DOMAIN"

  # echo "3. build static assets"
  # POCKET_CISO_ASSETS_URL="https://$CLOUDFRONT_DOMAIN" npm run build

  echo "4. deploy lambda/api gateway"
  sls deploy --stage $STAGE

  # echo "5. uploading static assets to $POCKET_CISO_ASSETS_BUCKET-$STAGE"
  # aws s3 sync ./.next/static/ s3://$POCKET_CISO_ASSETS_BUCKET-$STAGE/_next/static/ --delete --acl public-read --region eu-west-1
else
  echo "Stage not defined for '$BRANCH' branch, skipping..."
fi
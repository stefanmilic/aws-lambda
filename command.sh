#! /bin/bash

rm -rf dependencies-package.zip
cd nodejs
npm init -y
npm i aws-serverless-express react react-dom next
rm -rf package-lock.json
cd ..
zip -r dependencies-package.zip nodejs
echo "Delete object from S3 ..."
aws s3 rm s3://nextjs-serverless-assets/dependencies-package.zip
echo "Uploading to S3..."
aws s3 cp dependencies-package.zip s3://nextjs-serverless-assets/
echo "Creating a Layer..."
aws lambda publish-layer-version --layer-name "dependencies-layer" \
--description "Dependencies" \
--content "file://s3.json" \
--license-info "MIT" \
--compatible-runtimes "nodejs12.x"
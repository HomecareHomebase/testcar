#!/usr/bin/env bash

# This script performs the equivalent of the "Offline process by Ops" and "ADO Deployment pipeline for active directory secrets" from [here](https://hchb.visualstudio.com/HCHB/_wiki/wikis/HCHB.wiki?pagePath=%2FReference%20Architecture%2FPlatforms%20and%20Distributed%20Systems%2FData%20Operation%20Framework%2FDesign%20%7C%20Concepts%2FDB%20Authentication%20Process&wikiVersion=GBwikiMaster&pageId=50328).

mkdir -p ./temp # for holding the crypto things that the container doesn't need access to
mkdir -p ./target # mounts to "/opt/ca" in container. Currently just for crypto stuff
# Create private key. 3072 bits is considered a "high beyond 2030" level of security. See https://stackoverflow.com/a/589850
openssl genrsa -aes256 -passout "pass:correct horse battery staple" -out ./target/private.pem 3072
# Create public key from private
openssl req -x509 -days 100000 -passin "pass:correct horse battery staple" -key ./target/private.pem -out ./temp/cert.pem -subj '//C='
# Use public key to encrypt environment vars file
# "-binary" required to preserve LF EOL. MIME generally requires CRLF, so without this, EOL will be converted CRLF which breaks the env vars when imported
openssl smime -encrypt -binary -aes-256-cbc -in ./env.ord -out ./target/env.enc ./temp/cert.pem

# Finally, let's base64 encode the files. Since that's how the ADO pipeline is going to inject them, that's the way the container will expect them.
cat ./target/private.pem | base64 > ./target/private.pem.b64
rm ./target/private.pem
cat ./target/env.enc | base64 > ./target/env.enc.b64
rm ./target/env.enc

# The decryption happens inside the container, but you can test from outside using the following:
# openssl smime -decrypt -in ./target/env.enc -out ./target/env.ord -passin "pass:correct horse battery staple" -inkey ./target/private.pem
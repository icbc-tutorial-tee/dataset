#!/bin/bash
# Declare the app entrypoint
ENTRYPOINT="python3 /app/app.py"
# Declare image related variables
IMG_NAME=tee-scone-hello-world
IMG_FROM=${IMG_NAME}:temp-non-tee
IMG_TO=${IMG_NAME}:1.0.0-debug
# build the regular non-TEE image
docker build . -t ${IMG_FROM}
# Run the sconifier to build the TEE image based on the non-TEE image
docker run -it \
            -v /var/run/docker.sock:/var/run/docker.sock \
            icbcteetuto/iexec-sconify-image:5.7.5-v8 \
            sconify_iexec \
            --name=${IMG_NAME} \
            --from=${IMG_FROM} \
            --to=${IMG_TO} \
            --binary-fs \
            --fs-dir=/app \
            --host-path=/etc/hosts \
            --host-path=/etc/resolv.conf \
            --binary=/usr/local/bin/python3.7 \
            --heap=1G \
            --dlopen=1 \
            --no-color \
            --verbose \
            --command=${ENTRYPOINT} \
            && echo -e "\n------------------\n" \
            && echo "successfully built TEE docker image => ${IMG_TO}" \
            && echo "application mrenclave.fingerprint is $(docker run --rm -e SCONE_HASH=1 ${IMG_TO})"


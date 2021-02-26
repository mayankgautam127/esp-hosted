#!/bin/bash

PROJECT_DIRECTORY="esp/esp_driver/network_adapter"
DEVICE_PORT="/dev/ttyUSB0"

for arg in "$@"
do
    case $arg in
        -p|--project)
        PROJECT_DIRECTORY="$2"
        shift
        shift
        ;;
        -d|--device)
        DEVICE_PORT="$2"
        shift
        shift
        ;;
    esac
done

echo "!---Removing build files---!"
sudo rm -rf $PROJECT_DIRECTORY/build
sudo rm -rf $PROJECT_DIRECTORY/sdkconfig.*

echo "!---Compiling firmware---!"
docker run --rm -it \
    --name esp-hosted \
    --device $DEVICE_PORT \
    --volume $PWD:/home/esp-hosted \
    --workdir /home/esp-hosted/$PROJECT_DIRECTORY \
    espressif/idf:latest \
    /bin/bash -c "cd /opt/esp/idf; git mv components/protocomm/src/common/protocomm_priv.h components/protocomm/include/common/; cd /home/esp-hosted/$PROJECT_DIRECTORY; idf.py menuconfig build flash monitor -p $DEVICE_PORT"

sudo rm -rf $PROJECT_DIRECTORY/sdkconfig.*
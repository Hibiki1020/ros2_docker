#!/bin/bash

image_name='ros2'
image_tag='foxy'

docker build -t $image_name:$image_tag .
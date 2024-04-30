#!/bin/bash

# Find the path to the zau_calibration package
PACKAGE_PATH=$(rospack find zau_calibration)

# Load ROSBAG from config.yaml
ROSBAG=$(grep 'bag_file:' $PACKAGE_PATH/calibration/config.yml | cut -d':' -f2 | xargs)

# Decode environment variables
ROSBAG=$(eval echo $ROSBAG)

# Remove .bag extension
ROSBAG=${ROSBAG%.bag}

# Rename TF frames
rosrun rosbag_tools rename_tf_frames -bfi $ROSBAG.bag -bfo ${ROSBAG}_renamed.bag -ftr zau/odom zau/base_footprint -nfn world base_footprint

# Inverting TFs
rosrun rosbag_tools invert_tfs -bfi ${ROSBAG}_renamed.bag -bfo ${ROSBAG}_final.bag -t vo_body_odom_frame vo_body_pose_frame -t vo_body_pose_frame vo_body_link

# Remove renamed bag file
rm ${ROSBAG}_renamed.bag
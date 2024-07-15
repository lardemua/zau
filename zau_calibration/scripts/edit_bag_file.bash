#!/bin/bash

# Find the path to the zau_calibration package
PACKAGE_PATH=$(rospack find zau_calibration)

# Load ROSBAG from config.yaml
ROSBAG=$(grep 'bag_file:' $PACKAGE_PATH/calibration/config.yml | cut -d':' -f2 | xargs)

# Decode environment variables
ROSBAG=$(eval echo $ROSBAG)
# HOME=$(eval echo $HOME)

# Remove .bag extension
ROSBAG=${ROSBAG%.bag}

# Change camera info
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi $ROSBAG.bag -bfo ${ROSBAG}_camera_info_1.bag -ct /rgb_body_left/camera_info -y $HOME/.ros/camera_info/rgb_body_front.yaml
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi ${ROSBAG}_camera_info_1.bag -bfo ${ROSBAG}_camera_info_2.bag -ct /rgb_body_right/camera_info -y $HOME/.ros/camera_info/rgb_body_back.yaml
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi ${ROSBAG}_camera_info_2.bag -bfo ${ROSBAG}_camera_info_1.bag -ct /rgbd_hand/color/camera_info -y $HOME/.ros/camera_info/rgbd_hand_color.yaml
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi ${ROSBAG}_camera_info_1.bag -bfo ${ROSBAG}_camera_info_2.bag -ct /rgbd_hand/depth/camera_info -y $HOME/.ros/camera_info/rgbd_hand_depth.yaml
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi ${ROSBAG}_camera_info_2.bag -bfo ${ROSBAG}_camera_info_1.bag -ct /vo_body/fisheye1/camera_info -y $HOME/.ros/camera_info/t265_fisheye1.yaml
rosrun rosbag_tools config_camera_intrinsics_yaml -bfi ${ROSBAG}_camera_info_1.bag -bfo ${ROSBAG}_camera_info_2.bag -ct /vo_body/fisheye2/camera_info -y $HOME/.ros/camera_info/t265_fisheye2.yaml

# Rename TF frames
rosrun rosbag_tools rename_tf_frames -bfi ${ROSBAG}_camera_info_2.bag -bfo ${ROSBAG}_renamed.bag -ftr zau/odom zau/base_footprint -nfn world base_footprint

# Inverting TFs
rosrun rosbag_tools invert_tfs -bfi ${ROSBAG}_renamed.bag -bfo ${ROSBAG}_final.bag -t vo_body_odom_frame vo_body_pose_frame -t vo_body_pose_frame vo_body_link

# Remove unwanted bag files
rm ${ROSBAG}_renamed.bag
rm ${ROSBAG}_camera_info_1.bag
rm ${ROSBAG}_camera_info_2.bag
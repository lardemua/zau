#!/usr/bin/env python3

import os
import rospy
import yaml
from sensor_msgs.msg import CameraInfo

def camera_info_publisher():
    """
    Publishes camera information to a ROS topic.
    """
    # Initialize ROS node
    rospy.init_node('camera_info_publisher')

    # Receive camera_name parameter from ROS
    camera_name = rospy.get_param('~camera_name')
    topic_name = rospy.get_param('~topic_name')

    # Load data from file
    yaml_fname = f'{os.environ["HOME"]}/.ros/camera_info/{camera_name}.yaml'
    with open(yaml_fname, "r") as file_handle:
        calib_data = yaml.load(file_handle)

    # Parse the calibration data
    camera_info_msg = CameraInfo()
    camera_info_msg.width = calib_data["image_width"]
    camera_info_msg.height = calib_data["image_height"]
    camera_info_msg.K = calib_data["camera_matrix"]["data"]
    camera_info_msg.D = calib_data["distortion_coefficients"]["data"]
    camera_info_msg.R = calib_data["rectification_matrix"]["data"]
    camera_info_msg.P = calib_data["projection_matrix"]["data"]
    camera_info_msg.distortion_model = calib_data["distortion_model"]

    # Publish the camera info
    camera_info_pub = rospy.Publisher(topic_name, CameraInfo, queue_size=1)
    rate = rospy.Rate(10)
    while not rospy.is_shutdown():
        camera_info_pub.publish(camera_info_msg)
        rate.sleep()

if __name__ == "__main__":
    camera_info_publisher()


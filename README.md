# Zau

Repository used for calibrate the Zau mobile manipulator from INESC TEC

## Intel RealSense L515

To configure the Intel RealSense L515, please run:

```
sudo apt-get install ros-$ROS_DISTRO-realsense2-camera
```

And run the following command to define the usb rules for the camera:

```
sudo wget https://raw.githubusercontent.com/IntelRealSense/librealsense/master/config/99-realsense-libusb.rules -P /etc/udev/rules.d/
```

To start it, run:

```
roslaunch zau_bringup intel_l515_bringup.launch
```

## Astra


To use the Astra cameras, the `astra_camera` package is needed, which can be installed from https://github.com/orbbec/ros_astra_camera.git.


To launch, use:

`roslaunch zau_bringup astra.launch`

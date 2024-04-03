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


## VLP-16

To use the Velodyne Puck, please configure your ethernet connection, in this case `eth0`, with the Velodyne by:

```
sudo ifconfig eth0 192.168.3.100
sudo route add 192.168.1.203 eth0
```

and by installing:

```
sudo apt-get install ros-$ROS_DISTRO-velodyne
```

To run it, please use:

```
roslaunch zau_bringup VLP16_bringup.launch
```
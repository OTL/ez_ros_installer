# ez_ros_installer

easy ROS installer. This do below.

* install ROS
* create catkin_ws
* install catkin tools
* update ~/.bashrc

After you run this script, you can start creating your program in ~/catkin_ws/src.

## How to use

```bash
bash <(curl -s https://raw.githubusercontent.com/OTL/ez_ros_installer/master/install.sh)
```

## Options

You can set ROS distro (kinetic/lunar/...), install object (desktop-full/desktop/ros_comm/...), and
catkin workspace (default ~/catkin_ws)

```bash
bash <(curl -s https://raw.githubusercontent.com/OTL/ez_ros_installer/master/install.sh)
 -d jade -w desktop -c ~/my_catkin_ws
```

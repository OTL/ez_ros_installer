#/bin/bash -x

usage() {
    echo "Usage: $0 [-d distro] [-w what] [-c catkin_ws]" 1>&2
    echo "  for example) $0 -d indigo -w desktop-full -c ~/catkin_ws" 1>&2
    exit 1
}

DISTRO=indigo
CATKIN_WS=~/catkin_ws
WHAT=desktop-full

while getopts d:w:c: OPT
do
    case ${OPT} in
	d) DISTRO=${OPTARG}
	    ;;
	w) WHAT=${OPTARG}
	    ;;
	c) CATKIN_WS=${OPTARG}
	    ;;
	h) usage
	    ;;
    esac
done

echo "install ROS (distro=${DISTRO} what=${WHAT}) and create catkin workspace ${CATKIN_WS}, ok? ('q' to quit)"
read yes_no
if [[ "${yes_no}" == "q" ]]; then
    "quit by user"
    exit 1
fi

sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver hkp://ha.pool.sks-keyservers.net:80 --recv-key 421C365BD9FF1F717815A3895523BAEEB01FA116
sudo apt-get update
sudo apt-get install ros-"${DISTRO}"-"${WHAT}" python-rosinstall
sudo rosdep init
rosdep update

source /opt/ros/"${DISTRO}"/setup.bash

mkdir -p "${CATKIN_WS}"/src
(cd "${CATKIN_WS}"/src; catkin_init_workspace)
(cd "${CATKIN_WS}"; catkin_make)

source "${CATKIN_WS}"/devel/setup.bash

echo "source "${CATKIN_WS}"/devel/setup.bash" >> ~/.bashrc

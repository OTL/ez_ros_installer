#/bin/bash -x

usage() {
    echo "Usage: $0 [-y (skip confirmation)] [-d distro] [-w what] [-c catkin_ws] [-o(do not use catkin tools)]" 1>&2
    echo "  for example) $0 -d kinetic -w desktop-full -c ~/catkin_ws" 1>&2
    exit 1
}

# required for apt-key and scripts
which lsb_release > /dev/null
if [[ $? != 0 ]]; then
  sudo apt-get install -y lsb-release
fi

UBUNTU_VER=$(lsb_release -cs)
DISTRO=melodic

if [[ "${UBUNTU_VER}" == "focal" ]]; then
    DISTRO=noetic
fi

CATKIN_WS=~/catkin_ws
WHAT=desktop-full
CATKIN_TOOLS=true
CONFIRM=true

while getopts yhd:w:c:o OPT
do
    case ${OPT} in
	d) DISTRO=${OPTARG}
	    ;;
	w) WHAT=${OPTARG}
	    ;;
	c) CATKIN_WS=${OPTARG}
	    ;;
	o) CATKIN_TOOLS=false
        ;;
    y) CONFIRM=false
        ;;
	h) usage
	    ;;
    esac
done

echo "install ROS (distro=${DISTRO} what=${WHAT}) and create catkin workspace ${CATKIN_WS}, ok? ('q' to quit)"
if [[ ${CONFIRM} == true ]]; then
    read yes_no
    if [[ "${yes_no}" == "q" ]]; then
        "quit by user"
        exit 1
    fi
fi

sudo apt-get install -y gnupg2
sudo sh -c 'echo "deb http://packages.ros.org/ros/ubuntu $(lsb_release -sc) main" > /etc/apt/sources.list.d/ros-latest.list'
sudo apt-key adv --keyserver 'hkp://keyserver.ubuntu.com:80' --recv-key C1CF6E31E6BADE8868B172B4F42ED6FBAB17C654
sudo apt-get update

if [[ "${DISTRO}" == "noetic" ]]; then
    sudo apt-get install -y python3-rosinstall python3-catkin-tools python3-rosdep python3-osrf-pycommon
else
    sudo apt-get install -y python-rosinstall python-catkin-tools python-rosdep
fi

sudo apt-get install -y ros-"${DISTRO}"-"${WHAT}"
sudo rosdep init
rosdep update

source /opt/ros/"${DISTRO}"/setup.bash

mkdir -p "${CATKIN_WS}"/src

if [[ "${CATKIN_TOOLS}" == "true" ]]; then
    (cd "${CATKIN_WS}"; catkin build)
else
    (cd "${CATKIN_WS}"/src; catkin_init_workspace)
    (cd "${CATKIN_WS}"; catkin_make)
fi

source "${CATKIN_WS}"/devel/setup.bash

echo "source "${CATKIN_WS}"/devel/setup.bash" >> ~/.bashrc

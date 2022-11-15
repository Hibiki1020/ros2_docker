FROM ubuntu:20.04

# Using bash
SHELL ["/bin/bash", "-c"]

RUN apt-get update && apt-get install -y \
	vim \
	wget \
	unzip \
	git \
	build-essential \
    lsb-release

RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    python3-venv

RUN apt-get update && apt-get install -y locales && \
    locale-gen en_US en_US.UTF-8 && \
    update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 && \
    export LANG=en_US.UTF-8


##### UTC #####
ENV TZ=Asia/Tokyo
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

RUN apt-get install -y software-properties-common && add-apt-repository universe

RUN apt-get update && apt-get install -y curl gnupg2 lsb-release && \
    curl -sSL https://raw.githubusercontent.com/ros/rosdistro/master/ros.key  -o /usr/share/keyrings/ros-archive-keyring.gpg && \
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/ros-archive-keyring.gpg] http://packages.ros.org/ros2/ubuntu $(source /etc/os-release && echo $UBUNTU_CODENAME) main" | tee /etc/apt/sources.list.d/ros2.list > /dev/null

RUN apt-get update && apt-get upgrade

RUN apt-get install -y ros-foxy-desktop \
                python3-argcomplete \
                ros-foxy-ros-base \
                python3-argcomplete \
                ros-dev-tools

RUN echo "source /opt/ros/foxy/setup.bash" >> ~/.bashrc && \
    source ~/.bashrc

RUN mkdir -p /home/ros2_ws/src && cd /home/ros2_ws && colcon build --symlink-install && \
    source install/setup.bash && \
    echo "source /home/ros2_ws/install/setup.bash" >> ~/.bashrc && \
    echo "source /usr/share/colcon_cd/function/colcon_cd.sh" >> ~/.bashrc && \
    echo "export _colcon_cd_root=/opt/ros/foxy/" >> ~/.bashrc && \
    echo "source /usr/share/colcon_argcomplete/hook/colcon-argcomplete.bash" >> ~/.bashrc

WORKDIR /home/ros2_ws/
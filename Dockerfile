# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server sudo

# Install Python 3.11.5 and statistical libraries
RUN apt-get install -y python3-pip

RUN --mount=type=cache,target=/tmp/pip_cache pip3 install -r requirements.txt

# Set up SSH
RUN mkdir /var/run/sshd
# Add a user and give it sudo privileges
RUN useradd -rm -d /home/coder -s /bin/bash -g root -G sudo -u 1001 coder
RUN echo 'coder:coder' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# SSH login fix. Otherwise, the user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

COPY interpreter/terminal_interface/config.yaml /home/coder

RUN echo "interpreter -cf /interpreter/terminal_interface/config.yaml && %reset" >> /home/coder/.bashrc


# Expose the SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

# Use Ubuntu 22.04 as the base image
FROM ubuntu:22.04

# Update and install necessary packages
RUN apt-get update && \
    apt-get install -y openssh-server sudo

# Install Python 3.11.5 and statistical libraries
RUN apt-get install -y python3-pip && \
    pip3 install numpy scipy pandas matplotlib scikit-learn open-interpreter

# Set up SSH
RUN mkdir /var/run/sshd
RUN echo 'transmitter:transmitterPassword' | chpasswd
RUN sed -i 's/#PermitRootLogin prohibit-password/PermitRootLogin yes/' /etc/ssh/sshd_config

# Add a user and give it sudo privileges
RUN useradd -rm -d /home/transmitter -s /bin/bash -g root -G sudo -u 1001 transmitter
RUN echo 'transmitter:transmitterPassword' | chpasswd

# SSH login fix. Otherwise, the user is kicked off after login
RUN sed -i 's@session\s*required\s*pam_loginuid.so@session optional pam_loginuid.so@g' /etc/pam.d/sshd

# Expose the SSH port
EXPOSE 22

# Start SSH service
CMD ["/usr/sbin/sshd", "-D"]

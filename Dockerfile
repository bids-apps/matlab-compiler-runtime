FROM bids/base_validator

# Update system
RUN apt-get -qq update -qq && \
    apt-get -qq install -qq -y --no-install-recommends \
        unzip \
        xorg \
        wget && \
    apt-get clean && \
    rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

# Install MATLAB MCR
ENV MATLAB_VERSION R2019a
RUN mkdir /opt/mcr_install && \
    mkdir /opt/mcr && \
    wget --quiet -P /opt/mcr_install https://ssd.mathworks.com/supportfiles/downloads/R2019a/Release/9/deployment_files/installer/complete/glnxa64/MATLAB_Runtime_R2019a_Update_9_glnxa64.zip && \
    unzip -q /opt/mcr_install/*${MATLAB_VERSION}*.zip -d /opt/mcr_install && \
    cd /opt/mcr_install && mkdir save && \
    /opt/mcr_install/install -destinationFolder /opt/mcr -agreeToLicense yes -mode silent && \
    rm -rf /opt/mcr_install /tmp/*

# Configure environment
ENV MCR_VERSION v96
ENV LD_LIBRARY_PATH /opt/mcr/${MCR_VERSION}/runtime/glnxa64:/opt/mcr/${MCR_VERSION}/bin/glnxa64:/opt/mcr/${MCR_VERSION}/sys/os/glnxa64:/opt/mcr/${MCR_VERSION}/sys/opengl/lib/glnxa64
ENV MCR_INHIBIT_CTF_LOCK 1
ENV MCR_HOME /opt/mcr/${MCR_VERSION}

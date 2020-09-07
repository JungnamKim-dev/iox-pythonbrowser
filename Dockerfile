# Dockerfile
# Run your Python scripts on a Cisco IOS XE device & edit them in your web browser with Jupyter Lab.

# uncomment one of the lines to select x86 or ARM
FROM alpine:latest
#FROM arm64v8/alpine:latest

# Install and compile
RUN apk update \
&& apk add \
    ca-certificates \ 
    libstdc++ \
    python3 \
&& apk add --virtual=build_dependencies \
    cmake \
    gcc \
    g++ \
    make \
    musl-dev \
    python3-dev \
    libffi-dev \
&& python3 -m pip --no-cache-dir install pip -U \
&& python3 -m pip --no-cache-dir install \
    jupyter \
    jupyterlab \
&& apk del --purge -r build_dependencies \
&& rm -rf /var/cache/apk/* \
&& mkdir /notebooks

# Port to the Dashboard of Jupyter Lab
EXPOSE 8888

# Notebooks, etc. will be store in the /notebooks folder
# Jupyter Lab will be started by the container root, no passwords are needed for starting
ENTRYPOINT ["/usr/bin/jupyter-lab","--ip=0.0.0.0","--notebook-dir=/notebooks","--allow-root","--no-browser","--NotebookApp.token=''","--NotebookApp.password=''"]
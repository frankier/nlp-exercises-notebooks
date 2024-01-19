FROM quay.io/jupyter/minimal-notebook

### Section recommmended by CSC
USER root

ENV HOME /home/$NB_USER

RUN apt-get update \
    && apt-get install -y ssh-client less git \
    && apt-get clean

USER $NB_USER

COPY environment.yml ./

### Installing conda packages and jupyter lab extensions. 
RUN mamba env update --file environment.yml \
  && mamba clean -afy

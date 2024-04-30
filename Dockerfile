FROM quay.io/jupyter/minimal-notebook

### Section recommmended by CSC
USER root

ENV HOME /home/$NB_USER

RUN apt-get update \
    && apt-get install -y ssh-client less git \
    && apt-get clean

### Install conda packages and jupyter lab extensions.
COPY environment.yml ./

RUN mamba env update -n base --file environment.yml \
  && mamba clean -afy && rm environment.yml

### Pre-download datasets/models
RUN mkdir -p /resources/nltk /resources/huggingface /resources/transformers /resources/sklearn /resources/other
ENV NLTK_DATA /resources/nltk
#ENV TRANSFORMERS_CACHE /resources/transformers
ENV SCIKIT_LEARN_DATA /resources/sklearn

RUN /opt/conda/bin/python -c "from nltk import download; download('brown'); download('stopwords')"
RUN /opt/conda/bin/python -c 'from sklearn.datasets import fetch_20newsgroups; fetch_20newsgroups()'
#RUN /opt/conda/bin/python -c 'from datasets import load_dataset; load_dataset("wikitext", "wikitext-2-raw-v1"); load_dataset("wikitext", "wikitext-2-v1")'

### Change back to $NB_USER
USER $NB_USER

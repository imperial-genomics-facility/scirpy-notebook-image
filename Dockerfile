FROM imperialgenomicsfacility/scanpy-notebook-image:latest
LABEL maintainer="imperialgenomicsfacility"
LABEL version="0.0.1"
LABEL description="Docker image for running Scirpy based single cell analysis"
ENV NB_USER vmuser
ENV NB_UID 1000
USER $NB_USER
WORKDIR /home/$NB_USER
ENV TMPDIR=/home/$NB_USER/.tmp
ENV PATH=$PATH:/home/$NB_USER/miniconda3/bin/
RUN rm -f /home/$NB_USER/environment.yml && \
    rm -f /home/$NB_USER/Dockerfile
COPY environment.yml /home/$NB_USER/environment.yml
COPY Dockerfile /home/$NB_USER/Dockerfile
COPY examples /home/$NB_USER/examples
USER root
RUN chown ${NB_UID} /home/$NB_USER/environment.yml && \
    chown ${NB_UID} /home/$NB_USER/Dockerfile && \
    chown -R ${NB_UID} /home/$NB_USER/examples
USER $NB_USER
WORKDIR /home/$NB_USER
ENV TMPDIR=/home/$NB_USER/.tmp
RUN mkdir -p ${TMPDIR} && \
    conda update -n base -c defaults conda && \
    conda env update -q -n notebook-env --file /home/$NB_USER/environment.yml && \
    conda clean -a -y && \
    rm -rf /home/$NB_USER/.cache && \
    rm -rf /tmp/* && \
    rm -rf ${TMPDIR} && \
    mkdir -p ${TMPDIR} && \
    mkdir -p /home/$NB_USER/.cache && \
    find miniconda3/ -type f -name *.pyc -exec rm -f {} \; 
EXPOSE 8888
EXPOSE 8080
CMD [ "notebook" ]
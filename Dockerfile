# ***
# environment to compile and run the mobius project: STINGRAY
# ***
FROM mobius:2.5

# Change to the root user.
USER root

ARG DEBIAN_FRONTEND=noninteractive

# builder
COPY --from=builder:latest /usr /usr

# darep
COPY --from=darep:latest /usr /usr

# mobius projects dir
ARG MOBIUS_PROJECT=/usr/local/home/mobius/MobiusProject

RUN apt-get update \
    && apt-get -y install apt-utils  \
    && apt-get -y install lsb-base \
    && apt-get -y install gawk \
    && apt-get -y purge apt-utils \
    && apt-get -y autoremove --purge \
    && apt-get clean \
    && rm -rfv /var/lib/apt/lists/* /tmp/* /var/tmp/*

# symbolic link
RUN ln -sv /usr/bin/gawk /usr/local/bin/gawk

# the project name
ARG PROJECTNAME=DSN2020ToolCaseStudy

# the project dir
ARG THEPROJECT=$MOBIUS_PROJECT/$PROJECTNAME

# working dir
WORKDIR $MOBIUS_PROJECT

# Change to the mobius user.
USER mobius

# copy Mobius project
COPY --chown=mobius:mobius . $THEPROJECT

# the curr dir: the project
WORKDIR $THEPROJECT

# compile
RUN cd $THEPROJECT/params/src \
    && make

# make solvers: x server is required by mobius shell
RUN cd $THEPROJECT/batches \
    && export DISPLAY=:99 \
    && export DOCKER=true \
    && ( Xvfb :99 -screen 0 640x480x8 -nolisten tcp & ) \
    && ./batch_solver.sh
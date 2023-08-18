#!/bin/bash

# set up a virtual environment for python
VENV=/venv/pyvenv-3.8

python -mvenv $VENV
. "$VENV/bin/activate"

echo ". \"${VENV}/bin/activate\"" >> ~/.bashrc


# add group specific configurations
USER=djp
GRP=djp

# change the group so that user can pip install new packages
chgrp -R $GRP "${VENV}"
setfacl -R -d -m group:$GRP:rwx "${VENV}"
setfacl -R -m group:$GRP:rwx "${VENV}"

echo ". \"${VENV}/bin/activate\"" >> /home/$USER/.bashrc

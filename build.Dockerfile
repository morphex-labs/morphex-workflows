FROM nikolaik/python-nodejs:python3.9-nodejs16-bullseye

RUN apt-get update \
    && apt-get install -y sudo \
    && apt-get install axel

RUN echo pn ALL=\(root\) NOPASSWD:ALL > /etc/sudoers.d/pn \
    && chmod 0440 /etc/sudoers.d/pn

RUN chown -R 1000:1000 /home/pn/
USER pn

RUN axel -o $HOME/deployments.db https://robowoofystorage.blob.core.windows.net/deploymentsdb/deployments.db 

RUN sudo npm install -g ganache-cli@beta
RUN pip install --force --upgrade pip setuptools
RUN pip install pipx
RUN python -m pipx ensurepath --force
RUN /home/pn/.local/bin/pipx install eth-brownie==1.17

ENV VIRTUAL_ENV=/home/pn/.local/pipx/venvs
RUN python3 -m venv $VIRTUAL_ENV
ENV PATH="$VIRTUAL_ENV/bin:$PATH"

COPY requirements.txt /requirements.txt
RUN pip install -v -r requirements.txt

COPY download_compilers.py /download_compilers.py
RUN python download_compilers.py

COPY entrypoint.sh /home/pn/entrypoint.sh
RUN brownie && rm ~/.brownie/deployments.db
RUN rm -rf ~/.local/lib
RUN rm -rf ~/.cache

ENTRYPOINT [ "/home/pn/entrypoint.sh" ]
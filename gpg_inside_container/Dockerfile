FROM ubuntu:20.04

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update \
&& apt-get install gpg python3 vim -y \
&& mkdir /root/test
COPY encrypt_in_container.py /root/test/
COPY my_file_to_encrypt.md /root/test/
COPY my_pubkey.gpg /root/test/

USER root
CMD ["/bin/bash"]

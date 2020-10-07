FROM ubuntu:20.04 as builder

ENV TZ=Europe/Berlin
ENV DEBIAN_FRONTEND=noninteractive

RUN apt update && \
apt full-upgrade -y && \
apt install \
autoconf \
bison \
build-essential \
flex \
git \
wget -y && \
mkdir -p /root/git && \
mkdir -p /root/src && \
mkdir -p /root/tiny_nmap/etc && \
mkdir -p /root/tiny_nmap/lib/x86_64-linux-gnu && \
mkdir -p /root/tiny_nmap/lib64 && \
mkdir -p /root/tiny_nmap/usr/lib/x86_64-linux-gnu && \
mkdir -p /root/tiny_nmap/usr/local/share/nmap && \
cd /root/src/ && \
wget https://github.com/the-tcpdump-group/libpcap/archive/libpcap-1.10.0-bp.tar.gz && \
tar xvzf libpcap-1.10.0-bp.tar.gz && \
cd libpcap-libpcap-1.10.0-bp/ && \
./configure && \
make && \
make install && \
cd /root/src/ && \
wget https://github.com/openssl/openssl/archive/OpenSSL_1_1_1h.tar.gz && \
tar xvzf OpenSSL_1_1_1h.tar.gz && \
cd openssl-OpenSSL_1_1_1h/ && \
./config && \
make && \
make install && \
cd /root/git && \
git clone https://github.com/nmap/nmap.git && \
cd nmap/ && \
./configure --without-zenmap && \
make && \
make install && \
cp /usr/local/lib/libssl.so.1.1 /root/tiny_nmap/lib/x86_64-linux-gnu/libssl.so.1.1 && \
cp /usr/local/lib/libcrypto.so.1.1 /root/tiny_nmap/lib/x86_64-linux-gnu/libcrypto.so.1.1 && \
cp /lib/x86_64-linux-gnu/libdl.so.2 /root/tiny_nmap/lib/x86_64-linux-gnu/libdl.so.2 && \
cp /usr/lib/x86_64-linux-gnu/libstdc++.so.6 /root/tiny_nmap/usr/lib/libstdc++.so.6 && \
cp /lib/x86_64-linux-gnu/libm.so.6 /root/tiny_nmap/lib/x86_64-linux-gnu/libm.so.6 && \
cp /lib/x86_64-linux-gnu/libgcc_s.so.1 /root/tiny_nmap/lib/x86_64-linux-gnu/libgcc_s.so.1 && \
cp /lib/x86_64-linux-gnu/libc.so.6 /root/tiny_nmap/lib/x86_64-linux-gnu/libc.so.6 && \
cp /lib/x86_64-linux-gnu/libpthread.so.0 /root/tiny_nmap/lib/x86_64-linux-gnu/libpthread.so.0 && \
cp /lib64/ld-linux-x86-64.so.2 /root/tiny_nmap/lib64/ld-linux-x86-64.so.2 && \
cp /etc/services /root/tiny_nmap/etc/services && \
cp -r /usr/local/share/nmap /root/tiny_nmap/usr/local/share/

# now we will copy the needed files to run only nmap with --script support inside our containers
# can be used after successful build with
# $ docker run --rm tiny_nmap "./nmap" "-sS" "-sV" "--script" "ssl*" "-p 443" "<DNS-NAME_OR_IP-ADDRESS>"

FROM scratch
COPY --from=builder /root/tiny_nmap/ /
COPY --from=builder /root/git/nmap/nmap /
CMD ["./nmap"]

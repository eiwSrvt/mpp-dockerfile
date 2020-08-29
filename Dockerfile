FROM debian:10
RUN apt update
RUN apt install build-essential libssl-dev libz-dev git nginx -y
RUN git clone https://github.com/nagalun/multiplayerpiano-server.git /srv/mpp --recurse-submodules
WORKDIR /srv/mpp
RUN sed -i 's/umask(7)/umask(0)/' src/server.cpp
RUN cd lib/uWebSockets && patch -p1 < ../uWebSockets-unix-sockets.patch
RUN make
ADD mpp /var/www/html
ADD nginx.conf /etc/nginx/sites-available/default
CMD ["sh", "-c", "nginx && exec ./out kat 0 FF7F00 unix:/var/run/mpp.sock"]
EXPOSE 8080
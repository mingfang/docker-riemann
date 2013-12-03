FROM ubuntu
 
RUN echo 'deb http://archive.ubuntu.com/ubuntu precise main universe' > /etc/apt/sources.list && \
    echo 'deb http://archive.ubuntu.com/ubuntu precise-updates universe' >> /etc/apt/sources.list && \
    apt-get update

#Prevent daemon start during install
RUN dpkg-divert --local --rename --add /sbin/initctl && ln -s /bin/true /sbin/initctl

#Supervisord
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y supervisor && mkdir -p /var/log/supervisor
CMD ["/usr/bin/supervisord", "-n"]

#SSHD
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y openssh-server &&	mkdir /var/run/sshd && \
	echo 'root:root' |chpasswd

#Utilities
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y vim less net-tools inetutils-ping curl git telnet nmap socat dnsutils netcat

#Install Oracle Java 7
RUN echo 'deb http://ppa.launchpad.net/webupd8team/java/ubuntu precise main' > /etc/apt/sources.list.d/java.list && \
    apt-key adv --keyserver keyserver.ubuntu.com --recv-keys EEA14886 && \
    apt-get update && \
    echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | /usr/bin/debconf-set-selections && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y oracle-java7-installer

#For dashboard
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y build-essential ruby1.9.1 ruby1.9.1-dev

#Riemann
RUN wget http://aphyr.com/riemann/riemann-0.2.4.tar.bz2 && \
    tar xfj riemann-*.tar.bz2 && \
    rm riemann-*.tar.bz2 && \
    mv riemann-0.2.4 riemann

#Riemann Tools and Dashboard
RUN gem install riemann-client riemann-tools riemann-dash

#Varnish
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y varnish

#Config
ADD ./ /docker-riemann
RUN cd /docker-riemann && \
    cp supervisord.conf /etc/supervisor/conf.d/supervisord.conf && \
    sed -i -e "s|127.0.0.1|0.0.0.0|" /riemann/etc/riemann.config


EXPOSE 22 4567 5555 6081


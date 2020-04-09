FROM centos:latest
RUN yum install epel-release gcc python3-pip python3-devel wget -y
RUN mkdir -p /root/srini &&  cd /root/srini
COPY requirement.txt /root/srini
RUN pip3 install -r /root/srini/requirement.txt
COPY . /root/srini
RUN pip3 freeze Django
#COPY wait-for-postgres.sh /root/srini
RUN cd /root/srini/ && /usr/bin/python3  manage.py migrate
ENTRYPOINT [ "/usr/bin/python3", "/root/srini/manage.py", "runserver", "0.0.0.0:9000"] 

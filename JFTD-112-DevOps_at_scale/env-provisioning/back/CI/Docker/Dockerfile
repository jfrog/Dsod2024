FROM dsodmultisite.jfrog.io/training-app-docker-virtual/bitnami/tomcat:latest

ADD war/*.war /usr/local/tomcat/webapps/

EXPOSE 8080

CMD [“catalina.sh”, “run”]


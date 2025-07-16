FROM tomcat:9.0

ENV brainySecret=P@ndapinkla0
ENV domain=https://wayos.yiem.cc
#ENV domain=http://localhost:8080
#ENV domain=http://192.168.1.40

ENV facebook_apiVersion=v17.0
ENV facebook_appId=477788152679063
ENV facebook_appSecret=9e0612814221d9d51eaf8361979825a2

ENV showcaseAccountId=eoss-th
ENV showcaseBotId=welcome

# For ROOT.war

ENV storagePath=/usr/local/wayOS

COPY wayOS ${storagePath}

COPY ROOT.war /usr/local/tomcat/webapps/
COPY api.war /usr/local/tomcat/webapps/

CMD ["catalina.sh", "run"]
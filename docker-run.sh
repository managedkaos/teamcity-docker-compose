docker run --name teamcity-server-instance \
-v <path to data directory>:/data/teamcity_server/datadir \
-v <path to logs directory>:/opt/teamcity/logs \
-p <port on host>:8111 \
jetbrains/teamcity-server

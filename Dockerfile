ARG ORG
ARG PAT
ARG AGENTNAME

FROM ubuntu:20.04
RUN mkdir /tmp/buildAgent
WORKDIR /tmp/buildAgent
RUN apt update
RUN apt install wget -y
RUN apt install dos2unix -y
COPY start.sh /tmp/buildAgent/start.sh
RUN dos2unix /tmp/buildAgent/start.sh
CMD ["bash","start.sh","${ORG}","{PAT}","{AGENTNAME}"]

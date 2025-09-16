FROM nodered/node-red:latest
COPY ./settings/plc/package.json /data/package.json
RUN cd /data && npm install

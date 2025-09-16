FROM nodered/node-red:latest
COPY ./settings/scada/package.json /data/package.json
RUN cd /data && npm install

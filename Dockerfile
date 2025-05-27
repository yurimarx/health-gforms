ARG IMAGE=intersystemsdc/irishealth-community:latest
FROM $IMAGE AS builder

WORKDIR /home/irisowner/irisdev
#RUN chown ${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} /opt/irisapp

# create Python env
## Embedded Python environment
ENV IRISNAMESPACE="USER"
ENV PYTHON_PATH=/usr/irissys/bin/
ENV PATH="/usr/irissys/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/home/irisowner/bin:/home/irisowner/.local/bin"

# copy all the source into container and run iris. also run a initial script
RUN --mount=type=bind,src=.,dst=. \
    pip3 install -r requirements.txt && \
    iris start IRIS && \
    iris merge IRIS merge.cpf && \
	iris session IRIS < iris.script && \
    iris stop IRIS quietly


RUN old=http://localhost:52773/crud/_spec && \
    new=/fhirUI/irisfhir_swagger.json && \
	sed -i "s|$old|$new|g" /usr/irissys/csp/swagger-ui/index.html

FROM $IMAGE AS final

ADD --chown=${ISC_PACKAGE_MGRUSER}:${ISC_PACKAGE_IRISGROUP} https://github.com/grongierisc/iris-docker-multi-stage-script/releases/latest/download/copy-data.py /irisdev/app/copy-data.py

# COPY credentials.json /opt/irisapp/credentials.json
COPY formpatient.json /opt/irisapp/formpatient.json
COPY templates /opt/irisapp/
COPY healthgforms.py /usr/irissys/mgr/python

RUN --mount=type=bind,source=/,target=/builder/root,from=builder \
    cp -f /builder/root/usr/irissys/iris.cpf /usr/irissys/iris.cpf && \
    python3 /irisdev/app/copy-data.py -c /usr/irissys/iris.cpf -d /builder/root/
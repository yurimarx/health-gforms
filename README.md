 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/health-gforms)

# Health GForms
This is package collect data using google forms and save as resource into a FHIR Repository.


## Detailed tutorial how to install and use this app:
Go to the PDF tutorial: https://github.com/yurimarx/health-gforms/blob/master/Steps%20to%20run%20the%20app%20health-gforms.pdf 


### If you just want install into Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/health-gforms/health-gforms.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
$ docker-compose up -d
```

### If you want to install into IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install health-gforms"
```

This will install FHIR server in FHIRSERVER namespace and the health-gforms.

Or call the following for installing programmatically:
```
set sc=$zpm("install fhir-server")
```

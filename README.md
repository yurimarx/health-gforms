 [![Gitter](https://img.shields.io/badge/Available%20on-Intersystems%20Open%20Exchange-00b2a9.svg)](https://openexchange.intersystems.com/package/health-gforms)
 [![Quality Gate Status](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fhealth-gforms&metric=alert_status)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fhealth-gforms)
 [![Reliability Rating](https://community.objectscriptquality.com/api/project_badges/measure?project=intersystems_iris_community%2Fhealth-gforms&metric=reliability_rating)](https://community.objectscriptquality.com/dashboard?id=intersystems_iris_community%2Fhealth-gforms)
# Health GForms
This is package collect data using google forms and save as resource into a FHIR Repository.


## Installation

### Docker (e.g. for dev purposes)

Clone/git pull the repo into any local directory

```
$ git clone https://github.com/yurimarx/health-gforms/health-gforms.git
```

Open the terminal in this directory and run:

```
$ docker-compose build
$ docker-compose up -d
```



### IPM

Open IRIS for Health installation with IPM client installed. Call in any namespace:

```
USER>zpm "install health-gforms"
```

This will install FHIR server in FHIRSERVER namespace and the health-gforms.

Or call the following for installing programmatically:
```
set sc=$zpm("install fhir-server")
```

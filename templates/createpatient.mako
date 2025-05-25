{
    "resourceType": "Patient",
    "name": [
        {
            "use": "official",
            "given": [
                "${data['name']}"
            ],
            "family": "${data['family']}"
        }
    ],
    "gender": "${data['gender']}",
    "birthDate": "${data['birthDate']}",
    "telecom": [
        {
            "value": "${data['telecom']}",
            "use": "mobile",
            "system": "phone"
        }
    ]
}
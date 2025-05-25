Class User.Test Extends %RegisteredObject
{

Method Print() [ Language = python ]
{
    from apiclient import discovery
    import httplib2
    from oauth2client import client, file, tools
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build


    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes="https://www.googleapis.com/auth/forms.body",
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("forms", "v1", http=http)

    # Request body for creating a form
    NEW_FORM = {
        "info": {
            "title": "Quickstart form",
        }
    }

    # Request body to add a multiple-choice question
    NEW_QUESTION = {
        "requests": [
            {
                "createItem": {
                    "item": {
                        "title": (
                            "In what year did the United States land a mission on"
                            " the moon?"
                        ),
                        "questionItem": {
                            "question": {
                                "required": True,
                                "choiceQuestion": {
                                    "type": "RADIO",
                                    "options": [
                                        {"value": "1965"},
                                        {"value": "1967"},
                                        {"value": "1969"},
                                        {"value": "1971"},
                                    ],
                                    "shuffle": True,
                                },
                            }
                        },
                    },
                    "location": {"index": 0},
                }
            }
        ]
    }

    # Creates the initial form
    result = form_service.forms().create(body=NEW_FORM).execute()

    # Adds the question to the form
    question_setting = (
        form_service.forms()
        .batchUpdate(formId=result["formId"], body=NEW_QUESTION)
        .execute()
    )

    # Prints the result to show the question has been added
    get_result = form_service.forms().get(formId=result["formId"]).execute()
    print(get_result)

    print("Oi mundo")
}

}

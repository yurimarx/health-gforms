Class User.GFormsService Extends %RegisteredObject
{

ClassMethod CreateFormFromFile(formtitle As %String, filepath As %String) [ Language = python ]
{
    
    import httplib2
    import json
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build
    from mako.template import Template

    
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes=["https://www.googleapis.com/auth/forms.body", 
                "https://www.googleapis.com/auth/forms", 
                "https://www.googleapis.com/auth/drive", 
                "https://www.googleapis.com/auth/drive.file"],
    )

    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("forms", "v1", http=http)

    new_form_template = Template('{"info": {"title": "${title}"}}')
    new_form_str = new_form_template.render(title=formtitle)
    NEW_FORM = json.loads(new_form_str)

    # Create the form
    try:
        result = form_service.forms().create(body=NEW_FORM).execute()
        formid = result["formId"]
        print(f'Form created: {result}')

        with open(filepath) as file:
            itemsjson = json.loads(file.read())
            # Adds form items
            items = (
                form_service.forms()
                .batchUpdate(formId=formid, body=itemsjson)
                .execute()
            )

        permission2 = {
            'type': 'anyone',
            'role': 'writer',
        }

        drive_service = build('drive', 'v3', credentials=credentials)

        drive_service.permissions().create(fileId=formid, body=permission2).execute()

        return formid
    except Exception as e:
        print(f'Error creating form: {e}')
}

ClassMethod GetFormFromId(formid As %String) [ Language = python ]
{
    import httplib2
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

    # Prints the responses of your specified form:
    result = form_service.forms().get(formId=formid).execute()
    return result
}

ClassMethod GetResponsesFromFormId(formid As %String) [ Language = python ]
{
    import httplib2
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build

    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes="https://www.googleapis.com/auth/forms.responses.readonly",
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("forms", "v1", http=http)

    # Prints the responses of your specified form:
    result = form_service.forms().responses().list(formId=formid).execute()
    return result
}

ClassMethod GetContentFromTemplateAndResponses(formid As %String, templatepath As %String) [ Language = python ]
{
    import httplib2
    import json
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build
    from mako.template import Template

    class FormValues():
        def __init__(self, itemId, title, questionId, userResponse):
            self.itemId = itemId
            self.title = title
            self.questionId = questionId
            self.userResponse = userResponse
    
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes=["https://www.googleapis.com/auth/forms.body","https://www.googleapis.com/auth/forms.responses.readonly"],
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("forms", "v1", http=http)
    form = form_service.forms().get(formId=formid).execute()
    responses = form_service.forms().responses().list(formId=formid).execute()
    records = []

    for response in responses["responses"]:
        for item in form["items"]:
            for answer in response["answers"]:
                if response["answers"][answer]["questionId"] == item["questionItem"]["question"]["questionId"]:
                    records.append(
                        FormValues(
                            item["itemId"], 
                            item["title"], 
                            item["questionItem"]["question"]["questionId"], 
                            response["answers"][answer]["textAnswers"]["answers"][0]["value"]))
    
    
    makodata = {
            'name': '',
            'family': '',
            'birthDate': '',
            'telecom': ''
        }

    for data in records:
        if getattr(data, "title") == "Given Name":
            makodata["name"] = getattr(data,"userResponse")
        elif getattr(data, "title") == "Family Name":
            makodata["family"] = getattr(data,"userResponse")
        elif getattr(data, "title") == "Gender":
            makodata["gender"] = getattr(data,"userResponse")
        elif getattr(data, "title") == "Birth Date":
            makodata["birthDate"] = getattr(data,"userResponse")
        elif getattr(data, "title") == "Phone":
            makodata["telecom"] = getattr(data,"userResponse")

    template = Template(filename=templatepath)

    return template.render(data=makodata)

    return True
}

}

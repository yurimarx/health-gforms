Class dc.gforms.GFormsService Extends %RegisteredObject
{

ClassMethod CreateFormFromFile(formtitle As %String, filepath As %String) [ Language = python ]
{
    from apiclient import discovery
    import httplib2
    import json
    from oauth2client import client, file, tools
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build
    from mako.template import Template

    print("Create forms")
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes="https://www.googleapis.com/auth/forms.body",
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
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
        print(formid)
        print(f'Form created: {result}')

        with open(filepath) as file:
            itemsjson = json.loads(file.read())
            # Adds form items
            items = (
                form_service.forms()
                .batchUpdate(formId=formid, body=itemsjson)
                .execute()
            )
            print(items)
    except Exception as e:
        print(f'Error creating form: {e}')
}

ClassMethod PublishForm(formid As %String) [ Language = python ]
{
    from apiclient import discovery
    import httplib2
    import json
    from oauth2client import client, file, tools
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build
    
    print("Pubhish the form")
    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes="https://www.googleapis.com/auth/forms.body",
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("forms", "v1", http=http)

    # Publish the form
    try:
        result = form_service.forms().setPublishSettings(formId=formid, body={
            'publishSettings': {
                "isPublished": True,
                "isAcceptingResponses": True
            }
        }).execute()
        print(f'Form published: {result}')

        
    except Exception as e:
        print(f'Error on publish form: {e}')
}

ClassMethod GetFormFromId(formid As %String) [ Language = python ]
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

    # Prints the responses of your specified form:
    result = form_service.forms().get(formId=formid).execute()
    print(result)
}

ClassMethod SetFormPermission(formid As %String, email As %String, permission As %String) [ Language = python ]
{
    from apiclient import discovery
    import httplib2
    from oauth2client import client, file, tools
    from oauth2client.service_account import ServiceAccountCredentials
    from googleapiclient.discovery import build


    credentials = ServiceAccountCredentials.from_json_keyfile_name(
        "/opt/irisapp/credentials.json",
        scopes=['https://www.googleapis.com/auth/forms','https://www.googleapis.com/auth/drive','https://www.googleapis.com/auth/drive.file','https://www.googleapis.com/auth/forms.body'],
    )

    # Create an httplib2.Http object to handle our HTTP requests and authorize
    # it with the Credentials.
    http = httplib2.Http()
    http = credentials.authorize(http)

    form_service = build("drive", "v3", http=http)

    # Prints the responses of your specified form:
    result = form_service.permissions().update(
                fileId=formid, 
                permissionId=email, 
                body={
                    'role': permission,
                    'type': 'user',
                    'emailAddress': 'gformsiris@intersystemsiris-408923.iam.gserviceaccount.com'
                }
            ).execute()
    print(result)
}

ClassMethod GetResponsesFromFormId(formid As %String) [ Language = python ]
{
    from apiclient import discovery
    import httplib2 
    from oauth2client import client, file, tools
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
    print(result)
}

ClassMethod GetContentFromTemplateAndResponses(formid As %String, templatePath As %String) [ Language = python ]
{
    from mako.template import Template

    makoTemplate = Template(filename=templatePath)
    print(mytemplate.render())
}

}

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


class HealthGForms():

    def __init__(self, credentials_file):
        self.credentials_file = credentials_file

    def create_form_from_file(self, formtitle, filepath):

        credentials = ServiceAccountCredentials.from_json_keyfile_name(
            self.credentials_file,
            scopes="https://www.googleapis.com/auth/forms.body",
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
                return items
        except Exception as e:
            print(f'Error creating form: {e}')

    def get_form_from_id(self, formid):
        credentials = ServiceAccountCredentials.from_json_keyfile_name(
            self.credentials_file,
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
        return result
    
    def get_responses_from_form_id(self, formid):
        
        credentials = ServiceAccountCredentials.from_json_keyfile_name(
            self.credentials_file,
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
        return result

    def get_content_from_template_and_responses(self, formid, templatepath):

        form = self.get_form_from_id(formid)
        responses = self.get_responses_from_form_id(formid)
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
        
        makodata = self.prepare_to_mako(records, templatepath)
    
        template = Template(filename=templatepath)

        return template.render(data=makodata)
        
    
    def prepare_to_mako(self, formdata, templatepath):
        makodata = {
            'name': '',
            'family': '',
            'birthDate': '',
            'telecom': ''
        }

        for data in formdata:
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
        
        return makodata

        
            
    
                


    

obj = HealthGForms("credentials.json")
#result = obj.create_form_from_file(formtitle="teste2", filepath="formpatient.json")
#print(result)

#result2 = obj.get_responses_from_form_id(formid="1otnA0B_Y2_SJO04gD0k7MjbBOVH_cngAv0t86d-OLn4")
#print(result2)

#result3 = obj.get_form_from_id(formid="1otnA0B_Y2_SJO04gD0k7MjbBOVH_cngAv0t86d-OLn4")
#print(result3)

result4 = obj.get_content_from_template_and_responses(formid="1otnA0B_Y2_SJO04gD0k7MjbBOVH_cngAv0t86d-OLn4", templatepath="./templates/createpatient.mako")
print(result4)
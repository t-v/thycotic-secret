# python 3 headers, required if submitting to Ansible
from __future__ import (absolute_import, division, print_function)
__metaclass__ = type

DOCUMENTATION = """
      lookup: thycotic_secret
        author: Kim Ausloos <kim.ausloos@cegeka.com>
        version_added: "1.0"
        short_description: Look up secrets from Thycoptic Secret Server
        description:
            - This lookup uses the values in thycotic_config to connect to a thycotic server and fetch a secret
            - There is a requirement on the 'zeep' python module
"""

from ansible.errors import AnsibleError, AnsibleParserError
from ansible.module_utils._text import to_text
from ansible.plugins.lookup import LookupBase

import zeep
import json
import requests

class LookupModule(LookupBase):
  def run(self, terms, variables=None, **kwargs):
    result = {}
    thycotic_config = variables['thycotic_config']

    url = thycotic_config['url']+"/oauth2/token"
    payload = {
      'username': thycotic_config['username'],
      'password': thycotic_config['password'],
      'grant_type': 'password'
    }
    headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/x-www-form-urlencoded'
    }
    response = requests.request("POST", url, data=payload, headers=headers)
    response_json = json.loads(response.text)
    if "error" in response_json.keys():
      raise AnsibleError(response_json['error'])
    token = response_json['access_token']

    if 'folderlist' in kwargs.keys():
      return self.getFolder(token, thycotic_config['url'], kwargs['folderId'])
    elif 'folderId' in kwargs.keys():
      return self.getFolderSecrets(token, thycotic_config['url'], kwargs['folderId'])
    elif 'secretId' in kwargs.keys():
      return {
        kwargs['secretId']: self.getSingleSecret(token, thycotic_config['url'], kwargs['secretId'])
      }
    else:
      return 'Please specify folderId or secretId'


  def getSingleSecret(self, token, baseUrl, secretId):
    result_hash = {}

    client = zeep.Client(baseUrl+'/webservices/SSWebService.asmx?WSDL')
    result = client.service.GetSecret(token, secretId)
    
    secrets = zeep.helpers.serialize_object(result)
    for secret in secrets['Secret']['Items']['SecretItem']:
      key   = str(secret['FieldName'].lower())
      value = str(secret['Value'])

      result_hash[key] = value

    result_hash['secretName'] = secrets['Secret']['Name']
    result_hash['secretId'] = secretId

    return result_hash


  def getFolderSecrets(self, token, baseUrl, folderId):
    result_hash = {}

    client = zeep.Client(baseUrl+'/webservices/SSWebService.asmx?WSDL')
     
    result = client.service.SearchSecretsByFolder(
      token,
      '',
      folderId,
      False,
      False,
      False
    )
    
    secrets = zeep.helpers.serialize_object(result)

    if secrets['SecretSummaries'] is not None and len(secrets['SecretSummaries']['SecretSummary']) > 0:
      for secretSummary in secrets['SecretSummaries']['SecretSummary']:
        result_hash[secretSummary['SecretId']] = self.getSingleSecret(token, baseUrl, secretSummary['SecretId'])

    return result_hash


  def getFolder(self, token, baseUrl, folderId):
    result_hash = {}

    client = zeep.Client(baseUrl+'/webservices/SSWebService.asmx?WSDL')
     
    result = client.service.FolderGetAllChildren(
      token,
      folderId
    )

    folders = zeep.helpers.serialize_object(result)

    if folders['Folders'] is not None and len(folders['Folders']['Folder']) > 0:
      for folder in folders['Folders']['Folder']:
        result_hash[folder['Name']] = self.getFolderSecrets(token, baseUrl, folder['Id'])

    return result_hash

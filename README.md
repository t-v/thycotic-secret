Example usage:

Make sure to provide the correct PIM credentials, they are in the secrets role default variables.

Generate yaml for all secrets in PIM folder id 9153 in local folder '/Users/kima/test-output':

```
ansible-playbook generate_openshift_secrets.yml --extra-vars="destination_openshift_secret_path=/Users/kima/test-output pim_folder_id=9153"
```

Required variables:

- destination_openshift_secret_path
- pim_folder_id or pim_secret_id
- thycotic_config

```
thycotic_config:
  url: 'https://pim.cegeka.com/SecretServer'
  username: <username>
  password: <password>
```

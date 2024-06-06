#!/usr/bin/env python

from hvac import Client as HvacClient
from getpass import getpass

from py.config import VAULT_ADDR

password_file='ansible_encryption_password'

# Get users login creds
print('Login to Vault at', VAULT_ADDR)
username=input('Username: ')
password=getpass()

connection = HvacClient(url=VAULT_ADDR, verify='/etc/ssl/certs/ca-certificates.crt')

# Login
connection.auth.userpass.login(
    username=username,
    password=password
)

# Lookup our own token (may be useful later)
token = connection.auth.token.lookup_self()

# Download the token from the safe
print('Getting secrets')
response = connection.secrets.kv.v1.read_secret(
    mount_point = 'dev_secret',
    path = 'data/secrets'
)

# Write to a file
encryption_password=response['data']['data']['ansible_encryption_password']

with open(password_file, 'w') as file:
    file.write(encryption_password)
    file.close()

print('Finished writing envryption password to file')

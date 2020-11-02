#!/usr/bin/env python3

from oauth2client.service_account import ServiceAccountCredentials

import base64
import gspread
import subprocess
import os

def get_fcontent(file_to_open):
    """Load file."""
    with open(file_to_open, 'rb') as f:
        fcontent = f.read()
    return fcontent

def write_to_file(file_to_write, fcontent):
    """write file"""
    with open(file_to_write, 'wb') as f:
        f.write(fcontent)

if __name__ == '__main__':
    file_to_encrypt = 'my_file_to_encrypt.md'
    gpg_pub = 'pubkey_to_encrypt_with.gpg'
    gpg_bin = '/usr/bin/gpg'
    outfile = 'my_test_file.gpg'
    fcontent = get_fcontent(file_to_encrypt)
    fcontent_encoded = base64.b64encode(fcontent)
    print(str(len(fcontent_encoded)))
    write_to_file('my_test.file', fcontent_encoded)
    encrypted = subprocess.run([gpg_bin, '-F', gpg_pub, '-o', outfile, '-e', file_to_encrypt], encoding='utf-8', capture_output=True)
    print(str(len(outfile)))
    fcontent_encrypted = get_fcontent(outfile)
    fcontent_encrypted_encoded = base64.b64encode(fcontent_encrypted)
    print(str(len(fcontent_encrypted_encoded)))
    write_to_file('my_encryped_encoded.file', fcontent_encrypted_encoded)
    # $ cat my_encryped_encoded.file | base64 -Dd | gpg -d | head -n 10
    #gpg: "" wird als voreingestellter geheimer Signaturschlüssel benutzt
    #gpg: Ungenannter Empfänger; Versuch mit geheimen Schlüssel "" ...
    #gpg: Alles klar, wir sind der ungenannte Empfänger.
    #gpg: verschlüsselt mit RSA Schlüssel, ID 0000000000000000

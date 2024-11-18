#!/usr/bin/python3

import os
import sys
from pathlib import Path

home_dir = str(Path.home())
remote_host = 'quantum.es.f5net.com'
ssh_pub_key_path = f'{home_dir}/.ssh/id_rsa.pub'
cds_file = "cds"

def replace_cds():
    with open(cds_file, 'r') as file:
        lines = file.readlines()

    main_case_dir_input = input(f"\n>>>>What is the directory where you keep all the case folders? {home_dir}/")
    main_case_dir_replace = f"main_case_dir = \'{home_dir}/{main_case_dir_input}\'"

    username_input = input("\n>>>>>Your Quantum's username: ").strip()
    username_input_replace = f"username = \'{username_input}\'"

    for i, line in enumerate(lines):
        if line.startswith('main_case_dir ='):
            lines[i] = main_case_dir_replace.strip() + '\n'
        if line.startswith('username ='):
            lines[i] = username_input_replace + '\n'

    with open(cds_file, 'w') as file:
        file.writelines(lines)

    return username_input

def change_file_permission():
    command = f'chmod 755 {cds_file}'
    print(f"\n>>>>Changing file permission with \'{command}\'")
    os.system(command)

def install_paramiko():
    print('\n>>>>Installing Paramiko')
    result = os.system('pip3 install paramiko')
    if result == 0:
        print("Paramiko has been successfully installed.\n")
    else:
        print("Error occurred while installing Paramiko.\n")
        sys.exit(1)

def ssh_keygen():
    print("\n>>>>Creating SSH key with 'ssh-keygen'")
    print(">>>>Hit 'Enter' when prompted, all default is fine\n")
    command = "ssh-keygen"
    os.system(command)

def ssh_copy_id(username_input):
    print("\n>>>>Copy public key to Quantum with 'ssh-copy-id'\n")
    command = f"ssh-copy-id {username_input}@{remote_host}"
    os.system(command)

def main():
    username_input = replace_cds()
    change_file_permission()
    install_paramiko()
 
    if os.path.isfile(ssh_pub_key_path):
        ssh_copy_id(username_input=username_input)
    else: 
        ssh_keygen()
        ssh_copy_id(username_input=username_input)

    print('>>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<<')

if __name__ == '__main__':
    main()
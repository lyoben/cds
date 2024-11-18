#!/usr/bin/python3

import os
import sys
import paramiko
import time
from pathlib import Path

home_dir = str(Path.home())
main_case_dir = f'{home_dir}/Downloads/cases'
remote_host = 'hostname.example.com'
remote_host_port = 22
username = 'blow'
key_filename = f'{home_dir}/.ssh/id_rsa'
ssh = paramiko.SSHClient()

def sr_input():
	sr = input("Enter case number: ").strip()
	if len(sr) != 8:
		print("Invalid SR number")
		sys.exit(0)
	else:
		incoming_folder = f'/example/shares/cds/global/{sr}/INCOMING'
		case_folder = f'{main_case_dir}/{sr}'
		return incoming_folder,case_folder

def make_dir(case_folder):
	if os.path.exists(case_folder):
		print(f"{case_folder} existed!\n")
	else:
		os.mkdir(case_folder)
		print(f"{case_folder} case folder created.\n")
		
def ssh_connect():
	print(f"Connecting to {remote_host}....")
	try:    
		ssh.set_missing_host_key_policy(paramiko.AutoAddPolicy())
		ssh.load_system_host_keys()
		#ssh.connect(host, username=username, password=password)
		ssh.connect(remote_host, port=remote_host_port, username=username, look_for_keys=True, key_filename=key_filename)
	except Exception as excp:
		raise Exception(excp)
	else:
		print("\n<<<>>>=======[Connected]=======<<<>>>\n")

def input_date(incoming_folder):
	input_date = input("date: ").lower().strip()
	
	if input_date[3] == ' ':
		input_date = input_date.replace(' ', '_')
	elif '_' not in input_date:
		input_date = input_date[:3] + '_' + input_date[3:]
	else:
		input_date = input_date
	
	incoming_date = f'{incoming_folder}/{input_date}'
	return incoming_date

def progress_callback(bytes_transferred, total_bytes,filename):
	bytes_transferred_MB = bytes_transferred / (1024 * 1024)
	total_bytes_MB = total_bytes / (1024 * 1024)
	percent = (bytes_transferred / total_bytes) * 100
	sys.stdout.write(f"\r{filename:<70}{bytes_transferred_MB:.2f} MB / {total_bytes_MB:.2f} MB ({percent:.2f}%)")
	sys.stdout.flush

def download(incoming_folder, case_folder):
	sftp = ssh.open_sftp()
	incoming_date_ls = sftp.listdir(incoming_folder)
	print(f'{incoming_folder}/')
	print(*incoming_date_ls, sep = "\t")
	incoming_date = input_date(incoming_folder).strip()
	files = sftp.listdir(incoming_date)
	for filename in files:
		if not (filename.endswith('.qkview') or filename.endswith('.tar') or filename.endswith('.gz')):
			case_folder_file = f'{case_folder}/{filename}'
			file = f'{incoming_date}/{filename}'
			sftp.get(file, case_folder_file, callback=lambda bytes_transferred, total_bytes: progress_callback(bytes_transferred, total_bytes,filename))
			print()
	sftp.close()
	
def main():
	incoming_folder, case_folder = sr_input()
	make_dir(case_folder=case_folder)
	ssh_connect()
	download(incoming_folder=incoming_folder, case_folder=case_folder)
	ssh.close()

if __name__ == '__main__':
	main()

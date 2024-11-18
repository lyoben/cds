### Description

***cds*** script opens ssh session to remote file server and use sftp get to download files uploaded by customer and organise downloaded file into case subdirectory.<br>
<br>
note: currently only supports Mac/Linux users due to Windows path is different

### Usage

(1) Prompt user to input sr number<br>
(2) Create a subdirectory. Skip if folder exist.<br>
(3) Successful ssh connection<br>
(4) Prompt user to input which date folder to download from. It can handle date input in format such as 'oct19', 'oct 19' or 'oct_19'<br>
(5) Download all file and **automatically skip (will not download) file extension ending with '.qkview', '.tar', '.gz'**

```
blow@blow-Ubuntu:~/cds_demo$ cds
Enter case number: 00699712   <------------------------------------------------------- (1)
/home/blow/cds_demo/case_dir/00699712 case folder created.   <------------------------ (2)

Connecting to host.example.com....

<<<>>>=======[Connected]=======<<<>>>   <--------------------------------------------- (3)

/exaple/shares/cds/global/12345678/INCOMING/   <------------------------------------- (4)
oct_04  oct_06  oct_08  oct_09
date: oct08   <----------------------------------------------------------------------- (5)
capture_12345678_2.pcap                           22.36 MB / 22.36 MB (100.00%)   <--- (6)
capture_12345678_3.pcap                           28.88 MB / 28.88 MB (100.00%)
grep 'TLS1-3-decrypt' varlogltm.txt               0.01 MB / 0.01 MB (100.00%)
SSO_Issue_Oct-8_v2_notworking 2.har               0.03 MB / 0.03 MB (100.00%)
SSO_Issue_Oct-8_v2_working 2.har                  5.10 MB / 5.10 MB (100.00%)
```

### Setup

Download *cds* folder. It contains two files.<br>

Run the *setup.py* first.<br>
(1) Input path of your main case directory, where all the subdirectory will be created.<br>
(2) Input your Quantum's username<br>
\>\>(1) & (2) will make changes to the ***cds*** script<br>
(3) Install python Paramiko library<br>
(4) If you do not have existing ssh key pair (~/.ssh/), it genrates one. When prompted just hit 'Enter', default value is fine. This step will be skip if there is existing key (/.ssh/id_rsa.pub)<br>
(5) Copy public key to Quantum. It uses username you specified in step (2)<br>
\>\>(4) & (5) are the steps decribed [here](https://www.digitalocean.com/community/tutorials/how-to-configure-ssh-key-based-authentication-on-a-linux-server)<br>
(6) Enter your Quantum's user password<br>
<br>
note: *setup.py* can be re-run. for example if you've decided to change your main case directory


```
blow@blow-Ubuntu:~/cds_demo$ ./setup.py 

>>>>What is the directory where you keep all the case folders? /home/blow/cds_demo/case_dir   <-------------------------------- (1)

>>>>>Your remote's username: blow   <----------------------------------------------------------------------------------------- (2)

>>>>Changing file permission with 'chmod 755 cds'

>>>>Installing Paramiko   <---------------------------------------------------------------------------------------------------- (3)
/usr/lib/python3/dist-packages/secretstorage/dhcrypto.py:15: CryptographyDeprecationWarning: Python 3.6 is no longer supported by the Python core team. Therefore, support for it is deprecated in cryptography. The next release of cryptography will remove support for Python 3.6.
  from cryptography.utils import int_from_bytes
Defaulting to user installation because normal site-packages is not writeable
Requirement already satisfied: paramiko in /home/blow/.local/lib/python3.6/site-packages (3.5.0)
Requirement already satisfied: bcrypt>=3.2 in /home/blow/.local/lib/python3.6/site-packages (from paramiko) (4.0.1)
Requirement already satisfied: cryptography>=3.3 in /home/blow/.local/lib/python3.6/site-packages (from paramiko) (40.0.2)
Requirement already satisfied: pynacl>=1.5 in /home/blow/.local/lib/python3.6/site-packages (from paramiko) (1.5.0)
Requirement already satisfied: cffi>=1.12 in /home/blow/.local/lib/python3.6/site-packages (from cryptography>=3.3->paramiko) (1.15.1)
Requirement already satisfied: pycparser in /home/blow/.local/lib/python3.6/site-packages (from cffi>=1.12->cryptography>=3.3->paramiko) (2.21)
Paramiko has been successfully installed.


>>>>Creating SSH key with 'ssh-keygen'  <--------------------------------------------------------------------------------------- (4)
>>>>Hit 'Enter' when prompted, all default is fine

Generating public/private rsa key pair.
Enter file in which to save the key (/home/blow/.ssh/id_rsa): 
Enter passphrase (empty for no passphrase): 
Enter same passphrase again: 
Your identification has been saved in /home/blow/.ssh/id_rsa.
Your public key has been saved in /home/blow/.ssh/id_rsa.pub.
The key fingerprint is:
SHA256:HhsG6EPuEAPrenq5bIZX7paoHerGFFYKZHkq5ijyPzg blow@blow-Ubuntu
The key's randomart image is:
+---[RSA 2048]----+
|oo.              |
|o+ o .           |
|o B o .          |
|o* *   .         |
|*.o +   S        |
|=o o.. o +       |
|*oo*..  o        |
|.OE.=            |
|*B+*o.           |
+----[SHA256]-----+

>>>>Copy public key to Quantum with 'ssh-copy-id'  <------------------------------------------------------------------------------ (5)

/usr/bin/ssh-copy-id: INFO: Source of key(s) to be installed: "/home/blow/.ssh/id_rsa.pub"
/usr/bin/ssh-copy-id: INFO: attempting to log in with the new key(s), to filter out any that are already installed
/usr/bin/ssh-copy-id: INFO: 1 key(s) remain to be installed -- if you are prompted now it is to install the new keys
Welcome to quantum.es.f5net.com

*** AUTHORIZED USERS ONLY ***
This system provides access to critical customer data.

Use your EXAMPLE (Active Directory) credentials to log in.

This system should be available to all engineers authorized to access customer
data.  If you can't log in, and think you should be able to, please see:
    XXX

blow@host.example.com's password:  <-------------------------------------------------------------------------------------------- (6)

Number of key(s) added: 1

Now try logging into the machine, with:   "ssh 'blow@quantum.es.f5net.com'"
and check to make sure that only the key(s) you wanted were added.

>>>>>>>>>>>>>>>DONE<<<<<<<<<<<<<<<
```

### Known issues

1. You may run into this error message if you do not have Xcode installed. The easiest way is to install it from App Store.

>xcode-select: note: No developer tools were found, requesting install.


2. Our IT recently restricts privilege access (Sudo). To store the script and run it 'anywhere', you can create a new *bin* in your home directory (~/bin) and add it to the PATH environemnt variable.

```

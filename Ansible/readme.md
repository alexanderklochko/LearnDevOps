### Ansible
---------------------------------------------------------------------------------------
#### Project goals:
  - create your own inventory file in which:
    + host group: app, db;
    + for all groups - access via ssh key;
    + configurable ssh parameters and configuring Inventory - put in ansible.cfg;
  - create playbook for the next:
    1. Install apache and php on app host;
    2. Install mysql on db host;
    3. Create database-user and database;
    4. Deploy the code of the project: __[php-mysql-crud](https://github.com/FaztWeb/php-mysql-crud/blob/master/db.php)__

##### 1. SSH Forwarding

Add ssh key to the ssh-agent:
eval "$(ssh-agent -s)"
ssh-add ~/.ssh/private-ssh-key (from pair which is used for github connection);
Write `ForwardAgent=yes` under the section [ssh-connection] in `.ansible.cfg` and
fill ~/.ssh/config file in the next way:

``` sh
Host <ip address or host_name trusted host>
  ForwardAgent yes
```

After rebooting the machne we need to start ssh agent again.

##### 2. Ansible mysql_module

To avoid using `login_unix_socket` argument on each invocation you can specify the socket path
using the `socket` option in your MySQL config file (usually ~/.my.cnf) on the destination host,
for example `socket=/var/lib/mysql/mysql.sock`.

Use the command `sudo find / -type s` to find the right ocket path.

mysql_db module is not indepotent, in case of import state I used next construction:

```sh
   - name: Database exists
      mysql_db:
        name: crud
        state: present
      register: database_exists
```
Installed python3-PyMySQL packet for this module.

Create `/root/.my.cnf` file and add the next lines:
``` sh
[client]
user=root
password={{ ROPASS }}

socket=/var/lib/mysql/mysql.sock

```

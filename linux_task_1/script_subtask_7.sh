#!/bin/bash
mkdir test

     head -c "${i}"MB /dev/urandom > file1

     ln -s /home/vagrant/playground/task_7/file1 /home/vagrant/playground/task_7/test/
     ln -s /home/vagrant/playground/task_7/file1 /home/vagrant/playground/task_7/test/symlink
     ln -s /home/vagrant/playground/task_7/file1 /home/vagrant/playground/task_7/symlink
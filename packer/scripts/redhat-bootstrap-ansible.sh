#! /bin/bash

curl -s https://bootstrap.pypa.io/pip/2.7/get-pip.py -o get-pip.py

if [ -x /usr/bin/python3 ]; then
	python3 get-pip.py
	python3 -m pip install --user ansible==$ANSIBLE_VERSION
	return
fi

if [ -x /usr/bin/python ]; then
	python get-pip.py
	python -m pip install --user ansible==$ANSIBLE_VERSION
	return
fi

sudo yum install -y python3
python3 get-pip.py
python3 -m pip install --user ansible==$ANSIBLE_VERSION

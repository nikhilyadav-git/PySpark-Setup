#find all soft links
> ls -l /usr/bin/python*

#python2 as default
> ln -s /usr/bin/python2.7 /usr/bin/python  

#python3 as default
> ln -s /usr/bin/python3.7 /usr/bin/python  

# which python
/bin/python
# which python2
/bin/python2
# which python3
/bin/python3
# python2 -V
Python 2.7.18
# python3 -V
Python 3.7.10
# python -V
Python 2.7.18

#But you don't need to change your default Python to get the system to run 2.7 when you type python.
#First, you can set up a shell alias:
> alias python=/usr/local/bin/python2.7
# Type that at a prompt, or put it in your ~/.bashrc if you want the change to be persistent, and now when you type python it runs your chosen 2.7, but when some program on your system tries to run a script with /usr/bin/env python it runs the standard 2.6.
> alias python=/usr/local/bin/python2.7
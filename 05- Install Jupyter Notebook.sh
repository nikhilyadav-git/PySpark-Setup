#Install Notebook
>pip3 install notebook

#Create configration file
> python3 -m notebook --generate-config
#######################################
c = get_config()
c.NotebookApp.certfile = u'/root/certs/mycert.pem'
c.NotebookApp.ip = '*'
c.NotebookApp.open_browser = False
c.NotebookApp.port = 8888
#######################################


#Run Notebook
> python3 -m notebook

#Run Notebook as Root
> python3 -m notebook --allow-root
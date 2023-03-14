# Chakshu_cont: clone repo from github to your server


git clone https://github.com/ditissgithub/Chakshu_cont.git



# Extract the repo of chakshu

cd Chakshu_cont

mkdir -p /home/apps/chakshu

tar xvzf chakshu_backend-v2.5.tar.gz -C /home/apps 

mv -f /home/apps/chakshu_backend-v2.5/{.,}* /home/apps/chakshu/




# Build the image

docker build -t chakshu_img .



# Create conatiner using this command

 #in my case network is create_container_slurm (my bridge network on this network slurm and ldap is running)

docker run -it -d --name chakshu --hostname chakshu --network create_container_slurm --privileged -v /home/apps/chakshu/:/home/apps/chakshu/ chakshu_img /usr/sbin/init

# Go inside the container 

docker exec -it chakshu /bin/bash

###inside container run####

#run bash script 

bash /entrypoint.sh

#ask at the time of run script

Please, press ENTER to continue: ENTER

Do you accept the license terms? [yes|no]: yes

#ask for the location

Miniconda3 will now be installed into this location:
/root/miniconda3

  - Press ENTER to confirm the location
  - Press CTRL-C to abort the installation
  - Or specify a different location below

[/root/miniconda3] >>> /home/apps/chakshu/miniconda/

#ask for initialisation 

Do you wish the installer to initialize Miniconda3
by running conda init? [yes|no]
[no] >>> yes






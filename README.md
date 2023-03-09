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

docker run -it --name chakshu --hostname chakshu --network create_container_slurm --privileged -v /home/apps/chakshu/:/home/apps/chakshu/ chakshu_img /usr/sbin/init

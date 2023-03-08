# Chakshu_cont
step1.

git clone https://github.com/ditissgithub/Chakshu_cont.git

step2.

# Extract the repo of chakshu
tar xvzf chakshu_backend-v2.5.tar.gz -C /home/apps 

cd /home/apps
 
mv chakshu_backend-vX.X/ chakshu

step3. 

# Build the image

docker build -t chakshu_img .

step4.

# Create conatiner using this command

docker run -it --name chakshu --network  create_container_slurm --hostname chakshu --privileged -v /chakshu_conf/chakshu_backend-v2.5/.secret:/home/apps/chakshu/ 
-v /chakshu_conf/chakshu_backend-v2.5/:/home/apps/chakshu/ <chakshu_img> /usr/sbin/init

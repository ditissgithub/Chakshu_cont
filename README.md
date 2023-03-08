# Chakshu_cont
#create conatiner using this command

docker run -it --name chakshu --network  create_container_slurm --hostname chakshu --privileged -v /chakshu_conf/chakshu_backend-v2.5/.secret:/home/apps/chakshu/ 
-v /chakshu_conf/chakshu_backend-v2.5/:/home/apps/chakshu/ <chakshu_img> /usr/sbin/init

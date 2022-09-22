scp -i ~/.ssh/id_rsa_zcu102 ./sd_card/* root@10.10.7.1:/media/sd-mmcblk0p1/
ssh -i ~/.ssh/id_rsa_zcu102 root@10.10.7.1 "cd /media/sd-mmcblk0p1/; ./run_app.sh &> /dev/null &"

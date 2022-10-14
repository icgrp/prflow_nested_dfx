ssh -i ~/.ssh/id_rsa_zcu102 root@10.10.7.1 "cd /media/sd-mmcblk0p1/; ./run_app.sh; scp -i ~/.ssh/id_rsa result.txt dopark@10.10.7.2:/home/dopark/workspace/zcu102_tuning/prflow_nested_dfx/"

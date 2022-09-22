#! /bin/bash

scp -i ~/.ssh/id_rsa result.txt dopark@10.10.7.2:/home/dopark/workspace/zcu102_tuning/prflow_riscv/
ssh -i ~/.ssh/id_rsa dopark@10.10.7.2 "cd /home/dopark/workspace/zcu102_tuning/prflow_riscv/; make incr; make sync -j24; make all -j24; make run_on_fpga"

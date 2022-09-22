#! /bin/bash

if [[ $1 == 1 ]]; then
    ssh -i ~/.ssh/id_rsa dopark@10.10.7.2 "cd /home/dopark/workspace/zcu102_tuning/prflow_riscv/; make incr_1; make compile_single; make run_on_fpga_single"
elif [[ $1 == 2 ]]; then
    ssh -i ~/.ssh/id_rsa dopark@10.10.7.2 "cd /home/dopark/workspace/zcu102_tuning/prflow_riscv/; make incr_2; make compile_single; make run_on_fpga_single"
else
    echo "invalid winner"
fi


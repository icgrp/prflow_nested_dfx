data_transfer(Input_1, conv_out);
data_redir_m(conv_out, Output_redir_odd, Output_redir_even);

rasterization2_m(Output_redir_odd, Output_r2_odd_top, Output_r2_odd_bot,
  Output_redir_even, Output_r2_even_top, Output_r2_even_bot);

zculling_top( Output_r2_odd_top, Output_r2_even_top, Output_zcu_top);
zculling_bot(Output_r2_odd_bot, Output_r2_even_bot, Output_zcu_bot);
coloringFB_bot_m(Output_zcu_bot, Output_cfb_bot);
coloringFB_top_m(Output_zcu_top, Output_cfb_bot, Output_1);

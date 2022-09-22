
    data_transfer(Input_1, conv_out);
	  data_redir_m(conv_out, Output_redir_odd, Output_redir_even);

    t_1(Output_redir_odd, Output_redir_even, 
        Output_redir_odd_1, Output_redir_odd_2,
        Output_redir_even_1, Output_redir_even_2);

    rasterization2_m(Output_redir_odd_1, Output_r2_odd_top_1, Output_r2_odd_bot_1,
                    Output_redir_even_1, Output_r2_even_top_1, Output_r2_even_bot_1);

    rasterization2_m_test(Output_redir_odd_2, Output_r2_odd_top_2, Output_r2_odd_bot_2,
                      Output_redir_even_2, Output_r2_even_top_2, Output_r2_even_bot_2);

    tc_1_2(Output_r2_odd_top_1, Output_r2_odd_top_2, Output_r2_odd_bot_1, Output_r2_odd_bot_2,
          Output_r2_odd_top, Output_r2_odd_bot, winner_1);
    tc_2_2(Output_r2_even_top_1, Output_r2_even_top_2, Output_r2_even_bot_1, Output_r2_even_bot_2,
          Output_r2_even_top, Output_r2_even_bot, winner_2);

    tc_all_2(winner_1, winner_2, winner_3, winner_4, Output_2);

    zculling_top( Output_r2_odd_top, Output_r2_even_top, Output_zcu_top);
    zculling_bot(Output_r2_odd_bot, Output_r2_even_bot, Output_zcu_bot);
    coloringFB_bot_m(Output_zcu_bot, Output_cfb_bot);
    coloringFB_top_m(Output_zcu_top, Output_cfb_bot, Output_1);

/**********************************************************************/
/*   ____  ____                                                       */
/*  /   /\/   /                                                       */
/* /___/  \  /                                                        */
/* \   \   \/                                                       */
/*  \   \        Copyright (c) 2003-2009 Xilinx, Inc.                */
/*  /   /          All Right Reserved.                                 */
/* /---/   /\                                                         */
/* \   \  /  \                                                      */
/*  \___\/\___\                                                    */
/***********************************************************************/

#include "xsi.h"

struct XSI_INFO xsi_info;

char *IEEE_P_1242562249;
char *IEEE_P_2592010699;
char *WORK_P_2704605444;
char *STD_STANDARD;
char *WORK_P_3456861588;
char *STD_TEXTIO;
char *IEEE_P_3620187407;
char *IEEE_P_3499444699;
char *UNISIM_P_0947159679;
char *IEEE_P_0774719531;
char *IEEE_P_2717149903;
char *IEEE_P_1367372525;
char *UNISIM_P_3222816464;


int main(int argc, char **argv)
{
    xsi_init_design(argc, argv);
    xsi_register_info(&xsi_info);

    xsi_register_min_prec_unit(-12);
    work_m_10453683545318844905_0094476136_init();
    work_m_16444673850997153707_4208387965_init();
    work_m_10911242317673467744_1511225934_init();
    work_m_16541823861846354283_2073120511_init();
    ieee_p_2592010699_init();
    work_a_0734968889_3212880686_init();
    ieee_p_3499444699_init();
    ieee_p_3620187407_init();
    ieee_p_1242562249_init();
    unisim_p_0947159679_init();
    ieee_p_0774719531_init();
    std_textio_init();
    ieee_p_2717149903_init();
    ieee_p_1367372525_init();
    unisim_p_3222816464_init();
    unisim_a_0780662263_2014779070_init();
    unisim_a_0957676555_2930107152_init();
    unisim_a_2298154851_1532504268_init();
    unisim_a_1490675510_1976025627_init();
    work_a_2110949206_0912031422_init();
    work_a_1172352589_0468659574_init();
    work_p_2704605444_init();
    work_a_2346473973_3212880686_init();
    work_p_3456861588_init();
    work_a_3676136260_3212880686_init();
    work_a_3523870105_3212880686_init();


    xsi_register_tops("work_m_10911242317673467744_1511225934");
    xsi_register_tops("work_m_16541823861846354283_2073120511");

    IEEE_P_1242562249 = xsi_get_engine_memory("ieee_p_1242562249");
    IEEE_P_2592010699 = xsi_get_engine_memory("ieee_p_2592010699");
    xsi_register_ieee_std_logic_1164(IEEE_P_2592010699);
    WORK_P_2704605444 = xsi_get_engine_memory("work_p_2704605444");
    STD_STANDARD = xsi_get_engine_memory("std_standard");
    WORK_P_3456861588 = xsi_get_engine_memory("work_p_3456861588");
    STD_TEXTIO = xsi_get_engine_memory("std_textio");
    IEEE_P_3620187407 = xsi_get_engine_memory("ieee_p_3620187407");
    IEEE_P_3499444699 = xsi_get_engine_memory("ieee_p_3499444699");
    UNISIM_P_0947159679 = xsi_get_engine_memory("unisim_p_0947159679");
    IEEE_P_0774719531 = xsi_get_engine_memory("ieee_p_0774719531");
    IEEE_P_2717149903 = xsi_get_engine_memory("ieee_p_2717149903");
    IEEE_P_1367372525 = xsi_get_engine_memory("ieee_p_1367372525");
    UNISIM_P_3222816464 = xsi_get_engine_memory("unisim_p_3222816464");

    return xsi_run_simulation(argc, argv);

}

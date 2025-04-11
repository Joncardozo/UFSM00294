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

/* This file is designed for use with ISim build 0xfbc00daa */

#define XSI_HIDE_SYMBOL_SPEC true
#include "xsi.h"
#include <memory.h>
#ifdef __GNUC__
#include <stdlib.h>
#else
#include <malloc.h>
#define alloca _alloca
#endif
static const char *ng0 = "Function r_type ended without a return statement";
extern char *STD_STANDARD;



unsigned char work_p_2704605444_sub_820446905284220044_3144079362(char *t1, char *t2)
{
    char t4[24];
    char t5[16];
    unsigned char t0;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    unsigned char t10;
    char *t11;
    char *t12;
    int t13;
    unsigned int t14;
    unsigned int t15;
    char *t16;
    int t17;
    unsigned int t18;
    unsigned int t19;
    char *t20;
    unsigned char t22;
    unsigned int t23;
    char *t24;
    char *t25;

LAB0:    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 31;
    t7 = (t6 + 4U);
    *((int *)t7) = 0;
    t7 = (t6 + 8U);
    *((int *)t7) = -1;
    t8 = (0 - 31);
    t9 = (t8 * -1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t7 = (t4 + 4U);
    t10 = (t2 != 0);
    if (t10 == 1)
        goto LAB3;

LAB2:    t11 = (t4 + 12U);
    *((char **)t11) = t5;
    t12 = (t5 + 0U);
    t13 = *((int *)t12);
    t9 = (t13 - 31);
    t14 = (t9 * 1U);
    t15 = (0 + t14);
    t16 = (t2 + t15);
    t17 = (26 - 31);
    t18 = (t17 * -1);
    t18 = (t18 + 1);
    t19 = (1U * t18);
    t20 = (t1 + 3688);
    t22 = 1;
    if (t19 == 6U)
        goto LAB7;

LAB8:    t22 = 0;

LAB9:    if (t22 != 0)
        goto LAB4;

LAB6:    t0 = (unsigned char)0;

LAB1:    return t0;
LAB3:    *((char **)t7) = t2;
    goto LAB2;

LAB4:    t0 = (unsigned char)1;
    goto LAB1;

LAB5:    xsi_error(ng0);
    t0 = 0;
    goto LAB1;

LAB7:    t23 = 0;

LAB10:    if (t23 < t19)
        goto LAB11;
    else
        goto LAB9;

LAB11:    t24 = (t16 + t23);
    t25 = (t20 + t23);
    if (*((unsigned char *)t24) != *((unsigned char *)t25))
        goto LAB8;

LAB12:    t23 = (t23 + 1);
    goto LAB10;

LAB13:    goto LAB5;

LAB14:    goto LAB5;

}

unsigned char work_p_2704605444_sub_10708640508181219831_3144079362(char *t1, char *t2)
{
    char t3[128];
    char t4[24];
    char t5[16];
    char t12[8];
    unsigned char t0;
    char *t6;
    char *t7;
    int t8;
    unsigned int t9;
    char *t10;
    char *t11;
    char *t13;
    char *t14;
    char *t15;
    unsigned char t16;
    char *t17;
    char *t18;
    char *t19;
    unsigned int t20;
    unsigned int t21;
    int t22;
    int t23;
    char *t24;
    int t25;
    char *t26;
    int t28;
    char *t29;
    int t31;
    char *t32;
    int t34;
    char *t35;
    int t37;
    char *t38;
    int t40;
    char *t41;
    int t43;
    char *t44;
    int t46;
    char *t47;
    int t49;
    char *t50;
    int t52;
    char *t53;
    int t55;
    char *t56;
    int t58;
    char *t59;
    int t61;
    char *t62;
    int t64;
    char *t65;
    int t67;
    char *t68;
    int t70;
    char *t71;
    int t73;
    char *t74;
    int t76;
    char *t77;
    int t79;
    char *t80;
    int t82;
    char *t83;
    int t84;
    unsigned int t85;
    unsigned int t86;
    unsigned int t87;
    char *t88;
    int t89;
    unsigned int t90;
    unsigned int t91;
    char *t92;
    unsigned int t94;
    char *t95;
    char *t96;
    char *t97;
    char *t98;

LAB0:    t6 = (t5 + 0U);
    t7 = (t6 + 0U);
    *((int *)t7) = 31;
    t7 = (t6 + 4U);
    *((int *)t7) = 0;
    t7 = (t6 + 8U);
    *((int *)t7) = -1;
    t8 = (0 - 31);
    t9 = (t8 * -1);
    t9 = (t9 + 1);
    t7 = (t6 + 12U);
    *((unsigned int *)t7) = t9;
    t7 = (t3 + 4U);
    t10 = (t1 + 2256);
    t11 = (t7 + 88U);
    *((char **)t11) = t10;
    t13 = (t7 + 56U);
    *((char **)t13) = t12;
    xsi_type_set_default_value(t10, t12, 0);
    t14 = (t7 + 80U);
    *((unsigned int *)t14) = 1U;
    t15 = (t4 + 4U);
    t16 = (t2 != 0);
    if (t16 == 1)
        goto LAB3;

LAB2:    t17 = (t4 + 12U);
    *((char **)t17) = t5;
    t18 = (t7 + 56U);
    t19 = *((char **)t18);
    t18 = (t19 + 0);
    *((unsigned char *)t18) = (unsigned char)0;
    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 31);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t11 = (t1 + 3694);
    t22 = xsi_mem_cmp(t11, t10, 6U);
    if (t22 == 1)
        goto LAB5;

LAB28:    t14 = (t1 + 3700);
    t23 = xsi_mem_cmp(t14, t10, 6U);
    if (t23 == 1)
        goto LAB6;

LAB29:    t19 = (t1 + 3706);
    t25 = xsi_mem_cmp(t19, t10, 6U);
    if (t25 == 1)
        goto LAB7;

LAB30:    t26 = (t1 + 3712);
    t28 = xsi_mem_cmp(t26, t10, 6U);
    if (t28 == 1)
        goto LAB8;

LAB31:    t29 = (t1 + 3718);
    t31 = xsi_mem_cmp(t29, t10, 6U);
    if (t31 == 1)
        goto LAB9;

LAB32:    t32 = (t1 + 3724);
    t34 = xsi_mem_cmp(t32, t10, 6U);
    if (t34 == 1)
        goto LAB10;

LAB33:    t35 = (t1 + 3730);
    t37 = xsi_mem_cmp(t35, t10, 6U);
    if (t37 == 1)
        goto LAB11;

LAB34:    t38 = (t1 + 3736);
    t40 = xsi_mem_cmp(t38, t10, 6U);
    if (t40 == 1)
        goto LAB12;

LAB35:    t41 = (t1 + 3742);
    t43 = xsi_mem_cmp(t41, t10, 6U);
    if (t43 == 1)
        goto LAB13;

LAB36:    t44 = (t1 + 3748);
    t46 = xsi_mem_cmp(t44, t10, 6U);
    if (t46 == 1)
        goto LAB14;

LAB37:    t47 = (t1 + 3754);
    t49 = xsi_mem_cmp(t47, t10, 6U);
    if (t49 == 1)
        goto LAB15;

LAB38:    t50 = (t1 + 3760);
    t52 = xsi_mem_cmp(t50, t10, 6U);
    if (t52 == 1)
        goto LAB16;

LAB39:    t53 = (t1 + 3766);
    t55 = xsi_mem_cmp(t53, t10, 6U);
    if (t55 == 1)
        goto LAB17;

LAB40:    t56 = (t1 + 3772);
    t58 = xsi_mem_cmp(t56, t10, 6U);
    if (t58 == 1)
        goto LAB18;

LAB41:    t59 = (t1 + 3778);
    t61 = xsi_mem_cmp(t59, t10, 6U);
    if (t61 == 1)
        goto LAB19;

LAB42:    t62 = (t1 + 3784);
    t64 = xsi_mem_cmp(t62, t10, 6U);
    if (t64 == 1)
        goto LAB20;

LAB43:    t65 = (t1 + 3790);
    t67 = xsi_mem_cmp(t65, t10, 6U);
    if (t67 == 1)
        goto LAB21;

LAB44:    t68 = (t1 + 3796);
    t70 = xsi_mem_cmp(t68, t10, 6U);
    if (t70 == 1)
        goto LAB22;

LAB45:    t71 = (t1 + 3802);
    t73 = xsi_mem_cmp(t71, t10, 6U);
    if (t73 == 1)
        goto LAB23;

LAB46:    t74 = (t1 + 3808);
    t76 = xsi_mem_cmp(t74, t10, 6U);
    if (t76 == 1)
        goto LAB24;

LAB47:    t77 = (t1 + 3814);
    t79 = xsi_mem_cmp(t77, t10, 6U);
    if (t79 == 1)
        goto LAB25;

LAB48:    t80 = (t1 + 3820);
    t82 = xsi_mem_cmp(t80, t10, 6U);
    if (t82 == 1)
        goto LAB26;

LAB49:
LAB27:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)0;

LAB4:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t16 = *((unsigned char *)t10);
    t0 = t16;

LAB1:    return t0;
LAB3:    *((char **)t15) = t2;
    goto LAB2;

LAB5:    t83 = (t5 + 0U);
    t84 = *((int *)t83);
    t85 = (t84 - 5);
    t86 = (t85 * 1U);
    t87 = (0 + t86);
    t88 = (t2 + t87);
    t89 = (0 - 5);
    t90 = (t89 * -1);
    t90 = (t90 + 1);
    t91 = (1U * t90);
    t92 = (t1 + 3826);
    t16 = 1;
    if (t91 == 6U)
        goto LAB54;

LAB55:    t16 = 0;

LAB56:    if (t16 != 0)
        goto LAB51;

LAB53:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3832);
    t16 = 1;
    if (t86 == 6U)
        goto LAB62;

LAB63:    t16 = 0;

LAB64:    if (t16 != 0)
        goto LAB60;

LAB61:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3838);
    t16 = 1;
    if (t86 == 6U)
        goto LAB70;

LAB71:    t16 = 0;

LAB72:    if (t16 != 0)
        goto LAB68;

LAB69:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3844);
    t16 = 1;
    if (t86 == 6U)
        goto LAB78;

LAB79:    t16 = 0;

LAB80:    if (t16 != 0)
        goto LAB76;

LAB77:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3850);
    t16 = 1;
    if (t86 == 6U)
        goto LAB86;

LAB87:    t16 = 0;

LAB88:    if (t16 != 0)
        goto LAB84;

LAB85:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3856);
    t16 = 1;
    if (t86 == 6U)
        goto LAB94;

LAB95:    t16 = 0;

LAB96:    if (t16 != 0)
        goto LAB92;

LAB93:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3862);
    t16 = 1;
    if (t86 == 6U)
        goto LAB102;

LAB103:    t16 = 0;

LAB104:    if (t16 != 0)
        goto LAB100;

LAB101:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3868);
    t16 = 1;
    if (t86 == 6U)
        goto LAB110;

LAB111:    t16 = 0;

LAB112:    if (t16 != 0)
        goto LAB108;

LAB109:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3874);
    t16 = 1;
    if (t86 == 6U)
        goto LAB118;

LAB119:    t16 = 0;

LAB120:    if (t16 != 0)
        goto LAB116;

LAB117:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3880);
    t16 = 1;
    if (t86 == 6U)
        goto LAB126;

LAB127:    t16 = 0;

LAB128:    if (t16 != 0)
        goto LAB124;

LAB125:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3886);
    t16 = 1;
    if (t86 == 6U)
        goto LAB134;

LAB135:    t16 = 0;

LAB136:    if (t16 != 0)
        goto LAB132;

LAB133:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3892);
    t16 = 1;
    if (t86 == 6U)
        goto LAB142;

LAB143:    t16 = 0;

LAB144:    if (t16 != 0)
        goto LAB140;

LAB141:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3898);
    t16 = 1;
    if (t86 == 6U)
        goto LAB150;

LAB151:    t16 = 0;

LAB152:    if (t16 != 0)
        goto LAB148;

LAB149:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3904);
    t16 = 1;
    if (t86 == 6U)
        goto LAB158;

LAB159:    t16 = 0;

LAB160:    if (t16 != 0)
        goto LAB156;

LAB157:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3910);
    t16 = 1;
    if (t86 == 6U)
        goto LAB166;

LAB167:    t16 = 0;

LAB168:    if (t16 != 0)
        goto LAB164;

LAB165:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 5);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (0 - 5);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3916);
    t16 = 1;
    if (t86 == 6U)
        goto LAB174;

LAB175:    t16 = 0;

LAB176:    if (t16 != 0)
        goto LAB172;

LAB173:
LAB52:    goto LAB4;

LAB6:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 20);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (16 - 20);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3922);
    t16 = 1;
    if (t86 == 5U)
        goto LAB183;

LAB184:    t16 = 0;

LAB185:    if (t16 != 0)
        goto LAB180;

LAB182:
LAB181:    goto LAB4;

LAB7:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)7;
    goto LAB4;

LAB8:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)30;
    goto LAB4;

LAB9:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)8;
    goto LAB4;

LAB10:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)31;
    goto LAB4;

LAB11:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)32;
    goto LAB4;

LAB12:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)33;
    goto LAB4;

LAB13:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)34;
    goto LAB4;

LAB14:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)9;
    goto LAB4;

LAB15:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)10;
    goto LAB4;

LAB16:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)28;
    goto LAB4;

LAB17:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)27;
    goto LAB4;

LAB18:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)19;
    goto LAB4;

LAB19:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)5;
    goto LAB4;

LAB20:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)12;
    goto LAB4;

LAB21:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)13;
    goto LAB4;

LAB22:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)14;
    goto LAB4;

LAB23:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)16;
    goto LAB4;

LAB24:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)35;
    goto LAB4;

LAB25:    t6 = (t7 + 56U);
    t10 = *((char **)t6);
    t6 = (t10 + 0);
    *((unsigned char *)t6) = (unsigned char)36;
    goto LAB4;

LAB26:    t6 = (t5 + 0U);
    t8 = *((int *)t6);
    t9 = (t8 - 25);
    t20 = (t9 * 1U);
    t21 = (0 + t20);
    t10 = (t2 + t21);
    t22 = (21 - 25);
    t85 = (t22 * -1);
    t85 = (t85 + 1);
    t86 = (1U * t85);
    t11 = (t1 + 3927);
    t16 = 1;
    if (t86 == 5U)
        goto LAB192;

LAB193:    t16 = 0;

LAB194:    if (t16 != 0)
        goto LAB189;

LAB191:
LAB190:    goto LAB4;

LAB50:;
LAB51:    t97 = (t7 + 56U);
    t98 = *((char **)t97);
    t97 = (t98 + 0);
    *((unsigned char *)t97) = (unsigned char)2;
    goto LAB52;

LAB54:    t94 = 0;

LAB57:    if (t94 < t91)
        goto LAB58;
    else
        goto LAB56;

LAB58:    t95 = (t88 + t94);
    t96 = (t92 + t94);
    if (*((unsigned char *)t95) != *((unsigned char *)t96))
        goto LAB55;

LAB59:    t94 = (t94 + 1);
    goto LAB57;

LAB60:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)3;
    goto LAB52;

LAB62:    t87 = 0;

LAB65:    if (t87 < t86)
        goto LAB66;
    else
        goto LAB64;

LAB66:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB63;

LAB67:    t87 = (t87 + 1);
    goto LAB65;

LAB68:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)4;
    goto LAB52;

LAB70:    t87 = 0;

LAB73:    if (t87 < t86)
        goto LAB74;
    else
        goto LAB72;

LAB74:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB71;

LAB75:    t87 = (t87 + 1);
    goto LAB73;

LAB76:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)6;
    goto LAB52;

LAB78:    t87 = 0;

LAB81:    if (t87 < t86)
        goto LAB82;
    else
        goto LAB80;

LAB82:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB79;

LAB83:    t87 = (t87 + 1);
    goto LAB81;

LAB84:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)11;
    goto LAB52;

LAB86:    t87 = 0;

LAB89:    if (t87 < t86)
        goto LAB90;
    else
        goto LAB88;

LAB90:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB87;

LAB91:    t87 = (t87 + 1);
    goto LAB89;

LAB92:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)18;
    goto LAB52;

LAB94:    t87 = 0;

LAB97:    if (t87 < t86)
        goto LAB98;
    else
        goto LAB96;

LAB98:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB95;

LAB99:    t87 = (t87 + 1);
    goto LAB97;

LAB100:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)15;
    goto LAB52;

LAB102:    t87 = 0;

LAB105:    if (t87 < t86)
        goto LAB106;
    else
        goto LAB104;

LAB106:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB103;

LAB107:    t87 = (t87 + 1);
    goto LAB105;

LAB108:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)37;
    goto LAB52;

LAB110:    t87 = 0;

LAB113:    if (t87 < t86)
        goto LAB114;
    else
        goto LAB112;

LAB114:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB111;

LAB115:    t87 = (t87 + 1);
    goto LAB113;

LAB116:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)20;
    goto LAB52;

LAB118:    t87 = 0;

LAB121:    if (t87 < t86)
        goto LAB122;
    else
        goto LAB120;

LAB122:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB119;

LAB123:    t87 = (t87 + 1);
    goto LAB121;

LAB124:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)21;
    goto LAB52;

LAB126:    t87 = 0;

LAB129:    if (t87 < t86)
        goto LAB130;
    else
        goto LAB128;

LAB130:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB127;

LAB131:    t87 = (t87 + 1);
    goto LAB129;

LAB132:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)22;
    goto LAB52;

LAB134:    t87 = 0;

LAB137:    if (t87 < t86)
        goto LAB138;
    else
        goto LAB136;

LAB138:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB135;

LAB139:    t87 = (t87 + 1);
    goto LAB137;

LAB140:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)23;
    goto LAB52;

LAB142:    t87 = 0;

LAB145:    if (t87 < t86)
        goto LAB146;
    else
        goto LAB144;

LAB146:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB143;

LAB147:    t87 = (t87 + 1);
    goto LAB145;

LAB148:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)24;
    goto LAB52;

LAB150:    t87 = 0;

LAB153:    if (t87 < t86)
        goto LAB154;
    else
        goto LAB152;

LAB154:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB151;

LAB155:    t87 = (t87 + 1);
    goto LAB153;

LAB156:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)25;
    goto LAB52;

LAB158:    t87 = 0;

LAB161:    if (t87 < t86)
        goto LAB162;
    else
        goto LAB160;

LAB162:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB159;

LAB163:    t87 = (t87 + 1);
    goto LAB161;

LAB164:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)26;
    goto LAB52;

LAB166:    t87 = 0;

LAB169:    if (t87 < t86)
        goto LAB170;
    else
        goto LAB168;

LAB170:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB167;

LAB171:    t87 = (t87 + 1);
    goto LAB169;

LAB172:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)38;
    goto LAB52;

LAB174:    t87 = 0;

LAB177:    if (t87 < t86)
        goto LAB178;
    else
        goto LAB176;

LAB178:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB175;

LAB179:    t87 = (t87 + 1);
    goto LAB177;

LAB180:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)29;
    goto LAB181;

LAB183:    t87 = 0;

LAB186:    if (t87 < t86)
        goto LAB187;
    else
        goto LAB185;

LAB187:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB184;

LAB188:    t87 = (t87 + 1);
    goto LAB186;

LAB189:    t19 = (t7 + 56U);
    t24 = *((char **)t19);
    t19 = (t24 + 0);
    *((unsigned char *)t19) = (unsigned char)17;
    goto LAB190;

LAB192:    t87 = 0;

LAB195:    if (t87 < t86)
        goto LAB196;
    else
        goto LAB194;

LAB196:    t14 = (t10 + t87);
    t18 = (t11 + t87);
    if (*((unsigned char *)t14) != *((unsigned char *)t18))
        goto LAB193;

LAB197:    t87 = (t87 + 1);
    goto LAB195;

LAB198:;
}

unsigned char work_p_2704605444_sub_11464077603099734721_3144079362(char *t1, unsigned char t2)
{
    char t3[128];
    char t4[8];
    char t8[8];
    unsigned char t0;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned char t15;
    static char *nl0[] = {&&LAB4, &&LAB4, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB4, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB4, &&LAB4, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB4, &&LAB4, &&LAB4, &&LAB3};

LAB0:    t5 = (t3 + 4U);
    t6 = ((STD_STANDARD) + 0);
    t7 = (t5 + 88U);
    *((char **)t7) = t6;
    t9 = (t5 + 56U);
    *((char **)t9) = t8;
    xsi_type_set_default_value(t6, t8, 0);
    t10 = (t5 + 80U);
    *((unsigned int *)t10) = 1U;
    t11 = (t4 + 4U);
    *((unsigned char *)t11) = t2;
    t12 = (char *)((nl0) + t2);
    goto **((char **)t12);

LAB2:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t15 = *((unsigned char *)t7);
    t0 = t15;

LAB1:    return t0;
LAB3:    t13 = (t5 + 56U);
    t14 = *((char **)t13);
    t13 = (t14 + 0);
    *((unsigned char *)t13) = (unsigned char)1;
    goto LAB2;

LAB4:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    *((unsigned char *)t6) = (unsigned char)0;
    goto LAB2;

LAB5:;
}

unsigned char work_p_2704605444_sub_6510089880958369715_3144079362(char *t1, unsigned char t2)
{
    char t3[128];
    char t4[8];
    char t8[8];
    unsigned char t0;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned char t15;
    static char *nl0[] = {&&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB3, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB3, &&LAB3, &&LAB3, &&LAB3, &&LAB4, &&LAB4, &&LAB4, &&LAB4};

LAB0:    t5 = (t3 + 4U);
    t6 = ((STD_STANDARD) + 0);
    t7 = (t5 + 88U);
    *((char **)t7) = t6;
    t9 = (t5 + 56U);
    *((char **)t9) = t8;
    xsi_type_set_default_value(t6, t8, 0);
    t10 = (t5 + 80U);
    *((unsigned int *)t10) = 1U;
    t11 = (t4 + 4U);
    *((unsigned char *)t11) = t2;
    t12 = (char *)((nl0) + t2);
    goto **((char **)t12);

LAB2:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t15 = *((unsigned char *)t7);
    t0 = t15;

LAB1:    return t0;
LAB3:    t13 = (t5 + 56U);
    t14 = *((char **)t13);
    t13 = (t14 + 0);
    *((unsigned char *)t13) = (unsigned char)1;
    goto LAB2;

LAB4:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    *((unsigned char *)t6) = (unsigned char)0;
    goto LAB2;

LAB5:;
}

unsigned char work_p_2704605444_sub_190402229932285088_3144079362(char *t1, unsigned char t2)
{
    char t3[128];
    char t4[8];
    char t8[8];
    unsigned char t0;
    char *t5;
    char *t6;
    char *t7;
    char *t9;
    char *t10;
    char *t11;
    char *t12;
    char *t13;
    char *t14;
    unsigned char t15;
    static char *nl0[] = {&&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB3, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB4, &&LAB3, &&LAB3, &&LAB4, &&LAB4};

LAB0:    t5 = (t3 + 4U);
    t6 = ((STD_STANDARD) + 0);
    t7 = (t5 + 88U);
    *((char **)t7) = t6;
    t9 = (t5 + 56U);
    *((char **)t9) = t8;
    xsi_type_set_default_value(t6, t8, 0);
    t10 = (t5 + 80U);
    *((unsigned int *)t10) = 1U;
    t11 = (t4 + 4U);
    *((unsigned char *)t11) = t2;
    t12 = (char *)((nl0) + t2);
    goto **((char **)t12);

LAB2:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t15 = *((unsigned char *)t7);
    t0 = t15;

LAB1:    return t0;
LAB3:    t13 = (t5 + 56U);
    t14 = *((char **)t13);
    t13 = (t14 + 0);
    *((unsigned char *)t13) = (unsigned char)1;
    goto LAB2;

LAB4:    t6 = (t5 + 56U);
    t7 = *((char **)t6);
    t6 = (t7 + 0);
    *((unsigned char *)t6) = (unsigned char)0;
    goto LAB2;

LAB5:;
}


extern void work_p_2704605444_init()
{
	static char *se[] = {(void *)work_p_2704605444_sub_820446905284220044_3144079362,(void *)work_p_2704605444_sub_10708640508181219831_3144079362,(void *)work_p_2704605444_sub_11464077603099734721_3144079362,(void *)work_p_2704605444_sub_6510089880958369715_3144079362,(void *)work_p_2704605444_sub_190402229932285088_3144079362};
	xsi_register_didat("work_p_2704605444", "isim/MIPS_FPGA_TEST_isim_beh.exe.sim/work/p_2704605444.didat");
	xsi_register_subprogram_executes(se);
}

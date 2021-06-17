#ifndef _BSP_RTC_H
#define _BSP_RTC_H
#include "imx6ul.h"
/*
 * IMX6UL RTC驱动文件
 * 作者:左忠凯
 */

#define SECONDS_IN_A_DAY 		(86400) //一天86400秒
#define SECONDS_IN_A_HOUR 		(3600)	//一个小时3600秒
#define SECONDS_IN_A_MINUTE 	(60)	//一分钟60秒
#define DAYS_IN_A_YEAR 			(365)	//一年365天
#define YEAR_RANGE_START 		(1970)	//开始年份1970年
#define YEAR_RANGE_END 			(2099)	//结束年份2099年 


//时间日期结构体
struct rtc_datetime
{
    unsigned short year;  /* 范围为:1970 ~ 2099 		*/
    unsigned char month;  /* 范围为:1 ~ 12				*/
    unsigned char day;    /* 范围为:1 ~ 31 (不同的月，天数不同).*/
    unsigned char hour;   /* 范围为:0 ~ 23 			*/
    unsigned char minute; /* 范围为:0 ~ 59				*/
    unsigned char second; /* 范围为:0 ~ 59				*/
};



void rtc_init(void);
void rtc_enable(void);
void rtc_disable(void);
unsigned int rtc_coverDateToSeconds(struct rtc_datetime *datetime);
unsigned int rtc_getSeconds(void);

void rtc_setDatetime(struct rtc_datetime *datetime);
void rtc_getDateTime(struct rtc_datetime *datetime);

void SNVS_HP_RTC_GetDatetime(SNVS_Type *base, struct rtc_datetime *datetime);


#endif

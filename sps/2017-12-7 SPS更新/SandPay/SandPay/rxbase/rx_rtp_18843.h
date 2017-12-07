/***********************************************
*描述:RX传输协议(Transfer Protocol)[编号:18843]
*版本:v1.0(2010-04-19)
*审核:邢子文核准
*说明:
-协议说明
1)各域属性
标识符	说明						格式		字节数	值
STX		开始标志(Start of TeXt)	HEX		1		0x02
LEN		数据长度(LENgth)			BCD		2
VER		通讯版本号(comm VERsion)	HEX		1
DATA	数据域(DATA)				HEX		N
ETX		结束标志(End of TeXt)	HEX		1		0x03
LRC		纵向冗余校验(LRC)			HEX		1
2)其他说明
LEN:统计范围[VER,LRC]
LRC:校验范围[VER,ETX],校验初始值:0x00
***********************************************/

#ifndef RX_RTP_18843_H
#define RX_RTP_18843_H

//Macro
/***********************************************
[描述]协议操作函数返回值
***********************************************/
#define RX_RTP_18843_ERROR		-1		//错误
#define RX_RTP_18843_NORMAL		0		//正常
#define RX_RTP_18843_PENDING	1		//待决


//Function:rx_Rtp_18843_Generate
/***********************************************
[描述]产生协议
[参数]
<in>	ver			子协议版本
<in>	data		DATA数据域
<in>	data_len	data长度
<out>	prtcl		协议
<out>	prtcl_len	协议长度
[返值]
成功返回RX_RTP_18843_NORMAL
失败返回RX_RTP_18843_ERROR
***********************************************/
int
STDCALL
rx_Rtp_18843_Generate
(const BYTE ver, const BYTE* data, const int data_len,
BYTE* prtcl, int* prtcl_len);


//Function:rx_Rtp_18843_Resolve
/***********************************************
[描述]解析协议
[说明]本函数仅解析第一个符合协议的数据,并报告已解析的数据长度
[参数]
<in>	prtcl		协议
<in>	prtcl_len	协议长度
<out>	ver			子协议版本
<out>	data		DATA数据域
<out>	data_len	data长度
<out>	expend_len	已解析的长度
[返值]
成功返回RX_RTP_18843_NORMAL
成功但尚存在未处理的数据时返回RX_RTP_18843_PENDING
失败返回RX_RTP_18843_ERROR
***********************************************/
int
STDCALL
rx_Rtp_18843_Resolve
(const BYTE* prtcl, const int prtcl_len,
BYTE* ver, BYTE* data, int* data_len, int* expend_len);


#endif

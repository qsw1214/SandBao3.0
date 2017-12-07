/***********************************************
*描述:RX传输协议(Transfer Protocol)[编号:193]
*版本:v1.0(2010-04-22)
*审核:邢子文核准
*说明:
-协议说明
1)各域属性
标识符	说明						格式		字节数
APP		应用号(APPlication)		HEX		1
ETF		扩展标志(ExTend Flag)	HEX		1
DATA	数据域(DATA)				HEX		N
2)其他说明
ETF=0x01表示DATA不完整有后续扩展数据
ETF=0x00表示DATA完整无后续扩展数据
***********************************************/

#ifndef RX_RTP_193_H
#define RX_RTP_193_H

//Macro
/***********************************************
[描述]协议操作函数返回值
***********************************************/
#define RX_RTP_193_ERROR		-1		//错误
#define RX_RTP_193_NORMAL		0		//正常


//Function:rx_Rtp_193_Generate
/***********************************************
[描述]产生协议
[参数]
<in>	app			应用号
<in>	etf			扩展标志
<in>	data		DATA数据域
<in>	data_len	data长度
<out>	prtcl		协议
<out>	prtcl_len	协议长度
[返值]
成功返回RX_RTP_193_NORMAL
失败返回RX_RTP_193_ERROR
***********************************************/
int
STDCALL
rx_Rtp_193_Generate
(const BYTE app, const BYTE etf, const BYTE* data, const int data_len,
BYTE* prtcl, int* prtcl_len);


//Function:rx_Rtp_193_Resolve
/***********************************************
[描述]解析协议
[参数]
<in>	prtcl		协议
<in>	prtcl_len	协议长度
<out>	app			应用号
<out>	etf			扩展标志
<out>	data		DATA数据域
<out>	data_len	data长度
[返值]
成功返回RX_RTP_193_NORMAL
失败返回RX_RTP_193_ERROR
***********************************************/
int
STDCALL
rx_Rtp_193_Resolve
(const BYTE* prtcl, const int prtcl_len,
BYTE* app, BYTE* etf, BYTE* data, int* data_len);


#endif

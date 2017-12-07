/***********************************************
*描述:MD5(Message-Digest Algorithm 5)算法
*版本:v1.0(2010-02-24 / 2011-09-05)
*审核:邢子文核准
***********************************************/

#ifndef RX_MD5_H
#define RX_MD5_H

//Structure:RX_MD5_CTX
/***********************************************
[描述]MD5算法运算变量结构
[说明]调用方不能修改内部数据
***********************************************/
typedef struct RX_MD5_CTX_tag
{
	BYTE			bit_length[8];
	unsigned int	ABCD[4];
	BYTE			buffer[64];
	unsigned int	ort_length;
}
RX_MD5_CTX;


//Function:rx_Md5_Init
/***********************************************
[描述]MD5运算初始化
[参数]
<in,out>context			MD5算法运算变量
***********************************************/
void
STDCALL
rx_Md5_Init
(RX_MD5_CTX* context);


//Function:rx_Md5_Update
/***********************************************
[描述]取定量数据更新MD5结果
[参数]
<in,out>context			MD5算法运算变量
<in>	data			定量数据
<in>	data_len		定量数据字节长度
***********************************************/
void
STDCALL
rx_Md5_Update
(RX_MD5_CTX* context, BYTE* data, unsigned int data_len);


//Function:rx_Md5_Final
/***********************************************
[描述]获取最终MD5摘要
[参数]
<in>	context			MD5算法运算变量
<out>	digest			MD5摘要
***********************************************/
void
STDCALL
rx_Md5_Final
(RX_MD5_CTX* context, BYTE digest[16]);


#endif

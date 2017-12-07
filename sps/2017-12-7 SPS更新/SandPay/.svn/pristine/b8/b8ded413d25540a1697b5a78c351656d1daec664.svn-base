/***********************************************
*描述:通用编码工具[part-i]
*版本:v1.3(2009-02-13)
*审核:邢子文核准
***********************************************/

#ifndef RX_CODER_PI_H
#define RX_CODER_PI_H

//Function:rx_Coder_Asc_To_BcdAlignRight
/***********************************************
[描述]将ASCII码转换成右靠左补零的BCD码
[说明]需指定BCD码的字节长度
[参数]
<in>	pAsc		ASCII码指针
<in>	nAscLen		ASCII码字节长度
<out>	pBcd		BCD码指针
<in>	nBcdLen		BCD码字节长度
***********************************************/
void
STDCALL
rx_Coder_Asc_To_BcdAlignRight
(const char* pAsc, unsigned long nAscLen,
unsigned char* pBcd, unsigned long nBcdLen);


//Function:rx_Coder_BcdAlignRight_To_Asc
/***********************************************
[描述]将右靠左补零的BCD码转换成ASCII码
[说明]BCD码中左侧有零,ASCII码中会保留左侧的零
[参数]
<in>	pBcd		BCD码指针
<in>	nBcdLen		BCD码字节长度
<out>	pAsc		ASCII码指针
<out>	pAscLen		ASCII码字节长度
***********************************************/
void
STDCALL
rx_Coder_BcdAlignRight_To_Asc
(const unsigned char* pBcd, unsigned long nBcdLen,
char* pAsc, unsigned long* pAscLen);


//Function:rx_Coder_Int_To_BcdAlignRight
/***********************************************
[描述]整型值转换成右靠左补零的BCD码
[说明]
(1)需指定BCD码的字节长度
(2)整型值的范围是0~4294967295
[参数]
<in>	Int			整型值
<out>	pBcd		BCD码指针
<in>	nBcdLen		BCD码字节长度
***********************************************/
void
STDCALL
rx_Coder_Int_To_BcdAlignRight
(unsigned long Int,
unsigned char* pBcd, unsigned long nBcdLen);


//Function:rx_Coder_BcdAlignRight_To_Int
/***********************************************
[描述]将右靠左补零的BCD码转换成整型值
[说明]整型值的范围是0~4294967295
[参数]
<in>	pBcd		BCD码指针
<in>	nBcdLen		BCD码字节长度
[返回]返回对应的整型值
***********************************************/
unsigned long
STDCALL
rx_Coder_BcdAlignRight_To_Int
(const unsigned char* pBcd, unsigned long nBcdLen);


#endif

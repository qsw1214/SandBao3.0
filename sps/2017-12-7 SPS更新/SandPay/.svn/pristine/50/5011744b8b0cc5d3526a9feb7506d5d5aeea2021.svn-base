/***********************************************
*描述:通用编码工具[part-ii]
*版本:v1.2(2010-03-11)
*审核:邢子文核准
***********************************************/

#ifndef RX_CODER_PII_H
#define RX_CODER_PII_H

//Function:rx_Coder_Byte_To_HexFormatAsc
/***********************************************
[描述]将字节转换成16进制描述的ASC码
[参数]
<in>	pByte		字节指针
<in>	ByteLen		字节长度
<out>	pAsc		ASCII码指针
<out>	pAscLen		ASCII码长度
***********************************************/
void
STDCALL
rx_Coder_Byte_To_HexFormatAsc
(const unsigned char* pByte, const unsigned long ByteLen,
char* pAsc, unsigned long* pAscLen);


//Function:rx_Coder_HexFormatAsc_To_Byte
/***********************************************
[描述]将16进制描述的ASC码转换成字节
[说明]只转换ASC码前偶数个字符
[参数]
<in>	pAsc		ASCII码指针
<in>	AscLen		ASCII码长度
<out>	pByte		字节指针
<out>	pByteLen	字节长度
***********************************************/
void
STDCALL
rx_Coder_HexFormatAsc_To_Byte
(const char* pAsc, const unsigned long AscLen,
unsigned char* pByte, unsigned long* pByteLen);


#endif

/***********************************************
*描述:SAND数据保密外壳
*版本:v1.2(2010-06-08)
*审核:邢子文核准
***********************************************/

#ifndef SD_SECRETSHELL_H
#define SD_SECRETSHELL_H

//Function:sd_SecretShell_Encrypt
/***********************************************
[描述]保密外壳加密
[参数]
<in>	Msg			明文
<in>	MsgLen		明文长度(字节)
<out>	EMsg		外壳密文
<out>	EMsgLen		外壳密文长度(字节)
***********************************************/
void
STDCALL
sd_SecretShell_Encrypt(BYTE* Msg, int MsgLen, BYTE* EMsg, int* EMsgLen);


//Function:sd_SecretShell_Decrypt
/***********************************************
[描述]保密外壳解密
[参数]
<out>	Msg			明文
<out>	MsgLen		明文长度(字节)(等于0表示解密错误)
<in>	EMsg		外壳密文
<in>	EMsgLen		外壳密文长度(字节)
***********************************************/
void
STDCALL
sd_SecretShell_Decrypt(BYTE* Msg, int* MsgLen, BYTE* EMsg, int EMsgLen);


#endif

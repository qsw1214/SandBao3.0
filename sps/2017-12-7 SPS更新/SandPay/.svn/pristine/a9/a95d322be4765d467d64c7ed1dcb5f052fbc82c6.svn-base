/***********************************************
*描述:DES(Data Encryption Standard)加密和解密操作
*版本:v1.0(2010-02-01)
*审核:邢子文核准
***********************************************/

#ifndef RX_DES_H
#define RX_DES_H

//Function:rx_Des_Encipher_64Bit
/***********************************************
[描述]DES的64位加密函数
[参数]
<in>	plaintext	明文(8个字节)
<in>	key			密钥(8个字节)
<out>	ciphertext	密文(8个字节)
***********************************************/
void
STDCALL
rx_Des_Encipher_64Bit
(BYTE plaintext[8], BYTE key[8], BYTE ciphertext[8]);


//Function:rx_Des_Decipher_64Bit
/***********************************************
[描述]DES的64位解密函数
[参数]
<in>	ciphertext	密文(8个字节)
<in>	key			密钥(8个字节)
<out>	plaintext	明文(8个字节)
***********************************************/
void
STDCALL
rx_Des_Decipher_64Bit
(BYTE ciphertext[8], BYTE key[8], BYTE plaintext[8]);


//Function:rx_Des_Encipher_Message
/***********************************************
[描述]DES加密函数
[说明]若明文长度不是8的倍数,则用指定字节填充
[参数]
<in>	plaintext		明文
<in>	plaintext_len	明文长度(字节)
<in>	key				密钥(8个字节)
<out>	ciphertext		密文
<out>	ciphertext_len	密文长度(字节)
<in>	fill_byte		填充字节(默认0x00)
***********************************************/
void
STDCALL
rx_Des_Encipher_Message
(BYTE* plaintext, unsigned long plaintext_len,
BYTE key[8],
BYTE* ciphertext, unsigned long* ciphertext_len,
BYTE fill_byte = 0x00);


//Function:rx_Des_Decipher_Message
/***********************************************
[描述]DES解密函数
[说明]若密文长度不是8的倍数,则不予以解密
[参数]
<in>	ciphertext		密文
<in>	ciphertext_len	密文长度(字节)
<in>	key				密钥(8个字节)
<out>	plaintext		明文
<out>	plaintext_len	明文长度(字节)
***********************************************/
void
STDCALL
rx_Des_Decipher_Message
(BYTE* ciphertext, unsigned long ciphertext_len,
BYTE key[8],
BYTE* plaintext, unsigned long* plaintext_len);


#endif

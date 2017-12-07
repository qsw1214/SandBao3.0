/***********************************************
*����:RX����Э��(Transfer Protocol)[���:193]
*�汾:v1.0(2010-04-22)
*���:�����ĺ�׼
*˵��:
-Э��˵��
1)��������
��ʶ��	˵��						��ʽ		�ֽ���
APP		Ӧ�ú�(APPlication)		HEX		1
ETF		��չ��־(ExTend Flag)	HEX		1
DATA	������(DATA)				HEX		N
2)����˵��
ETF=0x01��ʾDATA�������к�����չ����
ETF=0x00��ʾDATA�����޺�����չ����
***********************************************/

#ifndef RX_RTP_193_H
#define RX_RTP_193_H

//Macro
/***********************************************
[����]Э�������������ֵ
***********************************************/
#define RX_RTP_193_ERROR		-1		//����
#define RX_RTP_193_NORMAL		0		//����


//Function:rx_Rtp_193_Generate
/***********************************************
[����]����Э��
[����]
<in>	app			Ӧ�ú�
<in>	etf			��չ��־
<in>	data		DATA������
<in>	data_len	data����
<out>	prtcl		Э��
<out>	prtcl_len	Э�鳤��
[��ֵ]
�ɹ�����RX_RTP_193_NORMAL
ʧ�ܷ���RX_RTP_193_ERROR
***********************************************/
int
STDCALL
rx_Rtp_193_Generate
(const BYTE app, const BYTE etf, const BYTE* data, const int data_len,
BYTE* prtcl, int* prtcl_len);


//Function:rx_Rtp_193_Resolve
/***********************************************
[����]����Э��
[����]
<in>	prtcl		Э��
<in>	prtcl_len	Э�鳤��
<out>	app			Ӧ�ú�
<out>	etf			��չ��־
<out>	data		DATA������
<out>	data_len	data����
[��ֵ]
�ɹ�����RX_RTP_193_NORMAL
ʧ�ܷ���RX_RTP_193_ERROR
***********************************************/
int
STDCALL
rx_Rtp_193_Resolve
(const BYTE* prtcl, const int prtcl_len,
BYTE* app, BYTE* etf, BYTE* data, int* data_len);


#endif

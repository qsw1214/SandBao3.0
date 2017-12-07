/***********************************************
*����:ISO-7816�淶
*�汾:v1.0(2010-05-11)
*���:�����ĺ�׼
***********************************************/

#ifndef RX_ISO7816_H
#define RX_ISO7816_H

//Function:rx_Iso7816_Command
/***********************************************
[����]����ISO-7816ָ��(Command)
[����]
<in>	CLA			class byte
<in>	INS			instruction byte
<in>	P1			parameter byte 1
<in>	P2			parameter byte 2
<out>	CMD			command
<out>	CMD_Len		command length
<in>	useLc		(default:FALSE)	TRUE:present FALSE:absent
<in>	Lc			(default:0x00)	number of bytes in command data field
<in>	DataField	(default:NULL)	command data field
<in>	useLe		(default:FALSE)	TRUE:present FALSE:absent
<in>	Le			(default:0x00)	maximum number of bytes expacted
					in response data field
[˵��]
(1)��ָ������short length field
(2)Lc��Le�����Ե�������,Ҳ����ͬʱ����
***********************************************/
void
STDCALL
rx_Iso7816_Command
(BYTE CLA, BYTE INS, BYTE P1, BYTE P2,
BYTE* CMD, int* CMD_Len,
BOOL useLc = FALSE, BYTE Lc = 0x00, BYTE* DataField = NULL,
BOOL useLe = FALSE, BYTE Le = 0x00);


//Function:rx_Iso7816_Response
/***********************************************
[����]����ISO-7816Ӧ��(Response)
[����]
<in>	RESP		response
<in>	RESP_Len	response length
<out>	SW1			status bytes 1
<out>	SW2			status bytes 2
<out>	DataField	response data field
<out>	Lr			number of bytes in response data field
***********************************************/
void
STDCALL
rx_Iso7816_Response
(BYTE* RESP, int RESP_Len,
BYTE* SW1, BYTE* SW2, BYTE* DataField, int* Lr);


#endif

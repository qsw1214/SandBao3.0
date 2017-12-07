/*
 * npcode: NetPay Project Code
 *
 * Copyright (c) 2011 Rick Xing <xingpub@gmail.com>
 *
 * 2011-08-03
 */

#ifndef __NPCODE_H__
#define __NPCODE_H__

//标准正常值
#define		HANDLE_OK						0x00
//----------------------------------------------
//DEV InterFace
#define		HANDLE_DEVIF_DEV_NOTEXIST		0x11
#define		HANDLE_DEVIF_ERROR				0x12
#define		HANDLE_DEVIF_SENDTIMEOUT		0x13
#define		HANDLE_DEVIF_RECVTIMEOUT		0x14
#define		HANDLE_DEVIF_TOOMANY_DIVPACK	0x15
//----------------------------------------------
//PROTOCOL
#define		HANDLE_PROTOCOL_ERROR			0x21
#define		HANDLE_ACK_ERROR				0x22
#define		HANDLE_FRONT_PROTOCOL_ERR		0x23
#define		HANDLE_FRONT_MAC_ERR			0x24
#define		HANDLE_VER_ERROR				0x25
//----------------------------------------------
//COM DEVICE
#define		HANDLE_COM_NOTEXIST				0x31
#define		HANDLE_COM_ERROR				0x32
#define		HANDLE_COM_SENDTIMEOUT			0x33
#define		HANDLE_COM_RECVTIMEOUT			0x34
#define		HANDLE_COM_RESP_ERROR			0x35
//----------------------------------------------
//设备通道
#define		DEV_CHANNEL__NOTHING			0x70
#define		DEV_CHANNEL__HID_GEN1ST			0x71
#define		DEV_CHANNEL__HID_GEN2ND			0x72
//----------------------------------------------
//设备型号
#define		DEV_MODEL_NOTHING				0x80
#define		DEV_MODEL_UNKNOWN				0x8F
#define		DEV_MODEL_PP1000U				0x81
#define		DEV_MODEL_CR500					0x82
//----------------------------------------------
//CARD
#define		CARD_CPU						0x91	//非接CPU卡
#define		CARD_M1							0x92	//非接Mifare1卡
#define		CARD_MAG						0x93	//磁条卡
#define		CARD_CPU_OK						0x00
#define		CARD_CPU_ERROR					0xE0
#define		CARD_M1_OK						0x00
#define		CARD_M1_ERROR					0xE1
//----------------------------------------------
//LOGIC APP
#define		LOGIC_NOTEXIST_CARD				0xA1
#define		LOGIC_EXIST_KEYPAD				0xA2
#define		LOGIC_NOTEXIST_KEYPAD			0xA3
#define		LOGIC_DIFFERENT_CARD			0xA4
#define		LOGIC_NOT_FIND_DEV_RECORD		0xA5
#define		LOGIC_NOT_MATCHING_RECORD		0xA6
//----------------------------------------------
//圈存特定状态
#define		LOGIC_QC_STATE_B2				0xC1	//需要补充值
#define		LOGIC_QC_CARDREC_FORGERY		0xC2	//卡片记录伪造
#define		LOGIC_QC_STATE_B0_FALSE			0xC3	//需要补充值
#define		LOGIC_QC_NO_LOAD_AGAIN			0xC4	//不进行补充值
#define		LOGIC_QC_LOAD_AGAIN				0xC5	//进行补充值
#define		LOGIC_QC_WAIT_MANUAL			0xC6	//等待人工处理
//----------------------------------------------
//DUM模块ExitCode
#define		DUM_DEVICE_ERROR				0xD1
#define		DUM_DOWNLOAD_ERROR				0xD2
#define		DUM_FILE_ERROR					0xD3
#define		DUM_HASH_ERROR					0xD4
#define		DUM_USER_CANCEL					0xD5
#define		DUM_WRITEBIN_ERROR				0xD6
#define		DUM_CANNOT_START				0xD7
//----------------------------------------------
//LOGIC ERR
#define		LOGIC_ERROR						0xF0
#define		LOGIC_FRONT_ERROR				0xF1
#define		LOGIC_HMAC_ERROR				0xF2
#define		LOGIC_DEVSID_ERROR				0xF3
#define		LOGIC_DO_NOTHING				0xF4
//----------------------------------------------

#endif

//
//  cpucard.h
//  ItestXC
//
//  Created by Rick Xing on 16/5/30.
//  Copyright © 2016年 SAND. All rights reserved.
//

#ifndef cpucard_h
#define cpucard_h

#include "stdrfx.h"

#include "xstring.h"
using namespace sz;


#define APDU_LEN 512


XString Npons_CpuCmdSelect
(XString FileID_2B);

XString Npons_CpuCmdVerifyPin
(BYTE KeyID, XString PIN_3B);

XString Npons_CpuCmdInitializeForLoad
(BYTE KeyID, int Amount_feng, XString TerminalID_6B);

XString Npons_CpuCmdCreditForLoad
(XString HostDate_4B, XString HostTime_3B, XString MAC2_4B);

XString Npons_CpuCmdInitializeForPurchase
(BYTE KeyID, int Amount_feng, XString TerminalID_6B);

XString Npons_CpuCmdDebitForPurchase
(XString TerminalTransSN_4B, XString TerminalDate_4B, XString TerminalTime_3B, XString MAC1_4B);

XString Npons_CpuCmdReadBinary
(XString FileID_2B, int FileLen);

XString Npons_CpuCmdGetBalance
();

XString Npons_CpuCmdGetTransactionProve
(BYTE TypeID, XString TransSn_2B);

XString Npons_CpuCmdGetChallenge
(BYTE RandSize);

XString Npons_CpuCmdExternalAuthenticate
(BYTE KeyID, XString Rand_E_8B);

XString Npons_CpuCmdUpdateBinary
(XString FileID_2B, BYTE Offset, XString Data_NB, BYTE Data_Len);

XString Npons_CpuCmdUpdateBinaryWithProtection
(XString FileID_2B, BYTE Offset, XString Data_NB, BYTE Data_Len);





#endif /* cpucard_hpp */

/*
 **  Copyright (C) 2013-2015 SAND. All rights reserved.
 **  AUTHOR
 **      Rick Xing <xing.zw@sand.com.cn>
 **  HISTORY
 **      2013-06-21 # Created by Rick Xing
 **      2015-02-16 # Modified by Rick Xing
 */

#ifndef RXSANDPAYCORE_H
#define RXSANDPAYCORE_H

#include "xhead.h"
#include "xstring.h"
using namespace sz;

class RXSandPayCore
{
public:
    RXSandPayCore(void);
    ~RXSandPayCore(void);
    
public:
    bool TEST_FLAG;
    XString SPS_FORM;   //SPS形态:0-支付/1-充值/2-圈存

    
public:
    enum ERROR_CODE
    {
        HANDLE_OK,
        PROTOCOL_ERROR,
        MAC_ERROR,
        SERVER_RESP_ERROR,
        HMAC_ERROR
    };
    enum PAY_MODE
    {
        ONLY_PASS,
        CARD_PASS,
        ONLY_CODE,
        UNION_PAY
    };

public:
    class PayToolPath
    {
    public:
        int i;  //kid
        int j;  //tid
        int k;  //orgid
        int l;  //medium
    };
    class CARDACC
    {
    public:
        XString medium;
        XString accType;
        XString accBal;
        XString accHoldBal;
    };
    class ORGID
    {
    public:
        bool _valid;
        XString orgid;
        XString payservcie_sid;
        XString payservcie_description;
        XString payservcie_logo;
        int cardaccs_len;
        CARDACC cardaccs[8];
    };
    class TID
    {
    public:
        XString tid;
        XString tidname;
        int orgids_len;
        ORGID orgids[8];
    };
    class KID
    {
    public:
        XString kid;
        XString kidname;
        int tids_len;
        TID tids[8];
    };
    int kids_len;
    KID kids[8];


public:
    XString version;
    XString charset;
    XString accessChannelNo;
    XString accessType;
    XString commType;
    XString deviceType;
    XString __deviceType;
    XString deviceInfo;
    XString _devID;
    XString _duid;
    XString attachDeviceType;
    XString attachDeviceInfo;
    XString clientSecurityInfo;
    XString _memid;         // user member id
    XString _sessionid;     // connection session id
    XString _token;
    XString _uuid;          // security session id
    XString _sid;           // user login session id
    XString apiName;
    XString busiType;
    XString busiInfo;
    XString respCode;
    XString respResult;
    XString signType;
    XString sign;


public:
    BYTE Ra[16];
    BYTE Rb[16];
    BYTE HMAC1[16];
    BYTE HMAC2[16];
    BYTE UUID[16];
    BYTE WORKKEY[16];
    BYTE WORKKEY_Cipher[128];
    XString fp;

public: // Protocol record
    XString kIds;
    XString mem;
    XString memInfo;
    XString memPayTypeDetails;
    XString membusiInfo;

public: // Order
    XString merData;
    //
    XString order_id; //mer order id
    XString order_time;
    XString order_amount;
    XString payInfo;
    //
    XString merchantId;
    XString oId; //sand order id
    XString merName;
    //
    XString payAmt;
    XString opId;   //pay id

public: // User
    XString lgnType;
    XString memName;
    XString memPasswd;
    XString loginModel;

public:
    PayToolPath ptPath;

public:
    XString acc;
    XString acctp;
    XString subacctp;
    XString accp;
    XString accptp;


public: // CARD
    XString CardMedia_1B;
	XString CardSerial_4B;
	XString CardPlat_1B;
	XString CardIssuer_3B;
	XString CardNo_8B;
	XString CardExpiry_4B;
	XString CardRechargeSN_8B;

    XString CpuCardReq;
    XString CpuCardResp;


public:

    XString b2t2_payInfo;
    XString b2t2_payAuth;
    XString b2t2_payAuth_id;
    XString b2t2_payAuth_maxamount;
    XString b2t2_payAuth_minamount;

    XString b2t3_verifytype;
    XString b2t3_verifyid;

    XString b2t6_transType;
    XString b2t6_befBal;
    XString b2t6_tsNo;

    XString b2t11_idCardNo;
    XString b2t11_idType;
    XString b2t11_rgNo;
    XString b2t11_rgMod; //--
    XString b2t11_busiInfo1_cardNo;
    XString b2t11_busiInfo1_cardType;
    XString b2t11_busiInfo1_issueNo;
    XString b2t11_busiInfo1_curBal;
    XString b2t11_busiInfo1_accMaxBal;
    XString b2t11_busiInfo1_curChargeBal;
    XString b2t11_busiInfo1_perMaxChargeBal;
    XString b2t11_busiInfo1_cardState;
    XString b2t11_busiInfo2_cardStatus;
    XString b2t11_busiInfo2_pwdFlag;
    XString b2t11_busiInfo2_sandBal;
    XString b2t11_busiInfo2_sandfreezed;

    XString b3t1_orderAmt;
    XString b3t1_issueNo;
    XString b3t1_cardNo;
    XString b3t1_type;
    XString b3t1_notifyFlag;
    XString b3t1_notifyType; //--
    XString b3t1_transType;
    XString b3t1_rebateAmt;
    XString b3t1_fateAmt;

    XString b3t2_tgid;
    XString b3t2_tgmid;
    XString b3t2_tgtgid;
    XString b3t2_tgtgtp;
    XString b3t2_tgpid;
    XString b3t2_mediumType;
    XString b3t2_medium;
    XString b3t2_subAccType; //--
    XString b3t2_target;
    XString b3t2_target_balanceAmount;
    XString b3t2_target_balanceFreeAmount;

    XString b3t3_cId;
    XString b3t3_kId;
    XString b3t3_tId;
    XString b3t3_orgId;
    XString b3t3_dId;
    XString b3t3_sId; //--
    XString b3t3_mid;
    XString b3t3_transtype;

    XString b3t4_channelType;
    XString b3t4_mid;
    XString b3t4_ac; //--
    XString b3t4_tgid;
    XString b3t4_tgmid;
    XString b3t4_tgtgid;
    XString b3t4_tgtgtp;
    XString b3t4_tgpid;
    XString b3t4_macqcode;
    XString b3t4_cardArray;

    XString b3t5_mid;
    XString b3t5_transtype;
    XString b3t5_cId;
    XString b3t5_kId;
    XString b3t5_tId;
    XString b3t5_orgId;

    XString b3t7_beginAmt;
    XString b3t7_pwdFlag; //--
    XString b3t7_rechargeData_comData;
    XString b3t7_expireDate;

    XString b3t8_endAmt;
    XString b3t8_transAmt; //--

    XString b3t9_comData; //--
    XString b3t9_authData_comData;

    XString b3t10_an;
    XString b3t10_rechargemid; //--
    XString b3t10_targetsMap;

    XString b3t12_orderAmt; //--

    XString b3t13_mid;
    XString b3t13_transAmt; //--
    XString b3t13_reverseFlag;

    XString b3t14_orderAmt;
    XString b3t14_payPwd;
    XString b3t14_accountNo; //--

    XString b4t1_mem_username;
    XString b4t1_mem_credentType;
    XString b4t1_mem_credentId;
    XString b4t1_mem_nick;
    XString b4t1_mem_phoneNumber;
    XString b4t1_mem_eMail;
    XString b4t1_mem_realName;
    XString b4t1_mem_welcome;
    XString b4t1_mem_postcode;
    XString b4t1_mem_address;
    XString b4t1_mem_loginType;
    XString b4t1_mem_sessionid;
    XString b4t1_mem_medium;
    XString b4t1_mem_mediumAllAmount;
    XString b4t1_mem_regType;
    XString b4t1_mem_allAccount;
    XString b4t1_mem_mobileOpenType;
    XString b4t1_mem_mailOpenType;
    XString b4t1_mem_lgntime;

    XString SEID;
    XString b4t3_phoneNum;
    XString b4t3_memRealName;
    XString b4t3_walletCardSerial;
    XString b4t3_walletCardNo;
    XString b4t3_walletBalance;
    XString b4t3_walletIccId;
    XString b4t3_idType;
    XString b4t3_id;
    XString b4t3_walletAccInfo__isNull;
    XString b4t3_walletAccInfo_openMod;
    XString b4t3_walletAccInfo_regFrom;
    XString b4t3_walletAccInfo_accInfo_accountType;
    XString b4t3_walletAccInfo_accInfo_mainAccNo;
    XString b4t3_walletAccInfo_accInfo_payPwd;
    XString b4t3_walletAccInfo_accInfo_encryType;
    XString b4t3_walletAccInfo_accInfo_kId;
    XString b4t3_walletAccInfo_accInfo_tId;
    XString b4t3_walletAccInfo_accInfo_orgId;
    XString b4t3_walletAccInfo_accInfo_maxAmount;
    XString b4t3_walletAccInfo_accInfo_ndShow;
    XString b4t3_walletAccInfo_accInfo_auth;
    XString b4t3_walletAccInfo_accInfo_stat; //--
    XString b4t3_accStatus;
    XString b4t3_status;
    XString b4t3_orderInfo;
    XString b4t3_massage;

    XString b4t4_phoneNum;
    XString b4t4_timeOut;
    XString b4t4_bizType; //--

    XString b4t7_walletCardNo;
    XString b4t7_phoneNum; //--
    XString b4t7_accStatus;
    XString b4t7_status;
    XString b4t7_abolishTime;
    XString b4t7_closeTime;

    XString b4t9_openMod;
    XString b4t9_regFrom;
    XString b4t9_userInfo_userName;
    XString b4t9_userInfo_nick;
    XString b4t9_userInfo_phoneNumber;
    XString b4t9_userInfo_eMail;
    XString b4t9_userInfo_welcome;
    XString b4t9_userInfo_idType;
    XString b4t9_userInfo_id;
    XString b4t9_userInfo_shortMsgCode;
    XString b4t9_userInfo_regType;
    XString b4t9_userInfo_loginPwd;
    XString b4t9_userInfo_encryType;
    XString b4t9_accInfo_accountType;
    XString b4t9_accInfo_mainAccNo;
    XString b4t9_accInfo_payPwd;
    XString b4t9_accInfo_encryType;
    XString b4t9_accInfo_kId;
    XString b4t9_accInfo_tId;
    XString b4t9_accInfo_orgId;
    XString b4t9_accInfo_maxAmount;
    XString b4t9_accInfo_ndShow;
    XString b4t9_accInfo_auth;
    XString b4t9_accInfo_stat; //--

    XString b4t10_userId;
    XString b4t10_bizType;
    XString b4t10_bizInfo_eMail;
    XString b4t10_bizInfo_phoneNum;
    XString b4t10_bizInfo_shortMsgCode;
    XString b4t10_bizInfo_nick;
    XString b4t10_bizInfo_welcome;
    XString b4t10_bizInfo_idType;
    XString b4t10_bizInfo_id;
    XString b4t10_bizInfo_address;
    XString b4t10_bizInfo_postCode;
    XString b4t10_bizInfo_pwdType;
    XString b4t10_bizInfo_oldPwd;
    XString b4t10_bizInfo_newPwd;
    XString b4t10_bizInfo_cardNo;
    XString b4t10_bizInfo_newPhoneNo;
    XString b4t10_bizInfo_newShortMsgCode;
    XString b4t10_bizInfo_oldPhoneNo;
    XString b4t10_bizInfo_oldShortMsgCode; //--

    XString b4t11_userId;
    XString b4t11_bizType;
    XString b4t11_bizInfo_pwdType;
    XString b4t11_bizInfo_username;
    XString b4t11_bizInfo_logPwd;
    XString b4t11_bizInfo_newPwd;
    XString b4t11_bizInfo_cardNo;
    XString b4t11_bizInfo_phoneNum;
    XString b4t11_bizInfo_shortMsgCode; //--

    XString b4t12_checkScene;
    XString b4t12_queryType;
    XString b4t12_queryInfo_regFlag;
    XString b4t12_queryInfo_regId; //--
    XString b4t12_resultInfo_mem_memid;
    XString b4t12_resultInfo_mem_username;
    XString b4t12_resultInfo_mem_phoneNumber;
    XString b4t12_resultInfo_mem_eMail;

    XString b4t15_userCommonPayUtils;

    XString b4t16_phoneNum;
    XString b4t16_idType;
    XString b4t16_id; //--
    XString b4t16_checkResultCode;
    XString b4t16_checkInfo;

    XString b4t22_userId;
    XString b4t22_bizType;
    XString b4t22_bizInfo_identityNo;
    XString b4t22_bizInfo_trueName;
    XString b4t22_bizInfo_bankCardNo1;
    XString b4t22_bizInfo_bankCardNo2;
    XString b4t22_bizInfo_cardType;
    XString b4t22_bizInfo_isCheck;

    XString b4t23_userId;
    XString b4t23_bizInfo_phoneNum;
    XString b4t23_bizInfo_shortMsgCode;
    XString b4t23_bizInfo_userName;
    XString b4t23_bizInfo_eMail; //--

    XString b4t24_randomKey; //--

    XString b5t2_checkSum; //--

    XString b5t3_pwdflag; //--
    XString b5t3_sandBal;
    XString b5t3_sandfreezed;

    XString b5t4_status;
    XString b5t4_nameFlag;
    XString b5t4_testFlag;
    XString b5t4_testAmt;
    XString b5t4_depositFlag;
    XString b5t4_depositAmt;
    XString b5t4_maxAmt;
    XString b5t4_rechKey;
    XString b5t4_consumKey;
    XString b5t4_disperseFlag;

    XString b5t5_subAccType;
    XString b5t5_startDate;
    XString b5t5_endDate;
    XString b5t5_currentPage;
    XString b5t5_pageLine; //--
    XString b5t5_totalPage;
    XString b5t5_rcdInfo;

    XString b5t9_macInfo_sysCode;
    XString b5t9_macInfo_issueNo;
    XString b5t9_macInfo_cardNo;
    XString b5t9_macInfo_transType;
    XString b5t9_macInfo_randomData;
    XString b5t9_macInfo_initVec;
    XString b5t9_macInfo_macData; //--
    XString b5t9_macInfo_mac;

    XString b5t11_phoneNum;
    XString b5t11_busiType; //--
    XString b5t11_busiInfo_seid;
    XString b5t11_busiInfo_agentCode;
    XString b5t11_busiInfo_userId;
    XString b5t11_busiInfo_cardCmdStatus;
    XString b5t11_busiInfo_cardNo; //--
    XString b5t11_busiInfo_exeStep;
    XString b5t11_busiInfo_exeStepRet_cmdIndex;
    XString b5t11_busiInfo_exeStepRet_apduIn;
    XString b5t11_busiInfo_exeStepRet_apduOut;
    XString b5t11_busiInfo_exeStepRet_cmdExeTime;
    XString b5t11_busiInfo_upLoadTime;
    XString b5t11_busiInfo_osType;
    XString b5t11_busiInfo_phoneType;
    XString b5t11_busiInfo_fingerPrint; //--
    XString b5t11_busiInfo_pubStatus;
    XString b5t11_busiInfo_cmdSerial;
    XString b5t11_busiInfo_checkCode;
    XString b5t11_busiInfo_exeStepDesc;

    XString b5t14_accNo;
    XString b5t14_accType;
    XString b5t14_accBal;
    XString b5t14_accHoldBal;


    /*----------MPCP B-Terminal----------*/
    // product
    static XString mpcp_productId;
    // mer user oper
    static XString mpcp_mid;
    static XString mpcp_shortName;
    static XString mpcp_baseInfo;
    static XString mpcp_accInfo;
    static XString mpcp_userInfo;
    static XString mpcp_operType;
    static XString mpcp_operId;
    static XString mpcp_operInfo;
    // order
    static XString mpcp_transNo;
    static XString mpcp_orderCode;
    static XString mpcp_orderAmt;
    static XString mpcp_transAmt;
    static XString mpcp_currency;
    static XString mpcp_endTime;
    static XString mpcp_attach;
    static XString mpcp_goodsContent;
    static XString mpcp_orderStatus;
    static XString mpcp_orderResult;
    // device
    static XString mpcp_deviceId;

    /*----------MPCP C/B-Terminal----------*/
    // user
    static XString mpcp_userId;


    static XString b7t1_checkInType;
    static XString b7t1_checkInOrg; //--
    static XString b7t1_voucherType;
    static XString b7t1_qrCodeUrl;
    static XString b7t1_picUrl;

    static XString b7t2_checkInOrg;
    static XString b7t2_authCode;
    static XString b7t2_notifyUrl; //--

    static XString b7t4_pwd;
    static XString b7t4_isCardNo; //--

    static XString b7t5_busiInfo;

    static XString b7t7_authCodCount; //--
    static XString b7t7_batchNo;
    static XString b7t7_authCode;

    static XString b7t8_openMod; //--

    static XString b7t9_busiType;
    static XString b7t9_busiInfo; //--

    static XString b7t10_loginInfo; //--

    static XString b7t11_busiType; //--
    static XString b7t11_busiRetInfo;

    static XString b7t12_phoneNum;
    static XString b7t12_timeOut;
    static XString b7t12_bizType; //--

    static XString b7t13_busiType;
    static XString b7t13_busiInfo; //--
    static XString b7t13_resultInfo;

    static XString b7t14_fileName;
    static XString b7t14_fileType;
    static XString b7t14_idcardType; //--

    static XString b7t15_checkInOrg;
    static XString b7t15_payType; //--

    static XString b7t18_cashierList;

    static XString b7t19_payInstrument;
    static XString b7t19_transType;
    static XString b7t19_busiType;
    static XString b7t19_payOrder;
    static XString b7t19_customerType;
    static XString b7t19_busiInfo; //--
    static XString b7t19_tradeDetailList;

    static XString b7t20_payInstrument;
    static XString b7t20_transType;
    static XString b7t20_busiType;
    static XString b7t20_busiInfo; //--
    static XString b7t20_tradeCountList;

    static XString b7t21_accountNo; //--
    static XString b7t21_accBalance;
    static XString b7t21_avaBalance;
    static XString b7t21_cashOutBalance;

    static XString b7t22_orderAmt;
    static XString b7t22_kid;
    static XString b7t22_tid;
    static XString b7t22_orgid;
    static XString b7t22_payPwd; //--
    static XString b7t22_arriTime;
    static XString b7t22_realCashoutAmt;
    static XString b7t22_accBalance;
    static XString b7t22_avaBalance;
    static XString b7t22_cashOutBalance;
    static XString b7t22_tranFateAmt;
    static XString b7t22_serialNo;
    static XString b7t22_tranSerialNo;

    static XString b7t23_accountNo;
    static XString b7t23_startDate;
    static XString b7t23_endDate;
    static XString b7t23_currentSize;
    static XString b7t23_pageNum;
    static XString b7t23_status;
    static XString b7t23_serialNo;
    static XString b7t23_tranSerialNo; //--
    static XString b7t23_withdrawDetailList;

    static XString b7t24_userName;
    static XString b7t24_feedback; //--

    static XString b7t25_busiType;
    static XString b7t25_busiInfo; //--

    static XString b7t27_bankTypeCode;
    static XString b7t27_bankName; //--
    static XString b7t27_bankList;

    static XString b7t28_bankTypeList; //--

    static XString b7t29_busiType;
    static XString b7t29_sn;
    static XString b7t29_postype; //--

    static XString b7t30_busiInfo; //--
    static XString b7t30_accountChangeList;
    static XString b7t30_accountChangeInfo;

    static XString b7t31_versionNumber;
    static XString b7t31_appUnique; //--
    static XString b7t31_url;
    static XString b7t31_hasNew;

    static XString b7t32_payUtils;

    static XString b7t33_transType;
    static XString b7t33_defaultFlag;
    static XString b7t33_kId;
    static XString b7t33_tId;
    static XString b7t33_orgId;
    static XString b7t33_sId;
    static XString b7t33_mergePayIndex; //--

    static XString b7t35_payMode;
    static XString b7t35_payInstrument;
    static XString b7t35_payInstiCode;
    static XString b7t35_orderNum;
    static XString b7t35_innerID;
    static XString b7t35_instiCode;

    static XString b7t36_busiInfo;  //--

    static XString b7t37_busiInfo;  //--
    static XString b7t37_appid;
    static XString b7t37_partnerid;
    static XString b7t37_prepayid;
    static XString b7t37_pack_age;
    static XString b7t37_noncestr;
    static XString b7t37_timestamp;
    static XString b7t37_sign;

    static XString b7t38_busiInfo;  //--


public:
    void TestMode(void);
    void SetMerData(XString merdata);
    void SetPayTools(void);

    XString EncryptUserPass(XString pass);
    XString EncryptAccPass(XString pass);

    XString Biz_UP(XString type);
    enum ERROR_CODE Biz_DOWN(XString data);

    XString Biz_Sign(XString data);

public:
    XString UnionPayXMLData; // old
    XString UnionPayTN; // 201309
    XString CmccWapUrl;
    XString ZfbWapUrl;  //2014-06-10
};

#endif

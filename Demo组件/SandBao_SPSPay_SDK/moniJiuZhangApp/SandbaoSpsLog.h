//
//  SandbaoSpsLog.h
//  moniJiuZhangApp
//
//  Created by tianNanYiHao on 2017/12/8.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//


##SDK使用配置##
#一.导入SpsDock.a静态库
#二.info.plist设置白名单 (白名单值: sandbao)
#在Xcod项目工程的info.plist -> LSApplicationQueriesSchemes -> 填入值: sandbao
#或	
/*
<key>LSApplicationQueriesSchemes</key>
<array>
<string>sandbao</string>
</array>
*/
#三.在工程中注册URL Schemes
#在项目 TARGETS -> Info - > URL Types - > 新增 URL Schemes 填入值: sandbaoPay



##SDK使用##
/*
 见 SpsDock.h 及 Demo
 */

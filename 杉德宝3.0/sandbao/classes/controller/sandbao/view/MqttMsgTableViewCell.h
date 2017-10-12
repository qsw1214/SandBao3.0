//
//  MqttMsgTableViewCell.h
//  sandbao
//
//  Created by tianNanYiHao on 2017/7/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MqttMsgTableViewCell : UITableViewCell

@property (nonatomic, assign) NSInteger msgLevel;
@property (nonatomic, strong) NSString *msgTitleStr;
@property (nonatomic, strong) NSString *msgDetailStr;
@property (nonatomic, strong) NSString *msgTimeStr;
@property (nonatomic, strong) NSString *readOrno;

- (instancetype)initWiht:(UITableView*)tableView identifer:(NSString*)indetifer;



@end

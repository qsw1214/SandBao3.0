//
//  MqttMsgTableViewCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/7/28.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "MqttMsgTableViewCell.h"
@interface MqttMsgTableViewCell(){
    
}
@property (weak, nonatomic) IBOutlet UIImageView *msgImage;//图片
@property (weak, nonatomic) IBOutlet UILabel *msgTitleLab; //消息标题
@property (weak, nonatomic) IBOutlet UILabel *msgDetailLab; //消息详情
@property (weak, nonatomic) IBOutlet UILabel *msgTimeLab;   //消息时间

@end
@implementation MqttMsgTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (void)setMsgLevel:(NSInteger)msgLevel{
    _msgLevel = msgLevel;
    if (_msgLevel == 0) {
        _msgImage.image = [UIImage imageNamed:@"mqttmsgTippp"];
    }
    if (_msgLevel == 1) {
        _msgImage.image = [UIImage imageNamed:@"mqttmsgTippp"];
    }
    if (_msgLevel == 2) {
        _msgImage.image = [UIImage imageNamed:@"mqttmsgTippp"];
    }
    
}


- (void)setReadOrno:(NSString *)readOrno{
    
    _readOrno = readOrno;
    if ([_readOrno isEqualToString:@"0"]) {
        _msgImage.image = [UIImage imageNamed:@"mqttmsgTippp"];
    }else if([_readOrno isEqualToString:@"1"]){
        _msgImage.image = [UIImage imageNamed:@"mqttmsgTipp"];
    }
}

- (void)setMsgTitleStr:(NSString *)msgTitleStr{
    _msgTitleStr = msgTitleStr;
    _msgTitleLab.text = _msgTitleStr;
    
}

-(void)setMsgDetailStr:(NSString *)msgDetailStr{
    _msgDetailStr = msgDetailStr;
    _msgDetailLab.text = _msgDetailStr;
}

- (void)setMsgTimeStr:(NSString *)msgTimeStr{
    _msgTimeStr = msgTimeStr;
    _msgTimeLab.text = _msgTimeStr;
}

@end

//
//  BankItemTableViewCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/13.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "BankItemTableViewCell.h"

#define labelColor RGBA(255, 255, 255, 1.0)

@interface BankItemTableViewCell()

//背景
@property (nonatomic, weak) UIImageView *backgroundImageView;
//渐变色
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
//图标
@property (nonatomic, weak) UIImageView *iconImageView;
//图标白色背景
@property (nonatomic, weak) UIView      *iconImageBackView;
//水印
@property (nonatomic, weak) UIImageView *iconWatermarkImageView;
//名字
@property (nonatomic, weak) UILabel *bankNameLabel;
//类型
@property (nonatomic, weak) UILabel *bankTypeLabel;
//卡号
@property (nonatomic, weak) UILabel *bankNumLabel;

@end

@implementation BankItemTableViewCell

@synthesize viewSize;
@synthesize cellHeight;

- (void)awakeFromNib {
    [super awakeFromNib];
    
    
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        //背景
        UIImageView *backgroundImageView = [[UIImageView alloc] init];
        [self.contentView addSubview:backgroundImageView];
        self.backgroundImageView = backgroundImageView;
        
        //渐变色
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        [self.backgroundImageView.layer addSublayer:gradientLayer];
        self.gradientLayer = gradientLayer;
        
        //图标白色背景
        UIView *iconImageBackView = [[UIView alloc] init];
        [self.backgroundImageView addSubview:iconImageBackView];
        self.iconImageBackView = iconImageBackView;
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.iconImageBackView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        //水印图标
        UIImageView *iconWatermarkImageView = [[UIImageView alloc] init];
        [self.backgroundImageView addSubview:iconWatermarkImageView];
        self.iconWatermarkImageView = iconWatermarkImageView;
        
        //银行名字
        UILabel *bankNameLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:bankNameLabel];
        self.bankNameLabel = bankNameLabel;
        
        //银行名字
        UILabel *bankTypeLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:bankTypeLabel];
        self.bankTypeLabel = bankTypeLabel;
        
        //银行卡号
        UILabel *bankNumLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:bankNumLabel];
        self.bankNumLabel = bankNumLabel;
        
        
    
    }
    
    return self;
}

/**
 *  重写set方法
 *
 *  @param weibo 微博
 */
- (void)setDicData:(NSDictionary *)dicData
{
    _dicData = dicData;
    
    //设置数据
    [self settingData];
    
    //设置位置和大小
    [self settingFrame];
}


/**
 *@brief  位置和大小
 *@return
 */
- (void)settingFrame
{
    CGFloat space = 10.0;
    CGFloat leftRightSpace = 15;
    CGFloat bankNumLabelTop = 2 * space;
    
    UIImage *iconImage = [UIImage imageNamed:@"banklist_abc"];
    CGSize iconImageSize = CGSizeMake(iconImage.size.width+space/2, iconImage.size.height+space/2);
    CGFloat commLabelW = viewSize.width - 2 * 10 - 2 * 10 - iconImage.size.width - space;
    CGSize bankNameLabelSize = [self.bankNameLabel sizeThatFits:CGSizeMake(commLabelW, MAXFLOAT)];
    CGSize bankTypeLabelSize = [self.bankTypeLabel sizeThatFits:CGSizeMake(commLabelW, MAXFLOAT)];
    CGSize bankNumLabelSize = [self.bankNumLabel sizeThatFits:CGSizeMake(commLabelW, MAXFLOAT)];
    
    CGFloat upDownSpace = (cellHeight - 10 - bankNameLabelSize.height - space - bankTypeLabelSize.height - bankNumLabelTop - bankNumLabelSize.height) / 2;
    
    
    //设置背景的frame
    CGFloat backgroundImageViewX = leftRightSpace;
    CGFloat backgroundImageViewY = 10;
    CGFloat backgroundImageViewW = viewSize.width - leftRightSpace * 2;
    CGFloat backgroundImageViewH = cellHeight - 10;
    
    self.backgroundImageView.frame = CGRectMake(backgroundImageViewX, backgroundImageViewY, backgroundImageViewW, backgroundImageViewH);
    
    self.gradientLayer.frame = self.backgroundImageView.bounds;
    
    
    //设置图标白色背景
    CGFloat radius = space/2;
    
    
    //设置图标的frame
    CGFloat iconImageViewX= leftRightSpace;
    CGFloat iconImageViewY= upDownSpace;
    CGFloat iconImageViewW= self.iconImageView.image.size.width;
    CGFloat iconImageViewH= self.iconImageView.image.size.height;
    
    self.iconImageBackView.frame = CGRectMake(iconImageViewX - radius, leftRightSpace - radius, iconImageViewW + radius, iconImageViewH + radius);
    self.iconImageView.frame = CGRectMake(radius/2, radius/2, iconImageViewW, iconImageViewH);
    
    
    //设置水印图标fram
    CGFloat iconOffset = 10;
    CGSize iconWatermarkImageViewSize = CGSizeMake(self.iconWatermarkImageView.image.size.width, self.iconWatermarkImageView.image.size.height);
    CGFloat iconWatermarkImageViewY = cellHeight - iconWatermarkImageViewSize.height;
    CGFloat iconWatermarkImageViewX = backgroundImageViewW - iconWatermarkImageViewSize.width;
    self.iconWatermarkImageView.frame = CGRectMake(iconWatermarkImageViewX+iconOffset, iconWatermarkImageViewY, iconWatermarkImageViewSize.width, iconWatermarkImageViewSize.height);
    
    //设置银行名字的frame
    CGFloat bankNameLabelX= iconImageViewX + iconImageViewW + space;
    CGFloat bankNameLabelY= upDownSpace;
    CGFloat bankNameLabelW=commLabelW;
    CGFloat bankNameLabelH=bankNameLabelSize.height;
    
    self.bankNameLabel.frame = CGRectMake(bankNameLabelX, leftRightSpace, bankNameLabelW, bankNameLabelH);
    
    //设置银行类型的frame
    CGFloat bankTypeLabelX= bankNameLabelX;
    CGFloat bankTypeLabelY= bankNameLabelY + bankNameLabelH + space;
    CGFloat bankTypeLabelW=commLabelW;
    CGFloat bankTypeLabelH=bankTypeLabelSize.height;
    
    self.bankTypeLabel.frame = CGRectMake(bankTypeLabelX, bankTypeLabelY, bankTypeLabelW, bankTypeLabelH);
    
    
    //设置银行卡号的frame
    CGFloat bankNumLabelX= bankNameLabelX;
    CGFloat bankNumLabelY= bankTypeLabelY + bankTypeLabelH + bankNumLabelTop;
    CGFloat bankNumLabelW=commLabelW;
    CGFloat bankNumLabelH=bankNumLabelSize.height;
    
    self.bankNumLabel.frame = CGRectMake(bankNumLabelX, bankNumLabelY, bankNumLabelW, bankNumLabelH);
}

/**
 *@brief 设置数据
 *@return
 */
- (void)settingData
{
    CGFloat bankNameTextSize = 0;
    CGFloat bankTypeTextSize = 0;
    CGFloat bankNumTextSize = 0;
    
  
        bankNameTextSize = 14;
        bankTypeTextSize = 14;
        bankNumTextSize = 14;

    
    //背景和图标
    UIColor *backgroundColor;
    UIColor *backgroundColor2;
    UIImage *iconImage;
    UIImage *iconWatermarkImage;
    NSString *bankName = [_dicData objectForKey:@"title"];
    NSArray *arr = [Tool getBankIconInfo:bankName];
    iconImage = arr[0];
    iconWatermarkImage = arr[1];
    backgroundColor = arr[2];
    backgroundColor2 = arr[3];
    
    self.backgroundImageView.layer.cornerRadius = 5;
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.backgroundColor = backgroundColor;
    
    self.gradientLayer.colors = @[
                             (__bridge id)backgroundColor.CGColor,
                             (__bridge id)backgroundColor2.CGColor
                             ];
    self.gradientLayer.startPoint = CGPointMake(0.5f, 1);
    self.gradientLayer.endPoint = CGPointMake(0.5f, 0);
    
    self.iconImageView.image = iconImage;
    self.iconImageView.layer.cornerRadius = iconImage.size.width/2;
    self.iconImageView.backgroundColor = [UIColor whiteColor];
    self.iconImageView.layer.masksToBounds = YES;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconImageBackView.layer.cornerRadius = (iconImage.size.width+5)/2;
    self.iconImageBackView.backgroundColor = [UIColor whiteColor];
    self.iconImageBackView.layer.masksToBounds = YES;
    
    
    self.iconWatermarkImageView.image = iconWatermarkImage;
    self.iconWatermarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    
    //银行名字
    self.bankNameLabel.text = [_dicData objectForKey:@"title"];
    self.bankNameLabel.textColor = [UIColor blueColor];
    self.bankNameLabel.font = [UIFont systemFontOfSize:bankNameTextSize];
    
    //银行卡类型
    self.bankTypeLabel.text = [self getBankType];
    self.bankTypeLabel.textColor = [UIColor blueColor];
    self.bankTypeLabel.font = [UIFont systemFontOfSize:bankTypeTextSize];
    
    //银行卡号
    NSDictionary *accountDic = [_dicData objectForKey:@"account"];
    self.bankNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@", [accountDic objectForKey:@"accNo"]];
    self.bankNumLabel.textColor = [UIColor blueColor];
    self.bankNumLabel.font = [UIFont systemFontOfSize:bankNumTextSize];
}

/**
 *  获取类型
 *
 *  @return  类型
 */
- (NSString *)getBankType
{
    NSString *bankType;
    NSString *type = [_dicData objectForKey:@"type"];
    if ([@"1001" isEqualToString:type]) {
        bankType = @"快捷借记卡";
    }
    if ([@"1002" isEqualToString:type]) {
        bankType = @"快捷贷记卡";
    }
    if ([@"1003" isEqualToString:type]) {
        bankType = @"记名卡主账户";
    }
    if ([@"1004" isEqualToString:type]) {
        bankType = @"杉德卡钱包";
    }
    if ([@"1005" isEqualToString:type]) {
        bankType = @"杉德现金账户";
    }
    if ([@"1006" isEqualToString:type]) {
        bankType = @"杉德消费账户";
    }
    if ([@"1007" isEqualToString:type]) {
        bankType = @"久璋宝杉德账户";
    }
    if ([@"1008" isEqualToString:type]) {
        bankType = @"久璋宝专用账户";
    }
    if ([@"1009" isEqualToString:type]) {
        bankType = @"久璋宝通用账户";
    }
    if ([@"1010" isEqualToString:type]) {
        bankType = @"会员卡账户";
    }
    if ([@"1011" isEqualToString:type]) {
        bankType = @"网银借记卡";
    }
    if ([@"1012" isEqualToString:type]) {
        bankType = @"网银贷记卡";
    }
    
    
    return bankType;
}

/**
 *  计算文本的宽高
 *
 *  @param str     需要计算的文本
 *  @param font    文本显示的字体
 *  @param maxSize 文本显示的范围
 *
 *  @return 文本占用的真实宽高
 */
- (CGSize)sizeWithString:(NSString *)str font:(UIFont *)font maxSize:(CGSize)maxSize
{
    NSDictionary *dict = @{NSFontAttributeName : font};
    // 如果将来计算的文字的范围超出了指定的范围,返回的就是指定的范围
    // 如果将来计算的文字的范围小于指定的范围, 返回的就是真实的范围
    CGSize size =  [str boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:dict context:nil].size;
    return size;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end

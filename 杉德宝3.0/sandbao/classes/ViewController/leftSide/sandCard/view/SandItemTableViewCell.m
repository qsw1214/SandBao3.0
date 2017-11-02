//
//  SandItemTableViewCell.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SandItemTableViewCell.h"

#define labelColor RGBA(255, 255, 255, 1.0)

@interface SandItemTableViewCell()

//背景
@property (nonatomic, weak) UIImageView *backgroundImageView;
//渐变色
@property (nonatomic, weak) CAGradientLayer *gradientLayer;
//图标
@property (nonatomic, weak) UIImageView *iconImageView;
//水印
@property (nonatomic, weak) UIImageView *iconWatermarkImageView;
//名字
@property (nonatomic, weak) UILabel *sandNameLabel;
//卡号
@property (nonatomic, weak) UILabel *sandNumLabel;

@end

@implementation SandItemTableViewCell

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
//        [self.backgroundImageView.layer addSublayer:gradientLayer];
        self.gradientLayer = gradientLayer;
        
        //图标
        UIImageView *iconImageView = [[UIImageView alloc] init];
        [self.backgroundImageView addSubview:iconImageView];
        self.iconImageView = iconImageView;
        
        //水印图标
        UIImageView *iconWatermarkImageView = [[UIImageView alloc] init];
        [self.backgroundImageView addSubview:iconWatermarkImageView];
        self.iconWatermarkImageView = iconWatermarkImageView;
        
        //杉德卡名字
        UILabel *sandNameLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:sandNameLabel];
        self.sandNameLabel = sandNameLabel;
        
        //杉德卡号
        UILabel *sandNumLabel = [[UILabel alloc] init];
        [self.backgroundImageView addSubview:sandNumLabel];
        self.sandNumLabel = sandNumLabel;
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
    CGFloat sandNumLabelTop = 2 * leftRightSpace;
    
    UIImage *iconImage = [UIImage imageNamed:@"banklist_abc"];
    CGFloat commLabelW = viewSize.width - 2 * 10 - 2 * 10 - iconImage.size.width - space;
    CGSize sandNameLabelSize = [self.sandNameLabel sizeThatFits:CGSizeMake(commLabelW, MAXFLOAT)];
    CGSize sandNumLabelSize = [self.sandNumLabel sizeThatFits:CGSizeMake(commLabelW, MAXFLOAT)];
    
    CGFloat upDownSpace = (cellHeight - 10 - sandNameLabelSize.height - space - sandNumLabelTop - sandNumLabelSize.height) / 2;
    
    
    //设置背景的frame
    CGFloat backgroundImageViewX = leftRightSpace;
    CGFloat backgroundImageViewY = 10;
    CGFloat backgroundImageViewW = viewSize.width - leftRightSpace * 2;
    CGFloat backgroundImageViewH = cellHeight - 10;
    
    self.backgroundImageView.frame = CGRectMake(backgroundImageViewX, backgroundImageViewY, backgroundImageViewW, backgroundImageViewH);
    self.gradientLayer.frame = self.backgroundImageView.bounds;
    
    
    //设置图标的frame
    CGFloat iconImageViewX= leftRightSpace;
    CGFloat iconImageViewY= upDownSpace;
    CGFloat iconImageViewW=iconImage.size.width;
    CGFloat iconImageViewH=iconImage.size.height;
    
    self.iconImageView.frame = CGRectMake(iconImageViewX, leftRightSpace, iconImageViewW, iconImageViewH);
    
    //设置水印图标fram
    CGFloat iconOffset = 10;
    CGSize iconWatermarkImageViewSize = CGSizeMake(self.iconWatermarkImageView.image.size.width, self.iconWatermarkImageView.image.size.height);
    CGFloat iconWatermarkImageViewY = cellHeight - iconWatermarkImageViewSize.height;
    CGFloat iconWatermarkImageViewX = backgroundImageViewW - iconWatermarkImageViewSize.width;
    self.iconWatermarkImageView.frame = CGRectMake(iconWatermarkImageViewX+iconOffset, iconWatermarkImageViewY, iconWatermarkImageViewSize.width, iconWatermarkImageViewSize.height);

    
    //设置杉德卡名字的frame
    CGFloat sandNameLabelX= iconImageViewX + iconImageViewW + space;
    CGFloat sandNameLabelY= upDownSpace;
    CGFloat sandNameLabelW= commLabelW - iconImage.size.width - 10 *2;
    CGFloat sandNameLabelH= sandNameLabelSize.height;
    
    self.sandNameLabel.frame = CGRectMake(sandNameLabelX, leftRightSpace, sandNameLabelW, sandNameLabelH);
    
    
    //设置杉德卡号的frame
    CGFloat sandNumLabelX= sandNameLabelX;
    CGFloat sandNumLabelY= sandNameLabelY + sandNameLabelH + sandNumLabelTop;
    CGFloat sandNumLabelW= sandNameLabelW;
    CGFloat sandNumLabelH= sandNumLabelSize.height;
    
    self.sandNumLabel.frame = CGRectMake(sandNumLabelX, sandNumLabelY, sandNumLabelW, sandNumLabelH);
}

/**
 *@brief 设置数据
 *@return
 */
- (void)settingData
{
    UIFont *sandNameTextFont = [UIFont fontWithName:@"PingFang-SC-Medium" size:15];
    UIFont *sandNumTextFont  = [UIFont fontWithName:@"DINAlternate-Bold" size:26];
    
    //背景和图标
    UIColor *backgroundColor;
    UIColor *backgroundColor2;
    UIImage *iconImage;
    UIImage *iconWatermarkImage;
    NSString *bankName = [_dicData objectForKey:@"title"];
    if ([bankName rangeOfString:@"杉德"].location != NSNotFound ){
        backgroundColor = [UIColor colorWithRed:234/255.f green:85/255.f blue:115/255.f alpha:1.0];
        iconImage = [UIImage imageNamed:@"sandcards_list_logo"];
        iconWatermarkImage = [UIImage imageNamed:@"watermask_sand"];
    }else{
        backgroundColor = [UIColor colorWithRed:234/255.f green:85/255.f blue:115/255.f alpha:1.0];
        iconImage = [UIImage imageNamed:@"more"];
        iconWatermarkImage = [UIImage imageNamed:@""];
    }
    backgroundColor = [UIColor colorWithRed:234/255.f green:85/255.f blue:115/255.f alpha:1.0];
    backgroundColor2 = [UIColor colorWithRed:140/255.f green:7/255.f blue:7/255.f alpha:1.0];
    
    self.backgroundImageView.layer.cornerRadius = 5;
    self.backgroundImageView.image = [UIImage imageNamed:@"sandcardlistback"];
    self.backgroundImageView.layer.masksToBounds = YES;
    self.backgroundImageView.backgroundColor = backgroundColor;
    self.gradientLayer.colors = @[
                                  (__bridge id)backgroundColor.CGColor,
                                  (__bridge id)backgroundColor2.CGColor
                                  ];
    self.gradientLayer.startPoint = CGPointMake(0.5f, 1);
    self.gradientLayer.endPoint = CGPointMake(0.5f, 0);
    
    self.iconImageView.image = iconImage;
    self.iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    self.iconWatermarkImageView.image = iconWatermarkImage;
    self.iconWatermarkImageView.contentMode = UIViewContentModeScaleAspectFit;
    
    //杉德卡名字
    self.sandNameLabel.text = [_dicData objectForKey:@"title"];
    self.sandNameLabel.textColor = [UIColor whiteColor];
    self.sandNameLabel.font = sandNameTextFont;
    
    //杉德卡号
    NSDictionary *accountDic = [_dicData objectForKey:@"account"];
    self.sandNumLabel.text = [NSString stringWithFormat:@"**** **** **** %@", [accountDic objectForKey:@"accNo"]];
    self.sandNumLabel.textColor = [UIColor whiteColor];
    self.sandNumLabel.font = sandNumTextFont;
    
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    
}

@end

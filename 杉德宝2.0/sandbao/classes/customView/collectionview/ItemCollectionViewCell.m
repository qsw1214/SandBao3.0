//
//  ItemCollectionViewCell.m
//  sandbaocontrol
//
//  Created by tianNanYiHao on 2016/11/2.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "ItemCollectionViewCell.h"
#import "MinletsData.h"

@interface ItemCollectionViewCell()

//图标
@property (nonatomic, strong) UIImageView *iconImageView;
//提示
@property (nonatomic, strong) UILabel *titleLabel;
//日日还
@property (nonatomic, strong) UIButton *stateBtn;

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (nonatomic, assign) CGSize viewSize;

@end

@implementation ItemCollectionViewCell

@synthesize iconImageView;
@synthesize titleLabel;
@synthesize stateBtn;
@synthesize viewSize;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
    {
        viewSize = frame.size;
        [self addView:self.contentView];
    }
    
    return self;
}

/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{
    self.layer.borderColor = [UIColor colorWithWhite:0.95 alpha:1].CGColor;
    self.layer.borderWidth =  1;
    
    UIImage *iconImage = [UIImage imageNamed:@"indicator.png"];
    iconImageView = [[UIImageView alloc] init];
    iconImageView.contentMode = UIViewContentModeScaleAspectFit;
    iconImageView.image = iconImage;
    [view addSubview:iconImageView];
    
    titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"其它";
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = [UIColor blackColor];
    titleLabel.font = [UIFont systemFontOfSize:12];
    [view addSubview:titleLabel];
    
    UIImage *stateBtnImage = [UIImage imageNamed:@"app_add.png"];
    stateBtn = [[UIButton alloc] init];
    [stateBtn setImage:stateBtnImage forState:UIControlStateNormal];
    stateBtn.contentMode = UIViewContentModeScaleAspectFit;
    [stateBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:stateBtn];
    
    //设置组件的位置和大小
    CGFloat stateBtnOX = viewSize.width - stateBtnImage.size.width - 5;
    CGFloat stateBtnOY = 5;
    CGFloat stateBtnW = stateBtnImage.size.width;
    CGFloat stateBtnH = stateBtnW;
    
    stateBtn.frame = CGRectMake(stateBtnOX, stateBtnOY, stateBtnW, stateBtnH);
    
    CGFloat iconImageViewW = iconImage.size.width;
    CGFloat iconImageViewH = iconImageViewW;
    
    CGFloat titleLabelW = viewSize.width;
    CGSize titleLabelSize = [titleLabel sizeThatFits:CGSizeMake(viewSize.width, MAXFLOAT)];
    CGFloat titleLabelH = titleLabelSize.height;
    
    CGFloat space = (viewSize.height - iconImageViewH - titleLabelH - 10) / 2;
    
    CGFloat iconImageViewOX = (viewSize.width - iconImage.size.width) / 2;
    CGFloat iconImageViewOY = space;
    
    
    iconImageView.frame = CGRectMake(iconImageViewOX, iconImageViewOY, iconImageViewW, iconImageViewH);
    
    
    
    
    CGFloat titleLabelOX = 0;
    CGFloat titleLabelOY = iconImageViewOY + iconImageViewH + 10;
    
    titleLabel.frame = CGRectMake(titleLabelOX, titleLabelOY, titleLabelW, titleLabelH);
}

- (void)resetModel:(DataModel *)dataModel :(NSIndexPath *)indexPath {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeButtonState:) name:notification_CellBeganEditing object:nil];
    self.dataModel = dataModel;
    titleLabel.text = dataModel.title;
    self.indexPath = indexPath;
    self.backgroundColor = dataModel.backGroundColor;
    if ([MinletsData shareMinletsData].isEditing) {
        stateBtn.hidden = NO;
        [self showStateButton];
    }else{
        stateBtn.hidden = YES;
    }
}


- (void)showStateButton {
    
//    NSLog(@"打印结果：%@", self.dataModel.title);
    NSString *lets = nil;
    
    switch (self.dataModel.state) {
        case ServeAdd:
            stateBtn.enabled = YES;
            [stateBtn setImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
            break;
        case ServeSelected:
            if (self.indexPath.section == 0) {
                stateBtn.enabled = YES;
                [stateBtn setImage:[UIImage imageNamed:@"app_del"] forState:UIControlStateNormal];
                
            }else {
                NSMutableArray *headArray = [MinletsData shareMinletsData].headArray;
                for (int i = 0; i < [headArray count]; i++) {
                    DataModel *mHeadDataModel = headArray[i];
                    lets = [NSString stringWithFormat:@"%@,%@", lets, mHeadDataModel.letId];
                }
                
                if ([lets rangeOfString:self.dataModel.letId].location != NSNotFound) {
                    stateBtn.enabled = NO;
                    [stateBtn setImage:[UIImage imageNamed:@"app_ok"] forState:UIControlStateNormal];
                    
                }else{
                    stateBtn.enabled = YES;
                    [stateBtn setImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
                }
                
                
                
//                if ([[MinletsData shareMinletsData].headArray containsObject:self.dataModel]) {
//                    stateBtn.enabled = NO;
//                    [stateBtn setImage:[UIImage imageNamed:@"app_ok"] forState:UIControlStateNormal];
//                    
//                }else{
//                    stateBtn.enabled = YES;
//                    [stateBtn setImage:[UIImage imageNamed:@"app_add"] forState:UIControlStateNormal];
//                }
            }
            break;
    }
}


- (void)changeButtonState:(NSNotification *)notification {
    NSString *string = notification.object;
    if ([string isEqualToString:@"yes"]) {
        self.stateBtn.hidden = NO;
        [self showStateButton];
        self.stateBtn.transform = CGAffineTransformMakeScale(0, 0);
        [UIView animateWithDuration:0.1 animations:^{
            self.stateBtn.transform = CGAffineTransformIdentity;
        }];
    }else{
        
        [UIView animateWithDuration:0.1 animations:^{
            self.stateBtn.transform = CGAffineTransformMakeScale(0.001, 0.001);
        } completion:^(BOOL finished) {
            self.stateBtn.transform = CGAffineTransformIdentity;
            self.stateBtn.hidden = YES;
        }];
    }
}

/**
 *@brief 添加按钮添加事件
 *@return
 */

- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    btn.enabled = NO;
    [[NSNotificationCenter defaultCenter] postNotificationName:notification_CellStateChange object:self];
}

@end

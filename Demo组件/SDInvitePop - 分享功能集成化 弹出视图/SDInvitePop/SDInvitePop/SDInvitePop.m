//
//  SDInvitePop.m
//  SDInvitePop
//
//  Created by tianNanYiHao on 2018/1/24.
//  Copyright © 2018年 tianNanYiHao. All rights reserved.
//

#import "SDInvitePop.h"
#import "SDIvitePopCell.h"


#define btn_tag_cancle 200
#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))

@interface SDInvitePop()
{
    //记录各cell的x/y点值
    NSMutableArray *cellPointArr;
}
/**
 透明背景view
 */
@property (nonatomic, strong) UIView *backGroundView;
/**
 遮罩view
 */
@property (nonatomic, strong) UIView *maskBlackView;
/**
 整体高度
 */


/**
 标题数组
 */
@property (nonatomic, strong) NSMutableArray *titleNameArr;

/**
 图片数组
 */
@property (nonatomic, strong) NSMutableArray *iconImgArr;




@property (nonatomic, assign) CGFloat allHeight;
@end

@implementation SDInvitePop



+ (void)showInvitePopView:(NSDictionary*)infoDict{
    
    SDInvitePop *pop = [[SDInvitePop alloc] initWithFrame:CGRectZero];
    pop.backgroundColor = [UIColor colorWithRed:255/255.0 green:255/255.0 blue:255/255.0 alpha:1/1.0];

    pop.titleNameArr = [NSMutableArray arrayWithArray:[infoDict objectForKey:@"title"]];
    pop.iconImgArr = [NSMutableArray arrayWithArray:[infoDict objectForKey:@"icon"]];
    
    //创建分享板
    [pop createInviteView];
    
    //展示分享板
    [pop show];
}

- (void)createInviteView{
    
    CGFloat topBottomSpace = AdapterHfloat(22);
    CGFloat leftRightSpace = AdapterWfloat(55);
    CGFloat cancleBtnH     = AdapterHfloat(45);
    
    //底部取消按钮
    UIButton *cancleBtn = [[UIButton alloc] init];
    cancleBtn.backgroundColor = [UIColor colorWithRed:245/255.0 green:245/255.0 blue:245/255.0 alpha:1/1.0];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    cancleBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(16)];
    [cancleBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [cancleBtn addTarget:self action:@selector(cancleClick:) forControlEvents:UIControlEventTouchUpInside];
    cancleBtn.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, cancleBtnH);
//    [self addSubview:cancleBtn];
    
    //暂定总高
    self.allHeight = topBottomSpace*2 + cancleBtn.frame.size.height;
    
    CGFloat cellAllH =0;  //cell行数总高
    CGFloat cellSpace = 0; //cell间距
    NSInteger allLoc = 3; //cell列数
    
    cellPointArr = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<self.titleNameArr.count; i++) {

        //初始化cell实例
        SDIvitePopCell *cell = [[SDIvitePopCell alloc] init];
        cell.titleName = self.titleNameArr[i];
        cell.iconName =  self.iconImgArr[i];
        [cell createSDIvitePopCell];
        
        //动态计算间距
        cellSpace = (([UIScreen mainScreen].bounds.size.width - 2*leftRightSpace) - allLoc*cell.frame.size.width)/(allLoc-1);
        //行号
        NSInteger row = i / allLoc;
        //列号
        NSInteger loc = i % allLoc;
        
        //计算每个cell位置
        cell.frame = CGRectMake(leftRightSpace+loc*(cellSpace+cell.frame.size.width), topBottomSpace + row*(cell.frame.size.height), cell.frame.size.width, cell.frame.size.height);
        //计算总cell行高
        cellAllH = cell.frame.size.height * (1+row);
        
        [self addSubview:cell];
        
        //记录x/y的point
        [cellPointArr addObject:cell];
        
    }
    
    self.allHeight += cellAllH;
    
    //重置各视图Frame
    self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.allHeight);
    cancleBtn.frame = CGRectMake(0, self.allHeight - cancleBtnH, [UIScreen mainScreen].bounds.size.width, cancleBtnH);
    
    //将取消按钮提升到视图最顶部
    [self insertSubview:cancleBtn atIndex:self.subviews.count];
}


- (void)show{
    
    UIWindow *window = [[UIApplication sharedApplication].windows firstObject];
    [window addSubview:self.backGroundView];
    
    [self showAnimation:YES];
}

- (void)hidden{
    
    [self showAnimation:NO];
}

- (void)showAnimation:(BOOL)isShow{
    
    if (isShow) {
        
        // 展示前 : 将cell统一下沉 300 + i*50
        for (int i = 0; i<cellPointArr.count; i++) {
            SDIvitePopCell *cell = cellPointArr[i];
            cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y + AdapterHfloat(300) + i*AdapterHfloat(50), cell.frame.size.width, cell.frame.size.height);
        }
        
        //1.背景动画
        [UIView animateWithDuration:0.35f animations:^{
            self.maskBlackView.alpha = 0.4f;
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height - self.allHeight, [UIScreen mainScreen].bounds.size.width, self.allHeight);
        } completion:^(BOOL finished) {

        }];
        
        //2.cell动画
        [UIView animateWithDuration:0.55f animations:^{
            // 展示时 : 将cell统一上浮 300 + i*50
            for (int i = 0; i<cellPointArr.count; i++) {
                SDIvitePopCell *cell = cellPointArr[i];
                cell.frame = CGRectMake(cell.frame.origin.x, cell.frame.origin.y - AdapterHfloat(300) - i*AdapterHfloat(50), cell.frame.size.width, cell.frame.size.height);
            }
        }];
    }
    if (!isShow) {
        [UIView animateWithDuration:0.35f animations:^{
            self.maskBlackView.alpha = 0.f;
            self.frame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, self.allHeight);
        } completion:^(BOOL finished) {
            [self.backGroundView removeFromSuperview];
            [self.maskBlackView removeFromSuperview];
            [self removeFromSuperview];
        }];
    }
}


-(UIView*)backGroundView{
    
    if (!_backGroundView) {
        _backGroundView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _backGroundView.backgroundColor = [UIColor clearColor];
        
        //背景View 添加 遮罩
        [_backGroundView addSubview:self.maskBlackView];
        //背景View 添加 popView
        [_backGroundView addSubview:self];
    }
    return _backGroundView;
}

-(UIView*)maskBlackView{
    if (!_maskBlackView) {
        _maskBlackView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _maskBlackView.backgroundColor = [UIColor blackColor];
        _maskBlackView.alpha = 0.f;
        UITapGestureRecognizer *tapGest = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(hidden)];
        [_maskBlackView addGestureRecognizer:tapGest];
        
    }
    return _maskBlackView;
}


- (void)cancleClick:(UIButton*)btn{
    
    [self hidden];
    
}


@end

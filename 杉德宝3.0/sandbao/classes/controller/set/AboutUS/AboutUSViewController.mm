//
//  AboutUSViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/22.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AboutUSViewController.h"
#import "PayNucHelper.h"
#import "SDLog.h"


#import "CommParameter.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"

#define navbarColor RGBA(255, 255, 255, 1.0)

#define navViewColor RGBA(249, 249, 249, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define btnColor RGBA(255, 97, 51, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)
@interface AboutUSViewController (){
    NavCoverView *navCoverView;
    CGSize viewSize;
    CGFloat viewTop;
    CGFloat textSize;
    CGFloat tableViewTop;
    CGFloat leftRightSpace;
}
@property (weak, nonatomic) IBOutlet UIImageView *iconImage;
@property (weak, nonatomic) IBOutlet UILabel *deviceLab;
@property (nonatomic, strong) SDMBProgressView *HUD;

@end

@implementation AboutUSViewController
@synthesize HUD;


- (void)viewDidLoad {
    [super viewDidLoad];
    
    leftRightSpace = 15;
    
    [self.view setBackgroundColor:RGBA(242, 242, 242, 1.0)];
    
    
    

    
    
    [self settingNavigationBar];
    [self setFrame];

    
}
-(void)setFrame{
    NSString *strVersion = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"] ;
    _deviceLab.text = [NSString stringWithFormat:@"版本号: %@",strVersion];
    _deviceLab.textColor = [UIColor lightGrayColor];
    
    CGSize deviceLabSize = [_deviceLab.text sizeWithNSStringFont:[UIFont systemFontOfSize:9]];

    [_iconImage mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(controllerTop*2);
        make.centerX.equalTo(self.view.mas_centerX).offset(0);
    }];
    
    [_deviceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_iconImage.mas_bottom).offset(leftRightSpace);
        make.centerX.equalTo(_iconImage.mas_centerX).offset(0);
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width, deviceLabSize.height));
    }];
}

#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{
    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0,[UIScreen mainScreen].bounds.size.width, controllerTop) title:@"设置"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
}


#pragma mark - 按钮事件处理事情
/**
 *@brief 添加按钮添加事件
 *@return
 */
- (void)buttonActionToDoSomething:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    switch (btn.tag) {
        case 1:
        {
            
        }
            break;
        case 2:
        {
            
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
            
        default:
            break;
    }
}

@end

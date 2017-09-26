//
//  SuccessPhoneNoViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/2/27.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SuccessPhoneNoViewController.h"
#import "CommParameter.h"
#import "SDSuccessAnimationView.h"



@interface SuccessPhoneNoViewController ()
{
    NavCoverView *navCoverView;
    SDSuccessAnimationView *circleSuccessView;
    
    CGFloat btnfont;
    CGFloat leftRightSpace;
    CGFloat textSize;
    
}


@property (nonatomic, assign) CGSize viewSize;
@property (weak, nonatomic) IBOutlet UILabel *titleLab;

@property (weak, nonatomic) IBOutlet UILabel *phoneNumLab;
@property (weak, nonatomic) IBOutlet UILabel *phoneNUM;
@property (weak, nonatomic) IBOutlet UIView *bgVIew;

@end

@implementation SuccessPhoneNoViewController
@synthesize viewSize;


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    leftRightSpace = 15;
    [self.view setBackgroundColor:RGBA(247, 245, 244, 1.0)];
    viewSize = self.view.bounds.size;
    
    
    
    _phoneNUM.text = [NSString stringWithFormat:@"%@",[NSString phoneNumFormat:_phoneNum]];
    
    //成功 则set phoneNo
    [CommParameter sharedInstance].phoneNo = _phoneNUM.text;
     
    

        _titleLab.font = [UIFont systemFontOfSize:17];
        _phoneNumLab.font = [UIFont systemFontOfSize:18];
        _phoneNUM.font = [UIFont systemFontOfSize:18];
        btnfont = 13;
        textSize = 14;

    [self settingNavigationBar];
    //4.渐变色
    CAGradientLayer *layerRGB = [CAGradientLayer layer];
    layerRGB.frame = _bgVIew.bounds;
    layerRGB.startPoint = CGPointMake(0, 0);
    layerRGB.endPoint = CGPointMake(0, 1);
    layerRGB.colors = @[(__bridge id)RGBA(96, 224, 178, 1.0).CGColor,(__bridge id)RGBA(29, 204, 140, 1.0).CGColor];
    [_bgVIew.layer insertSublayer:layerRGB atIndex:0];
    
    
    
    [self addview:self.view];
    
    
    
    
    
}
- (void)settingNavigationBar
{

    //导航渐变条
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"更换手机号"];
    
    // 3.设置右边的返回item
    UILabel *rightLab = [[UILabel alloc] init];
    rightLab.textColor = [UIColor whiteColor];
    rightLab.textAlignment = NSTextAlignmentRight;
    rightLab.font = [UIFont systemFontOfSize:textSize];
    rightLab.text = @"完成";
    [self.view addSubview:rightLab];
    
    UIButton *rightBarBtn = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    rightBarBtn.tag = 102;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    CGSize size= [@"完成" sizeWithNSStringFont:[UIFont systemFontOfSize:textSize]];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [self.view addSubview:rightBarBtn];
    
    [rightLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    
    [rightBarBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(20+leftRightSpace);
        make.right.equalTo(self.view.mas_right).offset(-leftRightSpace);
        make.size.mas_equalTo(CGSizeMake(size.width, size.height));
    }];
    
}


- (void)addview:(UIView*)view{
    
    //圆
    UIImage *successImg = [UIImage imageNamed:@"success"];
    circleSuccessView = [SDSuccessAnimationView createCircleSuccessView:CGRectMake(0, 0, successImg.size.width, successImg.size.height)];
    circleSuccessView.circleLineWidth = 6.5f;
    circleSuccessView.lineSuccessColor = RGBA(255, 255, 255, 1);
    [circleSuccessView buildPath];
    [_bgVIew addSubview:circleSuccessView];
    [circleSuccessView animationStart];

    
    CGFloat successImgTopSpace = 90;
    CGFloat successLabTop = 30;
    CGFloat sucessDecLabTop = 68;
    CGFloat labSizeH = [_phoneNUM.text sizeWithNSStringFont:_titleLab.font].height;
    
    [circleSuccessView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_bgVIew.mas_top).offset(successImgTopSpace);
        make.centerX.equalTo(_bgVIew.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(successImg.size.width, successImg.size.height));
    }];
    
    
    [_titleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(circleSuccessView.mas_bottom).offset(successImgTopSpace);
        make.centerX.equalTo(_bgVIew.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, labSizeH));
    }];
    
    [_phoneNumLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_titleLab.mas_bottom).offset(sucessDecLabTop);
        make.centerX.equalTo(_bgVIew.mas_centerX);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, labSizeH));
    }];
    
    [_phoneNUM mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(_phoneNumLab.mas_bottom).offset(successLabTop);
        make.centerX.equalTo(_bgVIew.mas_centerX);
       make.size.mas_equalTo(CGSizeMake(viewSize.width, labSizeH));
    }];
    

    
}

- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    if(btn.tag == 1) {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:1];
    } else {
        [[self class] cancelPreviousPerformRequestsWithTarget:self selector:@selector(buttonActionToDoSomething:) object:sender];
        [self performSelector:@selector(buttonActionToDoSomething:) withObject:sender afterDelay:0];
    }
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
//            [self dismissKeyboard];
//            [self verificationInput];
        }
            break;
        case 201:
        {
//            [self dismissKeyboard];
//            shortMsgTextField.text = @"";
//            timeCount = timeOut;
//            [self shortMsg];
        }
            break;
        case 202:
        {
//            [self dismissKeyboard];
            //            [self verificationInput];
        }
            break;
        case 203:
        {
//            [self dismissKeyboard];
            //            [self verificationInput];
        }
            break;
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            [self.navigationController popToRootViewControllerAnimated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end

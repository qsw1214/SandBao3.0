//
//  NickNameViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "NickNameViewController.h"
#import "PayNucHelper.h"

@interface NickNameViewController ()
{
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString *nickNameStr;
@end

@implementation NickNameViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    
    self.baseScrollView.backgroundColor = COLOR_F5F5F5;
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"昵称修改";
    
    __weak NickNameViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    [self.baseScrollView endEditing:YES];
    
    if (btn.tag == BTN_TAG_NEXT) {
        if (self.nickNameStr.length>0) {
            
            //修改用户基础信息(昵称)
            [self resetUserBaseInfo];
        }else{
            [Tool showDialog:@"请输入您的昵称信息"];
        }
    }
}


#pragma mark  - UI绘制
- (void)createUI{
    __weak typeof(self) weakself = self;
    //nickNameAuthToolView
    NameAuthToolView *nickNameAuthToolView = [NameAuthToolView createAuthToolViewOY:0];
    nickNameAuthToolView.titleLab.text = @"昵称";
    nickNameAuthToolView.textfiled.placeholder = @"请填写您的昵称";
    nickNameAuthToolView.tip.text = @"请正确输入您的昵称";
    nickNameAuthToolView.successBlock = ^(NSString *textfieldText) {
        weakself.nickNameStr = textfieldText;
    };
    [self.baseScrollView addSubview:nickNameAuthToolView];
    
    //nextBtn
    barButton = [[SDBarButton alloc] init];
    UIView *nextBarbtn = [barButton createBarButton:@"提交" font:FONT_15_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_NEXT;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:nextBarbtn];
    
    [nickNameAuthToolView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_30);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(nickNameAuthToolView.size);
    }];
    
    [nextBarbtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(nickNameAuthToolView.mas_bottom).offset(UPDOWNSPACE_40);
        make.centerX.equalTo(self.baseScrollView.mas_centerX);
        make.size.mas_equalTo(nextBarbtn.size);
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[nickNameAuthToolView.textfiled]];
    for (int i = 0 ; i<self.textfiledArr.count; i++) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textFieldChange:) name:UITextFieldTextDidEndEditingNotification object:self.textfiledArr[i]];
    }
}

- (void)textFieldChange:(NSNotification*)noti{
    
    //按钮置灰不可点击
    UITextField *currentTextField = (UITextField*)noti.object;
    if (currentTextField.text.length == 0) {
        [barButton changeState:NO];
    }
    
    //按钮高亮可点击
    NSMutableArray *tempArr = [NSMutableArray arrayWithCapacity:0];
    for (UITextField *t in self.textfiledArr) {
        if ([t.text length]>0) {
            [tempArr addObject:t];
        }
        if (tempArr.count == self.textfiledArr.count) {
            [barButton changeState:YES];
        }
    }
}


#pragma mark - 业务逻辑
#pragma mark 用户基础信息修改
-(void)resetUserBaseInfo{
    
   
}









- (void)dealloc{
    //清除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end

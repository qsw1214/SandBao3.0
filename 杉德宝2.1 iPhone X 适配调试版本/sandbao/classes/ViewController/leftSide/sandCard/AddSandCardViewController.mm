//
//  AddSandCardViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/11/17.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "AddSandCardViewController.h"
#import "PayNucHelper.h"


@interface AddSandCardViewController ()
{
    SDBarButton *barButton;
}
@property (nonatomic, strong) NSString *sandCardNoStr;
@property (nonatomic, strong) NSString *sandCardCodeStr;  //杉德卡密码

@property (nonatomic, strong) UIView *bottomBtn;

@end

@implementation AddSandCardViewController

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    //绑卡_查询鉴权工具
    [self bingding_getAuthTools];
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self createUI];
    
}


#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.style = NavCoverStyleWhite;
    self.navCoverView.letfImgStr = @"login_icon_back";
    self.navCoverView.midTitleStr = @"添加杉德卡";
    
    __weak AddSandCardViewController *weakSelf = self;
    self.navCoverView.leftBlock = ^{
        [weakSelf.navigationController popViewControllerAnimated:YES];
    };
    
    self.navCoverView.rightBlock = ^{
        
    };
    
}
#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_BINDSANDCARD) {
        if (self.sandCardNoStr.length>0 && self.sandCardCodeStr.length>0) {
            //绑定杉德卡
            [self bindingSandCard];
            
        }else{
            [Tool showDialog:@"请完成卡信息填写"];
        }
    }
    
}

#pragma mark  - UI绘制
- (void)createUI{
    
    __weak typeof(self) weakself = self;
    
    //sandCardNoView
    SandCardNoAuthToolView *sandCardNoView = [SandCardNoAuthToolView createAuthToolViewOY:0];
    sandCardNoView.backgroundColor = [UIColor whiteColor];
    sandCardNoView.titleLab.text = @"杉德卡卡号";
    sandCardNoView.tip.text = @"请输入正确杉德卡卡号";
    sandCardNoView.textfiled.placeholder = @"请输入杉德卡卡号";
    sandCardNoView.textfiled.text = SHOWTOTEST(@"7280000100004581");
    self.sandCardNoStr = SHOWTOTEST(@"7280000100004581");
    sandCardNoView.successBlock = ^(NSString *textfieldText) {
        weakself.sandCardNoStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardNoView];
    
    //sandCardCodeView
    PwdAuthToolView *sandCardCodeView = [PwdAuthToolView createAuthToolViewOY:0];
    sandCardCodeView.type = PwdAuthToolSandPayPwdType;
    sandCardCodeView.backgroundColor = [UIColor whiteColor];
    sandCardCodeView.titleLab.text = @"杉德卡支付密码";
    sandCardCodeView.textfiled.placeholder  = @"请输入杉德卡支付密码";
    sandCardCodeView.tip.text = @"请输入正确的杉德卡支付密码";
    sandCardCodeView.textfiled.text = SHOWTOTEST(@"728060");
    self.sandCardCodeStr = SHOWTOTEST(@"728060");
    sandCardCodeView.successBlock = ^(NSString *textfieldText) {
        weakself.sandCardCodeStr = textfieldText;
    };
    [self.baseScrollView addSubview:sandCardCodeView];
    
    //bottomBtn
    barButton = [[SDBarButton alloc] init];
    self.bottomBtn = [barButton createBarButton:@"绑定并开通快捷" font:FONT_14_Regular titleColor:COLOR_FFFFFF backGroundColor:COLOR_58A5F6 leftSpace:LEFTRIGHTSPACE_40];
    barButton.btn.tag = BTN_TAG_BINDSANDCARD;
    [barButton.btn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.baseScrollView addSubview:self.bottomBtn];
    
    
    //温馨提示
    UILabel *tipTitleLab = [Tool createLable:@"温馨提示" attributeStr:nil font:FONT_15_Medium textColor:COLOR_000000 alignment:NSTextAlignmentLeft];
    [self.baseScrollView addSubview:tipTitleLab];
    
    //tipDetail
    //设置文字排版
    NSMutableParagraphStyle *MParaStyle = [[NSMutableParagraphStyle alloc] init];
    MParaStyle.alignment =  NSTextAlignmentNatural;  // 文字站位
    MParaStyle.maximumLineHeight = 20;  // 最大高度
    MParaStyle.lineHeightMultiple = 10 ;  //  平均高度
    MParaStyle.minimumLineHeight = 0;  // 最小高度
    MParaStyle.firstLineHeadIndent = 0; // 首行缩进
    MParaStyle.lineSpacing = 0; // 行间距
    MParaStyle.headIndent = 0;  // 左侧整体缩进
    MParaStyle.tailIndent = SCREEN_WIDTH - 20;  //  右侧整体缩进
    MParaStyle.lineBreakMode = NSLineBreakByCharWrapping; // 内容省略方式
    MParaStyle.baseWritingDirection = NSWritingDirectionLeftToRight;  // 书写方式
    MParaStyle.paragraphSpacingBefore = 5;  // 段落之间间距
    MParaStyle.paragraphSpacing = 0; // 段落间距离
    
    NSMutableDictionary *attributes = [NSMutableDictionary new];
    // 添加paragraphStyle
    [attributes setObject:MParaStyle forKey:NSParagraphStyleAttributeName];
    // 添加font
    [attributes setObject:FONT_12_Regular forKey:NSFontAttributeName];
    
    NSAttributedString *text = [[NSAttributedString alloc] initWithString:@"1.开通快捷服务后，当您在杉德宝内使用杉德卡进行支付时，仅需输入杉德宝的支付密码即可完成付款完成操作；\n2.若使用该杉德卡进行线下消费或主账户圈存，仍需输入杉德卡支付密码进行校验。" attributes:attributes];
    
    UITextView *tipDetailTextview = [[UITextView alloc] init];
    [tipDetailTextview setAttributedText:text];
    tipDetailTextview.textColor = COLOR_343339_5;
    [self.baseScrollView addSubview:tipDetailTextview];
    
    
    

    [sandCardNoView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.baseScrollView.mas_top).offset(UPDOWNSPACE_20);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandCardNoView.size);
    }];
    
    [sandCardCodeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(sandCardNoView.mas_bottom);
        make.centerX.equalTo(self.baseScrollView);
        make.size.mas_equalTo(sandCardCodeView.size);
    }];
    
    [self.bottomBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.baseScrollView);
        make.top.equalTo(sandCardCodeView.mas_bottom).offset(UPDOWNSPACE_64);
        make.size.mas_equalTo(self.bottomBtn.size);
    }];
    
    [tipTitleLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBtn.mas_left);
        make.top.equalTo(self.bottomBtn.mas_bottom).offset(UPDOWNSPACE_50);
        make.size.mas_equalTo(tipTitleLab.size);
    }];
    
    [tipDetailTextview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomBtn.mas_left);
        make.top.equalTo(tipTitleLab.mas_bottom).offset(UPDOWNSPACE_10);
        make.size.mas_equalTo(CGSizeMake(self.bottomBtn.width, UPDOWNSPACE_160));
    }];
    
    //装载所有的textfiled
    self.textfiledArr = [NSMutableArray arrayWithArray:@[sandCardNoView.textfiled,sandCardCodeView.textfiled]];
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
#pragma mark 绑卡_查询鉴权工具
- (void)bingding_getAuthTools
{
    
}

#pragma mark - 绑定杉德卡
- (void)bindingSandCard
{
    
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

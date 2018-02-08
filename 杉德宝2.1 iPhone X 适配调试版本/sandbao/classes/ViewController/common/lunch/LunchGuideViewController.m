//
//  LunchGuideViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/12/15.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "LunchGuideViewController.h"
#import "LFFAuthorizationManager.h"
#import "SDAuthorazithonPopView.h"

//首次安装 - 引导页 

@interface LunchGuideViewController ()<UIScrollViewDelegate>
{
    NSArray *imgeNameArr;
    UIScrollView *imgScrollerView;
}
@end

@implementation LunchGuideViewController

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setBaseInfo];
    
}

#pragma mark - 重写父类-baseScrollView设置
- (void)setBaseScrollview{
    [super setBaseScrollview];
    [self.baseScrollView removeFromSuperview];
}
#pragma mark - 重写父类-导航设置方法
- (void)setNavCoverView{
    [super setNavCoverView];
    self.navCoverView.hidden = YES;
}

#pragma mark - 重写父类-点击方法集合
- (void)buttonClick:(UIButton *)btn{
    
    if (btn.tag == BTN_TAG_NEXT) {
        [Tool setContentViewControllerWithLoginFromSideMentuVIewController:self forLogOut:NO];
        [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:FIRST_INSTALL_APP];
    }
 
}

#pragma mark  - UI绘制
- (void)setBaseInfo{
    imgeNameArr = @[@"guiedeOne",@"guiedeTwo",@"guiedeThree",@"guiedeFour"];
    
    imgScrollerView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    imgScrollerView.contentSize = CGSizeMake(SCREEN_WIDTH*imgeNameArr.count, SCREEN_HEIGHT);
    imgScrollerView.showsVerticalScrollIndicator = NO;
    imgScrollerView.showsHorizontalScrollIndicator = NO;
    imgScrollerView.pagingEnabled = YES;
    imgScrollerView.scrollEnabled = YES;
    imgScrollerView.delegate = self;
    imgScrollerView.bounces = NO;  //取消弹簧效果!
    [self.view addSubview:imgScrollerView];
    
    
    
    for (int i = 0; i<imgeNameArr.count; i++) {
        
        UIImageView *imgCell = [[UIImageView alloc] init];
        imgCell.image = [UIImage imageNamed:imgeNameArr[i]];
        imgCell.userInteractionEnabled = YES;
        imgCell.frame = CGRectMake(i*SCREEN_WIDTH, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
        [imgScrollerView addSubview:imgCell];
        
        //最后一张加按钮!
        if (i == imgeNameArr.count-1) {
            UIButton *nextBtn = [[UIButton alloc] init];
            nextBtn.backgroundColor = [UIColor clearColor];
            nextBtn.tag = BTN_TAG_NEXT;
            nextBtn.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
            [nextBtn addTarget:self action:@selector(buttonClick:) forControlEvents:UIControlEventTouchUpInside];
            [imgCell addSubview:nextBtn];
            //弹出权限授予框
            [self setAuthorization];
        }
    }
    

}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if (scrollView.contentSize.width == SCREEN_WIDTH*imgeNameArr.count) {
        
    }
    
}


#pragma mark - 设置访问权限
- (void)setAuthorization{
    
    SDAuthorazithonPopView *authorizationPop = [SDAuthorazithonPopView showRechargePopView:@"体验更多功能" rechargeChooseBlock:^(NSString *cellName) {
        if ([cellName isEqualToString:@"允许访问麦克风"]) {
            [[LFFAuthorizationManager defaultManager] requestAudioAccess];
        }
        if ([cellName isEqualToString:@"允许访问相机"]) {
            [[LFFAuthorizationManager defaultManager] requestCameraAccess];
        }
        if ([cellName isEqualToString:@"允许访问相册"]) {
            [[LFFAuthorizationManager defaultManager] requestPhotoLibraryAccess];
        }
        if ([cellName isEqualToString:@"允许访问通讯录"]) {
            [[LFFAuthorizationManager defaultManager] requestAddressBookAccess];
        }
    }];
    authorizationPop.chooseBtnTitleArr = @[@"允许访问麦克风",@"允许访问相机",@"允许访问相册",@"允许访问通讯录"];
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

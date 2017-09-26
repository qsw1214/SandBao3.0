//
//  MinletsManagerViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2016/11/25.
//  Copyright © 2016年 sand. All rights reserved.
//

#import "MinletsManagerViewController.h"
#import "ItemCollectionViewCell.h"
#import "DataModel.h"
#import "DragCellCollectionView.h"
#import "MinletsData.h"
#import "HeaderCollectionReusableView.h"
#import "FooterCollectionReusableView.h"
#import "SDSqlite.h"
#import "SqliteHelper.h"
#import "CommParameter.h"
#import "SDMajletView.h"


@interface MinletsManagerViewController ()<DragCellCollectionViewDataSource, DragCellCollectionViewDelegate>
{
    NavCoverView *navCoverView;
    SDMajletView *majletView;
}

@property (nonatomic, assign) CGSize viewSize;

@property (nonatomic, strong) NSArray *data;

@property (nonatomic, strong) UIButton *rightBarBtn;

@property (nonatomic, strong) NSMutableArray *tempArray;

@end

@implementation MinletsManagerViewController


@synthesize viewSize;


@synthesize data;
@synthesize rightBarBtn;
@synthesize tempArray;


- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    //清除 majletView
    [majletView removeFromSuperview];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    viewSize = self.view.bounds.size;
    
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    [self settingNavigationBar];

    //获取当前用户的Minlets
    [self addView:self.view];
}


#pragma mark - 设置导航栏
/**
 *@brief 设置导航栏
 *@return
 */
- (void)settingNavigationBar
{

    //导航渐变条
    //衫德宝
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"杉德宝"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    [leftBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    // 3.设置右边的返回item
    rightBarBtn = [[UIButton alloc] init];
    rightBarBtn.tag = 102;
    [rightBarBtn setTitle:@"提交" forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    [rightBarBtn setTitleColor:RGBA(223, 223, 246, 1.0) forState:UIControlStateHighlighted];
    [rightBarBtn setTitleEdgeInsets:UIEdgeInsetsMake(0.0, 10.0, 0.0, 0.0)];
    rightBarBtn.titleLabel.font = [UIFont systemFontOfSize:13];
    [rightBarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    
    CGSize rightBtnTitleSize = [rightBarBtn.titleLabel.text sizeWithAttributes:@{NSFontAttributeName:rightBarBtn.titleLabel.font}];
    
    rightBarBtn.frame = CGRectMake(viewSize.width - 37.0 - rightBtnTitleSize.width, 22.0 + (64 - 22 - rightBtnTitleSize.height -20) / 2, rightBtnTitleSize.width + 30, rightBtnTitleSize.height + 20);
    [navCoverView addSubview:rightBarBtn];
}


#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view{
    
    
    //1获取当前用户子件ID
    NSString *userlets = [SDSqlite selectStringData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnName:@"lets" whereColumnString:@"uid" whereParamString: [CommParameter sharedInstance].userId];
    NSArray *userletArr  = [NSJSONSerialization JSONObjectWithData:[userlets dataUsingEncoding:NSUTF8StringEncoding] options:NSJSONReadingMutableLeaves error:nil];
    //为匹配用户子件ID与所有子件ID的,故变换用户子件数据中的key字段为(letId -> id)
    NSMutableArray *userletArrNew = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0;  i < userletArr.count; i++) {
        NSString *valueID = [userletArr[i] objectForKey:@"letId"];
        NSMutableDictionary *dic = [NSMutableDictionary dictionaryWithCapacity:0];
        [dic setValue:valueID forKey:@"id"];
        [userletArrNew addObject:dic];
    }
    //2获取minlets 所有子件ID
    NSMutableArray *minletsArray = [SDSqlite selectData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:(NSMutableArray*)@[@"id"]];
    
    //3获取未使用的子件ID
    NSMutableArray *unuseLetIdArr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary *dic in minletsArray) {
        if (![userletArrNew containsObject:dic]) {
            [unuseLetIdArr addObject:dic];
        }
    }
    
    
    //一,获取inuses数组
    NSMutableArray *arrInuses = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<userletArr.count; i++) {
        //获取每个letId对应的数据
        NSMutableDictionary *inUseDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR whereColumnString:@"id" whereParamString:[userletArr[i] objectForKey:@"letId"]];
        [arrInuses addObject:inUseDic];
    }
    //二 获取unuses数组
    NSMutableArray *arrUnuses = [NSMutableArray arrayWithCapacity:0];
    for (int i = 0; i<unuseLetIdArr.count; i++) {
        NSMutableDictionary *unUseDic = [SDSqlite selectOneData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"minlets" columnArray:MINLETS_ARR whereColumnString:@"id" whereParamString:[unuseLetIdArr[i] objectForKey:@"id"]];
        [arrUnuses addObject:unUseDic];
    }
    
    majletView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height-64)];
    majletView.inUseTitles = arrInuses;
    majletView.unUseTitles = arrUnuses;
    [self.view addSubview:majletView];
}



/**
 *@brief 添加按钮添加事件
 *@param view UIButton 参数：按钮
 *@param view tag 参数：按钮的类型
 *@return
 */

- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [UIApplication sharedApplication].statusBarHidden = NO;
    switch (btn.tag) {
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            //提交
            [self commitChange];
        
        }
            break;
        default:
            break;
    }
}



/**
 提交修改
 */
- (void)commitChange{
    [majletView callBacktitlesBlock:^(NSMutableArray *inusesTitles, NSMutableArray *unusesTitles) {
        [SDLog logTest:[NSString stringWithFormat:@"%@",inusesTitles]];
        [SDLog logTest:[NSString stringWithFormat:@"%@",unusesTitles]];
        
        NSMutableArray *letsArr = [NSMutableArray arrayWithCapacity:0];
        for (int i = 0; i<inusesTitles.count; i++) {
            NSString *letId = [inusesTitles[i] objectForKey:@"id"]; //从可用数组中获取id号
            [SDLog logTest:letId];
            NSMutableDictionary *letsDic = [NSMutableDictionary  dictionaryWithCapacity:0];
            [letsDic setObject:letId forKey:@"letId"]; //数据转换为userconfig库中表lets的格式 letId:(value)
            [letsArr addObject:letsDic];
        }
        NSData *letsJsonData = [NSJSONSerialization dataWithJSONObject:letsArr options:NSJSONWritingPrettyPrinted error:nil];
        NSString *letsJsonStr = [[NSString alloc] initWithData:letsJsonData encoding:NSUTF8StringEncoding];
        letsJsonStr =  [[letsJsonStr stringByReplacingOccurrencesOfString:@"\n" withString:@""] stringByReplacingOccurrencesOfString:@" " withString:@""];
        [SDLog logTest:letsJsonStr];
        
        //更新当前用户的let值
        BOOL success = [SDSqlite updateData:[SqliteHelper shareSqliteHelper].sandBaoDB tableName:@"usersconfig" columnArray:(NSMutableArray*)@[@"lets"] paramArray:(NSMutableArray*)@[letsJsonStr] whereColumnString:@"uid" whereParamString:[CommParameter sharedInstance].userId];
        if (success) {
            [Tool showDialog:@"修改完成" defulBlock:^{
            [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end

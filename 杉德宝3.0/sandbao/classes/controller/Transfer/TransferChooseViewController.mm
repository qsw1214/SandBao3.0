//
//  Transfer BeginViewController.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/23.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "TransferChooseViewController.h"


#import "SDLog.h"
#import "CommParameter.h"
#import "SDCircleView.h"
#import "PayNucHelper.h"
#import "TransferTableViewCell.h"
#import "TransferPayViewController.h"
#import "TransferPayToolSelMode.h"


#define navbarColor RGBA(242, 242, 242, 1.0)

#define navViewColor RGBA(255, 125, 50, 1.0)

#define lineViewColor RGBA(237, 237, 237, 1.0)

#define titleColor RGBA(174, 174, 174, 1.0)

#define textFiledColor RGBA(83, 83, 83, 1.0)

#define textFiledColordarkBlue RGBA(43, 56, 87, 1.0)

#define textFiledColorBlue  RGBA(65, 131, 215, 1.0)

#define textFiledColorlightGray RGBA(191, 195, 204, 1.0)

#define viewColor RGBA(255, 255, 255, 1.0)

@interface TransferChooseViewController ()<UITableViewDelegate,UITableViewDataSource,TransferTableViewCellDelegate>
{
    NavCoverView *navCoverView;
    TransferPayToolSelMode *modelM;
    CGSize viewSize;
    CGFloat titleTextSize;
    CGFloat labelTextSize;
    CGFloat lineViewHeight;
    CGFloat leftRightSpace;
    CGFloat celldefulHeight;
    CGFloat cellallHeight;
    CGFloat commWidth;
    CGFloat newxtBtnH;
    SDCircleView *circleView;
    
    UIScrollView *scrollView;
    NSArray *authToolsArray;
    
    CGFloat textFieldTextSize;
    CGFloat textSize;
    
    NSMutableDictionary *workDicGet;
    NSMutableDictionary *inPayToolDic;
    NSMutableDictionary *outPayToolDic;
    
    UIView *tipView;
    UITableView *tbaleView;
    UIButton *nextBtn;
    UIButton *selectBtn; //全局属性
    TransferTableViewCell *transFerCell;
    NSInteger selectIndexPathRow;
}
@property (nonatomic,strong)NSMutableArray *cellInfoModelArr;
@property (nonatomic,strong)NSMutableArray *selectedArray;
@property (nonatomic, strong) SDMBProgressView *HUD;

@end


@implementation TransferChooseViewController
@synthesize HUD;

/**
 选中的对象数组
 */
- (NSMutableArray *)selectedArray{
    if (!_selectedArray) {
        _selectedArray = [NSMutableArray new];
    }return _selectedArray;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.selectedArray.count>0) {
        [self.selectedArray removeAllObjects];
    }
    
}
-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    tbaleView.frame = CGRectMake(0, CGRectGetMaxY(tipView.frame), viewSize.width, celldefulHeight*_inpayToolsArr.count);
    nextBtn.frame = CGRectMake(leftRightSpace, CGRectGetMaxY(tbaleView.frame)+50, commWidth, newxtBtnH);
    
    [self cleanPayToolDict];  //未选,清空两方支付工具
    [self changeBtnBackGround:nil index:2];
    [tbaleView reloadData];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //转账step1
    [self.view setBackgroundColor:RGBA(248, 248, 248, 1.0)];
    viewSize = self.view.bounds.size;
    leftRightSpace = 15;
    lineViewHeight = 1;
    workDicGet = [NSMutableDictionary dictionaryWithCapacity:0];
    _cellInfoModelArr = [NSMutableArray arrayWithCapacity:0];
    
    
    

    
    self.navigationController.navigationBarHidden = YES;
    [self settingNavigationBar];
    [self setModelData];
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
    navCoverView = [NavCoverView shareNavCoverView:CGRectMake(0, 0, viewSize.width, controllerTop) title:@"选择账户"];
    [self.view addSubview:navCoverView];
    
    // 2.设置左边的返回item
    UIImage *leftImage = [UIImage imageNamed:@"back"];
    UIButton *leftBarBtn = [[UIButton alloc] init];
    leftBarBtn.frame = CGRectMake(0, 20 + (40 - leftImage.size.height) / 2, leftImage.size.width, leftImage.size.height);
    leftBarBtn.tag = 101;
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    [leftBarBtn setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
    leftBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [leftBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:leftBarBtn];
    
    
    // 3.设置右边的返回item
    UIImage *rightImage = [UIImage imageNamed:@"record"];
    UIButton *rightBarBtn = [[UIButton alloc] init];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateNormal];
    [rightBarBtn setImage:[UIImage imageNamed:@"record"] forState:UIControlStateHighlighted];
    rightBarBtn.frame = CGRectMake(viewSize.width - 10 - rightImage.size.width, 20 + (40 - rightImage.size.height) / 2, rightImage.size.width, rightImage.size.height);
    rightBarBtn.tag = 102;
    rightBarBtn.contentMode = UIViewContentModeScaleAspectFit;
    [rightBarBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [navCoverView addSubview:rightBarBtn];
}

#pragma mark - 创建组件
/**
 *@brief 创建组件
 *@param view UIView 参数：组件
 *@return
 */
-(void)addView:(UIView *)view
{

        textFieldTextSize = 14;
        textSize = 14;
        titleTextSize = 12;


    //创建UIScrollView
    scrollView = [[UIScrollView alloc] init];
    scrollView.userInteractionEnabled = YES;
    scrollView.scrollEnabled = YES;
    scrollView.contentSize = CGSizeMake(viewSize.width, viewSize.height - controllerTop);
    scrollView.directionalLockEnabled = YES; //只能一个方向滑动
    scrollView.pagingEnabled = NO; //是否翻页
    scrollView.showsVerticalScrollIndicator =YES; //垂直方向的滚动指示
    scrollView.indicatorStyle = UIScrollViewIndicatorStyleWhite;//滚动指示的风格
    scrollView.showsHorizontalScrollIndicator = NO;//水平方向的滚动指示
    [scrollView setBackgroundColor:navbarColor];
    [view addSubview:scrollView];
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    //viewtip
    tipView = [[UIView alloc] init];
    tipView.backgroundColor = RGBA(248, 248, 248, 1.0);
    [scrollView addSubview:tipView];
    
    
    
    //tipLab
    UILabel *tipLab = [[UILabel alloc] init];
    tipLab.textColor = textFiledColor;
    tipLab.font = [UIFont systemFontOfSize:titleTextSize];
    tipLab.text = @"选择对方已开通的账户";
    [tipView addSubview:tipLab];
    
    
    //tableview
    tbaleView = [[UITableView alloc] init];
    tbaleView.frame = CGRectZero;
    tbaleView.delegate = self;
    tbaleView.dataSource = self;
    tbaleView.scrollEnabled = NO;
    [tbaleView reloadData];
    [scrollView addSubview:tbaleView];
    
    
    //1.2 nextBtn
    nextBtn = [[UIButton alloc] init];
    [nextBtn setTag:302];
    [nextBtn setTitle:@"下一步" forState: UIControlStateNormal];
    [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
    nextBtn.titleLabel.font = [UIFont systemFontOfSize:textSize];
    nextBtn.userInteractionEnabled = NO;
    [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
    [nextBtn.layer setMasksToBounds:YES];
    nextBtn.layer.cornerRadius = 5.0;
    [nextBtn addTarget:self action:@selector(buttonActionToDoSomething:) forControlEvents:UIControlEventTouchUpInside];
    [scrollView addSubview:nextBtn];
    
    //设置控件的位置和大小
    CGFloat space = 10.0;
    commWidth = viewSize.width - 2 * leftRightSpace;
    CGSize tipSize = [TransferChooseViewController labelAutoCalculateRectWith:tipLab.text Font:[UIFont systemFontOfSize:titleTextSize] MaxSize:CGSizeMake(CGFLOAT_MAX, CGFLOAT_MAX)];
    
    CGSize nextBtnTitleSize = [TransferChooseViewController labelAutoCalculateRectWith:nextBtn.titleLabel.text Font:[UIFont systemFontOfSize:textSize] MaxSize:CGSizeMake(MAXFLOAT, MAXFLOAT)];
    newxtBtnH = nextBtnTitleSize.height + 2*leftRightSpace;
    CGFloat tipH = tipSize.height + 2*space;
    
    
    
    [scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(view).offset(controllerTop);
        make.left.equalTo(view).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, viewSize.height-controllerTop));
    }];
    
    
    [tipView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(scrollView).offset(0);
        make.left.equalTo(scrollView).offset(0);
        make.size.mas_equalTo(CGSizeMake(viewSize.width, tipH));
        
    }];
    
    [tipLab mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(tipView.mas_centerY).offset(0);
        make.left.equalTo(tipView.mas_left).offset(leftRightSpace);
        make.size.mas_equalTo(tipSize);
    }];
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
        case 101:
        {
            [self.navigationController popViewControllerAnimated:YES];
        }
            break;
        case 102:
        {
            
        }
            break;
        case 302:
        {
            TransferPayViewController *transferPayvc = [[TransferPayViewController alloc] init];
            transferPayvc.userInfoDic = _otherUserInfoDic;
            transferPayvc.inPayToolDic = inPayToolDic;
            transferPayvc.outPayToolDic = outPayToolDic;
            [self.navigationController pushViewController:transferPayvc animated:YES];
            
        }
            break;
        default:
            break;
    }
}

#pragma mark - 设置数据源
-(void)setModelData{
    
    //支付工具排个序
    _inpayToolsArr = [Tool orderForPayTools:_inpayToolsArr];
    
    for (int i=0; i<_inpayToolsArr.count; i++) {
        
        NSString *type = [_inpayToolsArr[i] objectForKey:@"type"];
        NSDictionary *outPayTooldic = [[NSDictionary alloc] init];
        for (int i = 0; i<_outpayToolsArr.count; i++) {
            if ([type isEqualToString:[_outpayToolsArr[i] objectForKey:@"type"]]) {
                outPayTooldic = _outpayToolsArr[i];
            }
        }
        
        NSDictionary *inPaytoolDic = _inpayToolsArr[i];
        modelM = [[TransferPayToolSelMode alloc] init];
        modelM.inpayToolTitle = [NSString stringWithFormat:@"%@-%@",[_otherUserInfoDic objectForKey:@"userRealName"],[inPaytoolDic objectForKey:@"title"]];
        modelM.inpaytTooldescribe = [_otherUserInfoDic objectForKey:@"userName"];
        modelM.headImageOther = [_otherUserInfoDic objectForKey:@"avatar"];
        
        
        modelM.outPayToolTitle = [NSString stringWithFormat:@"我的账户-%@",[inPaytoolDic objectForKey:@"title"]];
        modelM.outPayTooldescribe = [NSString stringWithFormat:@"可转账余额:%.2f元",[[[outPayTooldic objectForKey:@"account"] objectForKey:@"balance"] floatValue]/100];
        modelM.headImageOwn = [CommParameter sharedInstance].avatar;
        modelM.index = i+1;
        [_cellInfoModelArr addObject:modelM];
    }
}


#pragma mark - tableviewDelegate
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _inpayToolsArr.count;
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (selectBtn.selected && selectBtn.tag == indexPath.row+1){
        return cellallHeight;
    }else if(celldefulHeight>0){
        return celldefulHeight;
    }else{
        //初始状态 cell高度
        tbaleView.frame = CGRectMake(0, CGRectGetMaxY(tipView.frame), viewSize.width, 84*_inpayToolsArr.count);
        nextBtn.frame = CGRectMake(leftRightSpace, CGRectGetMaxY(tbaleView.frame)+50, commWidth, newxtBtnH);
        return 84;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    transFerCell = [TransferTableViewCell cellWithTableview:tableView];
    transFerCell.delegate = self;
    transFerCell.model = _cellInfoModelArr[indexPath.row];
    transFerCell.selectArr = self.selectedArray;
    transFerCell.selectionStyle = UITableViewCellSelectionStyleNone;
    return transFerCell;
}
#pragma mark TransferPayToolCellDelegate
-(void)showRightImageView:(UIButton *)btn cellDefulHeight:(CGFloat)cellDefunHeight cellAllHeight:(CGFloat)cellAllHeight{
    
    cellallHeight = cellAllHeight;
    celldefulHeight = cellDefunHeight;
    
    //存储按钮
    selectBtn = btn;
    
    //动态改变 : 位置 / 选中的转入转出工具 / 按钮状态
    if (!btn.selected) {  //reloadData之前,btn按钮状态还是上次状态 所以取反
        tbaleView.frame = CGRectMake(0, CGRectGetMaxY(tipView.frame), viewSize.width, celldefulHeight*_inpayToolsArr.count+cellallHeight-celldefulHeight);
        nextBtn.frame = CGRectMake(leftRightSpace, CGRectGetMaxY(tbaleView.frame)+50, commWidth, newxtBtnH);
        
        [self nextStep:selectBtn.tag];  //选中,确定两方支付工具
    }else{
        tbaleView.frame = CGRectMake(0, CGRectGetMaxY(tipView.frame), viewSize.width, celldefulHeight*_inpayToolsArr.count);
        nextBtn.frame = CGRectMake(leftRightSpace, CGRectGetMaxY(tbaleView.frame)+50, commWidth, newxtBtnH);
        
        [self cleanPayToolDict];  //未选,清空两方支付工具
        [self changeBtnBackGround:nil index:2];
    }
    
   
    //存储按钮tag
    if ([self.selectedArray containsObject:@(btn.tag)]) {
        [self.selectedArray removeObject:@(btn.tag)];
    }else{
        [self.selectedArray addObject:@(btn.tag)];
    }
    [tbaleView reloadData];
}


/**
 设置选中的转入/转出支付工具

 @param row indexPath.row
 */
-(void)nextStep:(NSInteger)row{
    NSInteger rowReal = row - 1; //because: tag 起始为1 //数组起始为0
    selectIndexPathRow = rowReal;
    //1.获取可用转入支付工具
    NSDictionary *inpayToolDicI = _inpayToolsArr[rowReal];
    inPayToolDic = [[NSMutableDictionary alloc] initWithDictionary:inpayToolDicI];
    
    NSString *type = [_inpayToolsArr[rowReal] objectForKey:@"type"];
    for (int i = 0; i<_outpayToolsArr.count; i++) {
        if ([type isEqualToString:[_outpayToolsArr[i] objectForKey:@"type"]]) {
            //2.获取可用转出支付工具
            NSDictionary *outpaytooldicI = _outpayToolsArr[i];
            outPayToolDic = [[NSMutableDictionary alloc] initWithDictionary:outpaytooldicI];
        }
    }
    
    //检测我方支付工具余额
    if (outPayToolDic) {
        if ([[[outPayToolDic objectForKey:@"account"] objectForKey:@"balance"] isEqualToString:@"0"]) {
            [Tool showDialog:@"您的余额不足,无法转账"];
            [self changeBtnBackGround:nil index:2];
            return;
        }else{
            [self changeBtnBackGround:@"yes" index:1];
        }
    }
    
}


/**
 清理 转入/转出 支付工具数据
 */
-(void)cleanPayToolDict{
    
    if (inPayToolDic && outPayToolDic) {
        [inPayToolDic removeAllObjects];
        [outPayToolDic removeAllObjects];
    }
    
}
#pragma mark - 改变按钮背景图片
/**
 *@brief  改变按钮背景图片
 *@param param NSString 参数：字符串
 *@return
 */
- (void)changeBtnBackGround:(NSString *)param index:(int)index
{
    if (index == 1) {
        if (![@"" isEqualToString:param] && param != nil) {
            [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
            nextBtn.userInteractionEnabled = YES;
            [nextBtn setBackgroundColor:RGBA(65, 131, 215, 1.0)];
            nextBtn.userInteractionEnabled = YES;
        }
    }else{
        [nextBtn setTitleColor:RGBA(255, 255, 255, 1.0) forState:UIControlStateNormal];
        [nextBtn setBackgroundColor:RGBA(206, 209, 216, 1.0)];
        nextBtn.userInteractionEnabled = NO;
    }
}



+ (CGSize)labelAutoCalculateRectWith:(NSString*)text Font:(UIFont*)font MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes = @{NSFontAttributeName:font,NSParagraphStyleAttributeName:paragraphStyle.copy};
    CGSize labelSize = [text boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine attributes:attributes context: nil ].size;
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return  labelSize;
}


@end

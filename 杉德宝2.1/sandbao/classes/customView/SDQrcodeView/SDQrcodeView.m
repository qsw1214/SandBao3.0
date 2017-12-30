//
//  SDQrcodeView.m
//  SDQrcodeView
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDQrcodeView.h"

#define SDQrcodeView_Pay_First_Be_Use @"SDQrcodeView_Pay_First_Be_Use" //第一次使用付款码

#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))

#define TWO_QRCODE_WH 500
#define ONE_QECODE_W  500
#define ONE_QECODE_H  (500*(1-0.678))


@interface SDQrcodeView (){
    
    //标题视图
    UIView *headView;
    //标题视图 - 标题
    UILabel *titleLab;
    
    //白色承载View
    UIView *whiteMaskView;
    
    //二维码展示视图
    UIView *bodyView;
    //二维码展示视图 - 条形码图片
    UIImageView *oneQrcodeImgView;
    
    //二维码展示视图 - 二维码图片
    UIImageView *twoQrCodeImgView;
    //二维码展示视图 - 二维码描述标题
    UILabel *twoQrCodeDesLab;
    //二维码展示视图 - 二维码视图宽高
    CGFloat twoQrCodeImgViewWH;
    
    //二维码展示视图 - 左边小圆点
    UIView *roundViewLeft;
    //二维码展示视图 - 右边小圆点
    UIView *roundViewRight;

    
    //公共 - 支付工具展示视图
    UIView  *payToolShowView;
    //公共 - 支付工具名称
    UILabel *payToolNameLab;
    
    //整体宽度
    CGFloat selfViewW;
    //整体高度
    CGFloat selfViewH;
    //当前亮度记录
    double currentLight;
    
    
    //条形码是否显示
    BOOL oneQrShow;
    //二维码是否显示
    BOOL twoQrShow;
    
    //弹出时 - 条形码背景视图
    UIView *oneBackGroundView;
    
    //弹出时 - 条形码数字
    UILabel *oneLab;
    //弹出时 - 条形码图片
    UIImageView *oneimgv;
    //弹出时 - 二维码图片
    UIImageView *twoBackGroundView;
    
    //手势 - 点击隐藏
    UITapGestureRecognizer *hiddenTap;
    
}


@end

@implementation SDQrcodeView

#pragma mark - public
- (void)hiddenBigQrcodeView{
    
    [self touchHiddenBigImg:hiddenTap];
}

#pragma mark - 初始化+私有方法集

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        self.userInteractionEnabled = YES;
        //整体宽度
        selfViewW = [UIScreen mainScreen].bounds.size.width - AdapterWfloat(50)*2;
    }
    return self;
}

- (void)setStyle:(SDQrcodeViewStyle)style{
    _style = style;
    
    //类型 == 付款码
    if (_style == PayQrcodeView) {
        [self createHeadView];
        [self createPayQrcodeBodyView];
    }
    //类型 == 收款码
    if (_style == CollectionQrcordView) {
        [self createHeadView];
        [self createCollectionQrcodeBodyView];
        [self createBottomEmptyView];
    }
    
    
}



/**
 创建头部标题视图
 */
- (void)createHeadView{
    
    
    headView = [[UIView alloc] init];
    headView.backgroundColor = [UIColor colorWithRed:228/255.0 green:230/255.0 blue:233/255.0 alpha:1/1.0];
    [self addSubview:headView];
    
    UIImage *iconImg = nil;
    NSString *titleStr = nil;
    if (_style == PayQrcodeView) {
        titleStr = @"向商家付款";
        iconImg = [UIImage imageNamed:@"shoufukuan_icon_pay"];
    }
    if (_style == CollectionQrcordView) {
        titleStr = @"二维码收款";
        iconImg = [UIImage imageNamed:@"shoufukuan_icon_collection"];
    }
    
    UIImageView *iconView = [[UIImageView alloc] init];
    iconView.image = iconImg;
    [headView addSubview:iconView];
    
    titleLab = [[UILabel alloc] init];
    titleLab.text = titleStr;
    titleLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    titleLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [headView addSubview:titleLab];
    
    //虚线
    UIView *pointlineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, selfViewW, 1)];
    pointlineView.backgroundColor = [UIColor whiteColor];
    [self drawLineOfDashByCAShapeLayer:pointlineView lineLength:6 lineSpacing:2 lineColor:[UIColor colorWithRed:210/255.0 green:217/255.0 blue:225/255.0 alpha:1/1.0]];
    [headView addSubview:pointlineView];
    
    
    CGFloat leftSpace = AdapterWfloat(20);
    CGFloat updownSpace = AdapterHfloat(17);
    CGFloat headViewH = updownSpace *2 + iconImg.size.height;
    
    CGSize titleLabSize = [titleLab sizeThatFits:CGSizeZero];
    CGFloat titleLabOY  = (headViewH - titleLabSize.height)/2;
    CGFloat titleLabOX  = AdapterHfloat(9.f) + iconImg.size.width + leftSpace;
    
    headView.frame = CGRectMake(0, 0, selfViewW, headViewH);
    iconView.frame = CGRectMake(leftSpace, updownSpace, iconImg.size.width, iconImg.size.height);
    titleLab.frame = CGRectMake(titleLabOX, titleLabOY, titleLabSize.width, titleLabSize.height);
    pointlineView.frame = CGRectMake(0, headView.frame.size.height - 1, selfViewW, 1);
}


/**
 创建付款码_bodyView
 */
- (void)createPayQrcodeBodyView{
    oneQrShow = NO;
    twoQrShow = NO;
    
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bodyView];
    
    //二维码条形码文字描述
    twoQrCodeDesLab = [[UILabel alloc] init];
    twoQrCodeDesLab.text = @"点击可查看付款码数字";
    twoQrCodeDesLab.textAlignment = NSTextAlignmentCenter;
    twoQrCodeDesLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(11)];
    twoQrCodeDesLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:0.4f];
    [bodyView addSubview:twoQrCodeDesLab];

    //条形码图片
    oneQrcodeImgView = [[UIImageView alloc] init];
    oneQrcodeImgView.backgroundColor = [UIColor whiteColor];
    oneQrcodeImgView.userInteractionEnabled = YES;
    oneQrcodeImgView.tag = 1;
    [self addTapShowBigImg:oneQrcodeImgView];
    [bodyView addSubview:oneQrcodeImgView];
    
    
    //二维码图片
    twoQrCodeImgView = [[UIImageView alloc] init];
    twoQrCodeImgView.backgroundColor = [UIColor whiteColor];
    twoQrCodeImgView.userInteractionEnabled = YES;
    twoQrCodeImgView.tag = 2;
    [self addTapShowBigImg:twoQrCodeImgView];
    [bodyView addSubview:twoQrCodeImgView];
    
    
    CGFloat upSpace            = AdapterHfloat(29);
    CGSize twoQrCodeDesLabSize = [twoQrCodeDesLab sizeThatFits:CGSizeZero];
    
    CGFloat oneQrCodeImgViewOX = AdapterWfloat(0);//由于条形码图片自带白色边框,因此间距Fix
    CGFloat oneQrCodeImgViewH  = AdapterHfloat(55);
    CGFloat oneQrCodeImgViewW  = selfViewW - oneQrCodeImgViewOX*2;
    CGFloat oneQrCodeImgViewOY = upSpace + twoQrCodeDesLabSize.height + AdapterHfloat(0);
    
    CGFloat twoQrCodeImgViewOX = AdapterWfloat(55);
    CGFloat twoQrCodeImgViewOY = oneQrCodeImgViewOY + oneQrCodeImgViewH + AdapterHfloat(20);
    twoQrCodeImgViewWH         = selfViewW - 2*twoQrCodeImgViewOX;
    
    CGFloat bodyViewH          = twoQrCodeImgViewOY + twoQrCodeImgViewWH;
    selfViewH = headView.frame.size.height + bodyViewH;
    
    twoQrCodeDesLab.frame  = CGRectMake(0, upSpace, selfViewW, twoQrCodeDesLabSize.height);
    oneQrcodeImgView.frame = CGRectMake(oneQrCodeImgViewOX, oneQrCodeImgViewOY, oneQrCodeImgViewW, oneQrCodeImgViewH);
    twoQrCodeImgView.frame = CGRectMake(twoQrCodeImgViewOX, twoQrCodeImgViewOY, twoQrCodeImgViewWH, twoQrCodeImgViewWH);
    
    
    
    bodyView.frame = CGRectMake(0, headView.frame.size.height, selfViewW, bodyViewH);
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, headView.frame.size.width, selfViewH);
    
    
    //追加左右小圆点
    roundViewLeft = [[UIView alloc] init];
    roundViewLeft.frame = CGRectMake(-5, bodyViewH/2, 10, 10);
    roundViewLeft.layer.cornerRadius = 5;
    roundViewLeft.backgroundColor = [UIColor lightGrayColor];
    roundViewLeft.layer.masksToBounds = YES;
    [bodyView addSubview:roundViewLeft];
    
    roundViewRight = [[UIView alloc] init];
    roundViewRight.frame = CGRectMake(selfViewW-5, bodyViewH/2, 10, 10);
    roundViewRight.backgroundColor = [UIColor lightGrayColor];
    roundViewRight.layer.cornerRadius = 5;
    roundViewLeft.layer.masksToBounds = YES;
    [bodyView addSubview:roundViewRight];
    
    
    if (![[NSUserDefaults standardUserDefaults] objectForKey:SDQrcodeView_Pay_First_Be_Use]) {
        [self createWaringTip];
    }
    
    
}



/**
 创建收款码_bodyView
 */
- (void)createCollectionQrcodeBodyView{
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bodyView];
    
    twoQrCodeDesLab = [[UILabel alloc] init];
    twoQrCodeDesLab.text = @"杉德宝扫一扫,向我付钱";
    twoQrCodeDesLab.textAlignment = NSTextAlignmentCenter;
    twoQrCodeDesLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(11)];
    twoQrCodeDesLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:0.4f];
    [bodyView addSubview:twoQrCodeDesLab];
    
    twoQrCodeImgView = [[UIImageView alloc] init];
    twoQrCodeImgView.backgroundColor = [UIColor redColor];
    [bodyView addSubview:twoQrCodeImgView];
    
    CGFloat leftRightSpace = AdapterWfloat(55);
    CGFloat upSpace = AdapterHfloat(29);
    twoQrCodeImgViewWH = selfViewW - 2*leftRightSpace;
    
    CGSize twoQrCodeDesLabSize = [twoQrCodeDesLab sizeThatFits:CGSizeZero];
    CGFloat twoQrCodeImgViewOY = upSpace + twoQrCodeDesLabSize.height + upSpace;
    CGFloat bodyViewH       = twoQrCodeImgViewOY + twoQrCodeImgViewWH;
    selfViewH = headView.frame.size.height + bodyViewH;
    
    twoQrCodeDesLab.frame = CGRectMake(0, upSpace, selfViewW, twoQrCodeDesLabSize.height);
    twoQrCodeImgView.frame = CGRectMake(leftRightSpace, twoQrCodeImgViewOY, twoQrCodeImgViewWH, twoQrCodeImgViewWH);
    
    
    bodyView.frame = CGRectMake(0, headView.frame.size.height, selfViewW, bodyViewH);
    self.frame = CGRectMake(0, 0, headView.frame.size.width, selfViewH);
    
    
    //追加左右小圆点
    roundViewLeft = [[UIView alloc] init];
    roundViewLeft.frame = CGRectMake(-5, bodyViewH/2, 10, 10);
    roundViewLeft.layer.cornerRadius = 5;
    roundViewLeft.backgroundColor = [UIColor lightGrayColor];
    roundViewLeft.layer.masksToBounds = YES;
    [bodyView addSubview:roundViewLeft];
    
    roundViewRight = [[UIView alloc] init];
    roundViewRight.frame = CGRectMake(selfViewW-5, bodyViewH/2, 10, 10);
    roundViewRight.backgroundColor = [UIColor lightGrayColor];
    roundViewRight.layer.cornerRadius = 5;
    roundViewLeft.layer.masksToBounds = YES;
    [bodyView addSubview:roundViewRight];
    
}


#pragma mark - 公共方法

/**
 创建空白底座
 */
- (void)createBottomEmptyView{
    
    UIView *bottomEmptyView = [[UIView alloc] init];
    bottomEmptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomEmptyView];
    
    CGFloat bottomEmptyViewH = AdapterHfloat(29);
    CGFloat bottomEmptyViewHOY = headView.frame.size.height + bodyView.frame.size.height;
    bottomEmptyView.frame = CGRectMake(0, bottomEmptyViewHOY, selfViewW, bottomEmptyViewH);
    
    selfViewH += bottomEmptyViewH;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, headView.frame.size.width, selfViewH);
}


/**
 创建 支付工具展示视图
 */
- (void)createPayToolShowView{
    
    payToolShowView = [[UIView alloc] init];
    payToolShowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:payToolShowView];
    
    UIImage *payToolIconImg = [UIImage imageNamed:@"payToolDef"];
    UIImageView *payToolIconImgV = [[UIImageView alloc] init];
    payToolIconImgV.image = payToolIconImg;
    [payToolShowView addSubview:payToolIconImgV];
    
    payToolNameLab = [[UILabel alloc] init];
    //@"这里是支付工具描述"
    payToolNameLab.text = self.payToolNameStr;
    payToolNameLab.textAlignment = NSTextAlignmentCenter;
    payToolNameLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(12)];
    payToolNameLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [payToolShowView addSubview:payToolNameLab];
    
    UIImage *leftEnterImg = [UIImage imageNamed:@"list_icon_goMore"];
    UIImageView *leftEnterImgV = [[UIImageView alloc] init];
    leftEnterImgV.image = leftEnterImg;
    [payToolShowView addSubview:leftEnterImgV];
    
    UIButton *coverBtn = [[UIButton alloc] init];
    coverBtn.backgroundColor = [UIColor clearColor];
    [coverBtn addTarget:self action:@selector(changePayTool:) forControlEvents:UIControlEventTouchUpInside];
    [payToolShowView addSubview:coverBtn];
    
    CGFloat space = AdapterWfloat(7);
    CGFloat upSpace = AdapterHfloat(25);
    CGSize  payToolNameLabSize = [payToolNameLab sizeThatFits:CGSizeZero];
    
    CGFloat allItemWidth = payToolIconImg.size.width + space + payToolNameLabSize.width + leftEnterImg.size.width;
    
    CGFloat payToolShowViewOY = headView.frame.size.height + bodyView.frame.size.height;
    CGFloat payToolShowViewH  = upSpace + payToolIconImg.size.height + upSpace;
    payToolShowView.frame = CGRectMake(0, payToolShowViewOY, selfViewW, payToolShowViewH);
    
    coverBtn.frame = CGRectMake(0, 0, selfViewW, payToolShowViewH);
    
    CGFloat payToolIconImgVOX = (selfViewW - allItemWidth)/2;
    CGFloat payToolIconImgVOY = (payToolShowViewH - payToolIconImg.size.height)/2;
    payToolIconImgV.frame     = CGRectMake(payToolIconImgVOX, payToolIconImgVOY, payToolIconImg.size.width, payToolIconImg.size.height);
    
    CGFloat payToolNameLabOX = payToolIconImgVOX + payToolIconImg.size.width + space;
    CGFloat payToolNameLabOY = (payToolShowViewH - payToolNameLabSize.height)/2;
    payToolNameLab.frame     = CGRectMake(payToolNameLabOX, payToolNameLabOY, payToolNameLabSize.width, payToolNameLabSize.height);
    
    CGFloat leftEnterImgVOX = payToolNameLabOX + payToolNameLabSize.width;
    CGFloat leftEnterImgVOY = (payToolShowViewH - leftEnterImg.size.height)/2;
    leftEnterImgV.frame     = CGRectMake(leftEnterImgVOX, leftEnterImgVOY, leftEnterImg.size.width, leftEnterImg.size.height);
    
    
    selfViewH += payToolShowViewH;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, headView.frame.size.width, selfViewH);
}


/**
 创建 设置金额按钮
 */
- (void)createSetMoneyBtnView{
    
    UIButton *setMoneyBtn = [[UIButton alloc] init];
    [setMoneyBtn setTitle:@"设置金额" forState:UIControlStateNormal];
    [setMoneyBtn setTitleColor:[UIColor colorWithRed:255/255.0 green:93/255.0 blue:49/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    setMoneyBtn.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(12)];
    [setMoneyBtn addTarget:self action:@selector(setMoneyClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:setMoneyBtn];
    
    CGSize setMoneyBtnSize = [setMoneyBtn sizeThatFits:CGSizeZero];
    
    
    CGFloat setMoneyBtnH = setMoneyBtnSize.height + AdapterHfloat(25);
    
    CGFloat setMoneyBtnOY = headView.frame.size.height + bodyView.frame.size.height;
    setMoneyBtn.frame = CGRectMake(0, setMoneyBtnOY, selfViewW, setMoneyBtnH);
    
    selfViewH += setMoneyBtnH;
    self.frame = CGRectMake(self.frame.origin.x, self.frame.origin.y, headView.frame.size.width, selfViewH);
    
}

/**
 第一次使用付款码 - 提示视图
 */
- (void)createWaringTip{
    
    UIView *tipMaskView = [[UIView alloc] init];
    tipMaskView.backgroundColor = [UIColor whiteColor];
    [self addSubview:tipMaskView];
    
    UIImage *tipIcon = [UIImage imageNamed:@"showPayQrcode"];
    UIImageView *tipIconImgV = [[UIImageView alloc] init];
    tipIconImgV.image = tipIcon;
    [tipMaskView addSubview:tipIconImgV];
    
    UILabel *desLab = [[UILabel alloc] init];
    desLab.text = @"该功能用于向商家付款时出示使用，请不要将付款码及数字发送给他人";
    desLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    desLab.numberOfLines = 2;
    desLab.textAlignment = NSTextAlignmentCenter;
    desLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:1/1.0];
    [tipMaskView addSubview:desLab];
    
    UIButton *sureBtn = [[UIButton alloc] init];
    [sureBtn setTitle:@"我知道了" forState:UIControlStateNormal];
    [sureBtn setTitleColor:[UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0] forState:UIControlStateNormal];
    sureBtn.titleLabel.font =  [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(13)];
    sureBtn.layer.cornerRadius = 5.f;
    sureBtn.layer.masksToBounds= YES;
    sureBtn.layer.borderWidth = 1.f;
    [sureBtn addTarget:self action:@selector(closeWaringTip:) forControlEvents:UIControlEventTouchUpInside];
    sureBtn.layer.borderColor = [UIColor colorWithRed:53/255.0 green:139/255.0 blue:239/255.0 alpha:1/1.0].CGColor;
    [tipMaskView addSubview:sureBtn];
    
    
    CGFloat tipMaskViewOY = headView.frame.size.height;
    CGFloat tipMaskViewW  = selfViewW;
    CGFloat tipMaskViewH  = bodyView.frame.size.height + payToolShowView.frame.size.height;
    tipMaskView.frame = CGRectMake(0, tipMaskViewOY, tipMaskViewW, tipMaskViewH);
    
    CGFloat upSpace = AdapterHfloat(60);
    CGFloat tipIconImgVOX = (selfViewW - tipIcon.size.width)/2;
    tipIconImgV.frame = CGRectMake(tipIconImgVOX, upSpace, tipIcon.size.width, tipIcon.size.width);
    
    CGFloat desLabOX = AdapterWfloat(30);
    CGFloat desLabOY = upSpace + tipIcon.size.height + AdapterHfloat(25);
    CGFloat desLabW  = selfViewW - desLabOX*2;
    CGSize desLabSize = [desLab sizeThatFits:CGSizeZero];
    desLab.frame = CGRectMake(desLabOX, desLabOY, desLabW, desLabSize.height*2);
    
    CGFloat sureBtnOX = AdapterWfloat(64);
    CGFloat sureBtnOY = desLabOY + desLab.frame.size.height + AdapterHfloat(30);
    CGFloat sureBtnW  = selfViewW - sureBtnOX*2;
    CGFloat sureBtnH  = [sureBtn sizeThatFits:CGSizeZero].height;
    sureBtn.frame     = CGRectMake(sureBtnOX, sureBtnOY, sureBtnW, sureBtnH);
    
    
    
}

#pragma mark - setter$getter
//条形码赋值
- (void)setOneQrCodeStr:(NSString *)oneQrCodeStr{
    if (oneQrCodeStr.length==0) {
        
    }else{
        _oneQrCodeStr = oneQrCodeStr;
        oneQrcodeImgView.image = [self barCodeImageWithStr:_oneQrCodeStr size:CGSizeMake(ONE_QECODE_W, ONE_QECODE_H)];
        //放大时 - 放大时条形码+条形数字实时刷新
        if (oneLab&&oneimgv) {
            oneLab.text = _oneQrCodeStr;
            oneimgv.image = [self barCodeImageWithStr:_oneQrCodeStr size:CGSizeMake([UIScreen mainScreen].bounds.size.width, AdapterHfloat(100))];
        }
    }
    
    
}
//二维码赋值
- (void)setTwoQrCodeStr:(NSString *)twoQrCodeStr{
    if (twoQrCodeStr.length == 0) {
        
    }else{
        _twoQrCodeStr = twoQrCodeStr;
        twoQrCodeImgView.image = [self twoDimensionCodeWithStr:_twoQrCodeStr size:TWO_QRCODE_WH];
        //放大时 - 放大二维码实时刷新
        if (twoBackGroundView) {
            twoBackGroundView.image = [self twoDimensionCodeWithStr:_twoQrCodeStr size:twoQrCodeImgViewWH];
        }
    }
    
}
//支付工具名称赋值
- (void)setPayToolNameStr:(NSString *)payToolNameStr{
    _payToolNameStr = payToolNameStr;
    
    //清除旧视图,根据支付工具名称创建新视图
    if (payToolShowView) {
        selfViewH = headView.frame.size.height + bodyView.frame.size.height;
        [payToolShowView removeFromSuperview];
    }
    
    /*
     //暂时隐藏设置默认支付工具功能
     [self createPayToolShowView];
     */
    
    [self createBottomEmptyView];
}
//左右小圆点颜色赋值
- (void)setRoundRLColor:(UIColor *)roundRLColor{
    _roundRLColor = roundRLColor;
    roundViewLeft.backgroundColor = _roundRLColor;
    roundViewRight.backgroundColor = _roundRLColor;
}

#pragma  mark - btnClick_Func
- (void)changePayTool:(UIButton*)btn{
    
    NSLog(@"切换支付工具");
}

- (void)setMoneyClick:(UIButton*)btn{
    
    NSLog(@"设置金额");
}

#pragma mark 绘制虚线
/**
 *  通过 CAShapeLayer 方式绘制虚线
 *
 *  param lineView:       需要绘制成虚线的view
 *  param lineLength:     虚线的宽度
 *  param lineSpacing:    虚线的间距
 *  param lineColor:      虚线的颜色
 **/
- (void)drawLineOfDashByCAShapeLayer:(UIView *)lineView lineLength:(int)lineLength lineSpacing:(int)lineSpacing lineColor:(UIColor *)lineColor {
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    [shapeLayer setBounds:lineView.bounds];
    [shapeLayer setPosition:CGPointMake(CGRectGetWidth(lineView.frame) / 2, CGRectGetHeight(lineView.frame))];
    [shapeLayer setFillColor:[UIColor clearColor].CGColor];
    //  设置虚线颜色为blackColor
    [shapeLayer setStrokeColor:lineColor.CGColor];
    //  设置虚线宽度
    [shapeLayer setLineWidth:CGRectGetHeight(lineView.frame)];
    [shapeLayer setLineJoin:kCALineJoinRound];
    //  设置线宽，线间距
    [shapeLayer setLineDashPattern:[NSArray arrayWithObjects:[NSNumber numberWithInt:lineLength], [NSNumber numberWithInt:lineSpacing], nil]];
    //  设置路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, 0, 0);
    CGPathAddLineToPoint(path, NULL,CGRectGetWidth(lineView.frame), 0);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    //  把绘制好的虚线添加上来
    [lineView.layer addSublayer:shapeLayer];
}
#pragma mark - 生成条形码
- (UIImage *)barCodeImageWithStr:(NSString *)str size:(CGSize)size
{
    // 1.将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];

    // 2.创建条形码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CICode128BarcodeGenerator"];

    // 3.恢复滤镜的默认属性
    [filter setDefaults];

    // 4.设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];

    // 5.获得滤镜输出的图像
    CIImage *urlImage = [filter outputImage];

    // 6.消除模糊
    CGFloat scaleX = size.width / urlImage.extent.size.width;
    CGFloat scaleY = size.height / urlImage.extent.size.height;

    CIImage *transformImg = [urlImage imageByApplyingTransform:CGAffineTransformScale(CGAffineTransformIdentity, scaleX, scaleY)];

    // 6.将CIImage 转换为UIImage
    UIImage *image = [UIImage imageWithCIImage:transformImg];

    return image;
}


#pragma mark - 生成二维码
- (UIImage *)twoDimensionCodeWithStr:(NSString *)str size:(CGFloat)size
{
    // 1.将字符串转换成NSData
    NSData *data = [str dataUsingEncoding:NSUTF8StringEncoding];
    
    // 2.创建二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    
    // 3.恢复默认
    [filter setDefaults];
    
    // 4.给滤镜设置数据
    [filter setValue:data forKeyPath:@"inputMessage"];
    
    // 5.获取滤镜输出的二维码
    CIImage *outputImage = [filter outputImage];
    
    // 6.此时生成的还是CIImage，可以通过下面方式生成一个固定大小的UIImage
    CGRect extent = CGRectIntegral(outputImage.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    
    // 7.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:outputImage fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    
    // 8.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

- (void)addTapShowBigImg:(UIView*)view{
    UITapGestureRecognizer *taoGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchShowBigImge:)];
    [view addGestureRecognizer:taoGesture];
}
- (void)touchShowBigImge:(UIGestureRecognizer*)tap{
    //保存当前亮度
    currentLight = [UIScreen mainScreen].brightness;
    
    //在层级最高处创建白色遮罩视图
    whiteMaskView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    whiteMaskView.backgroundColor = [UIColor whiteColor];
    hiddenTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(touchHiddenBigImg:)];
    [whiteMaskView addGestureRecognizer:hiddenTap];
    whiteMaskView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:whiteMaskView];
    
    //条形码展示动画
    if (tap.view.tag == 1) {
        
        //获取条码图片
        UIImage *oneImg = [self barCodeImageWithStr:_oneQrCodeStr size:CGSizeMake([UIScreen mainScreen].bounds.size.width, AdapterHfloat(100))];
        
        //创建动画用- 条形码背景框
        oneBackGroundView = [[UIView alloc] init];
        oneBackGroundView.backgroundColor = [UIColor clearColor];
        [whiteMaskView addSubview:oneBackGroundView];
        
        //条码框提示
        UILabel *oneTipLab = [[UILabel alloc] init];
        oneTipLab.text = @"▶付款码数字仅用于支付时向收银员出示,请勿泄露以防诈骗";
        oneTipLab.textColor = [UIColor colorWithRed:255/255.0 green:93/255.0 blue:49/255.0 alpha:1/1.0];
        oneTipLab.textAlignment = NSTextAlignmentCenter;
        oneTipLab.font = [UIFont systemFontOfSize:11];
        oneTipLab.backgroundColor = [UIColor clearColor];
        oneTipLab.frame = CGRectMake(0, 0, oneImg.size.width, AdapterHfloat(12));
        [oneBackGroundView addSubview:oneTipLab];
        
        //条形码图片
        oneimgv= [[UIImageView alloc] init];
        oneimgv.backgroundColor = [UIColor clearColor];
        
        oneimgv.image = oneImg;
        oneimgv.frame = CGRectMake(0, oneTipLab.frame.size.height, oneImg.size.width, oneImg.size.height);
        [oneBackGroundView addSubview:oneimgv];
        
        //条码数字
        oneLab = [[UILabel alloc] init];
        oneLab.text = _oneQrCodeStr;
        oneLab.textColor = [UIColor blackColor];
        oneLab.textAlignment = NSTextAlignmentCenter;
        oneLab.font = [UIFont systemFontOfSize:14];
        oneLab.frame = CGRectMake(0,oneTipLab.frame.size.height + oneImg.size.height, oneImg.size.width, AdapterHfloat(20));
        [oneBackGroundView addSubview:oneLab];
        
        oneBackGroundView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - oneImg.size.height)/2, oneImg.size.width, oneTipLab.frame.size.height+ oneImg.size.height + oneLab.frame.size.height);
        
        
        [UIView animateWithDuration:0.4f animations:^{
            oneQrShow = YES;
            twoQrShow = NO;
            //设置亮度最大
            [UIScreen mainScreen].brightness = 1.f;
            whiteMaskView.alpha = 1;
            oneBackGroundView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(M_PI_2);
            oneBackGroundView.transform = CGAffineTransformScale(transformRotate, 1.5, 1.5);
        }];
    }
    //二维码
    if (tap.view.tag == 2) {
        oneQrShow = NO;
        twoQrShow = YES;
        
        //创建动画用- 二维码
        twoBackGroundView = [[UIImageView alloc] init];
        twoBackGroundView.backgroundColor = [UIColor whiteColor];
        UIImage *twoImg = [self twoDimensionCodeWithStr:_twoQrCodeStr size:twoQrCodeImgViewWH];
        twoBackGroundView.image = twoImg;
        twoBackGroundView.frame = CGRectMake(0, ([UIScreen mainScreen].bounds.size.height - twoImg.size.height)/2, twoImg.size.width, twoImg.size.height);
        twoBackGroundView.center = CGPointMake([UIScreen mainScreen].bounds.size.width/2, [UIScreen mainScreen].bounds.size.height/2);
        [whiteMaskView addSubview:twoBackGroundView];
        
        [UIView animateWithDuration:0.4f animations:^{
            //设置亮度最大
            [UIScreen mainScreen].brightness = 1.f;
            whiteMaskView.alpha = 1;
            twoBackGroundView.transform = CGAffineTransformMakeScale(1.5f, 1.5f);
        }];
    }
    
}
//触发后删除
- (void)touchHiddenBigImg:(UIGestureRecognizer*)tap{
    
    [UIView animateWithDuration:0.4f animations:^{
        if (oneQrShow == YES) {
            //位置恢复
            CGAffineTransform transformRotate = CGAffineTransformMakeRotation(-M_PI_2);
            whiteMaskView.transform = CGAffineTransformScale(transformRotate, 0.3f, 0.3f);
            oneQrShow = NO;
            twoQrShow = NO;
        }
        if (twoQrShow == YES) {
            //位置恢复
            twoBackGroundView.alpha = 0.f;
            twoBackGroundView.transform = CGAffineTransformMakeScale(0.8f, 0.8f);
            oneQrShow = NO;
            twoQrShow = NO;
        }
        //亮度恢复
        [UIScreen mainScreen].brightness = currentLight;
        tap.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [tap.view removeFromSuperview];
    }];
    
}


- (void)closeWaringTip:(UIButton*)btn{

    [[NSUserDefaults standardUserDefaults] setObject:@"-=-=-=-=" forKey:SDQrcodeView_Pay_First_Be_Use];
    //删除 tipMaskView
    [btn.superview removeFromSuperview];
    
}

@end

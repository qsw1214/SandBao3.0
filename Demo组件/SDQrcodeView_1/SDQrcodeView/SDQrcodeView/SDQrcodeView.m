//
//  SDQrcodeView.m
//  SDQrcodeView
//
//  Created by tianNanYiHao on 2017/12/5.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "SDQrcodeView.h"


#define AdapterWfloat(f) ((f/375.f)*[UIScreen mainScreen].bounds.size.width)
#define AdapterHfloat(f) ((f/667.f)*[UIScreen mainScreen].bounds.size.height)
#define AdapterFfloat(f) (([[UIScreen mainScreen] bounds].size.height==736.f)?(f):(f*0.8571))


@interface SDQrcodeView (){
    
    //标题视图
    UIView *headView;
    //标题视图 - 标题
    UILabel *titleLab;
    
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

    
    //付款码 - 支付工具展示视图
    UIView *payToolShowView;
    
    //整体宽度
    CGFloat selfViewW;
    //整体高度
    CGFloat selfViewH;

}


@end

@implementation SDQrcodeView

#pragma mark - 初始化+私有方法集

- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
        self.backgroundColor = [UIColor whiteColor];
        
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
    CGFloat titleLabOX  = AdapterFfloat(9.f) + iconImg.size.width + leftSpace;
    
    headView.frame = CGRectMake(0, 0, selfViewW, headViewH);
    iconView.frame = CGRectMake(leftSpace, updownSpace, iconImg.size.width, iconImg.size.height);
    titleLab.frame = CGRectMake(titleLabOX, titleLabOY, titleLabSize.width, titleLabSize.height);
    pointlineView.frame = CGRectMake(0, headView.frame.size.height - 1, selfViewW, 1);
    
    
    
}

/**
 创建付款码_bodyView
 */
- (void)createPayQrcodeBodyView{
    
    bodyView = [[UIView alloc] init];
    bodyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bodyView];
    
    twoQrCodeDesLab = [[UILabel alloc] init];
    twoQrCodeDesLab.text = @"点击可查看付款码数字";
    twoQrCodeDesLab.textAlignment = NSTextAlignmentCenter;
    twoQrCodeDesLab.font = [UIFont fontWithName:@"PingFangSC-Regular" size:AdapterFfloat(11)];
    twoQrCodeDesLab.textColor = [UIColor colorWithRed:52/255.0 green:51/255.0 blue:57/255.0 alpha:0.4f];
    [bodyView addSubview:twoQrCodeDesLab];
    
    twoQrCodeImgView = [[UIImageView alloc] init];
    twoQrCodeImgView.backgroundColor = [UIColor redColor];
    [bodyView addSubview:twoQrCodeImgView];
    
    CGFloat leftRightSpace = AdapterWfloat(60);
    CGFloat upSpace = AdapterHfloat(25);
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


/**
 创建收款码_bodyView
 */
- (void)createCollectionQrcodeBodyView{
    
    
}


#pragma mark - 公共方法

- (void)createBottomEmptyView{
    
    UIView *bottomEmptyView = [[UIView alloc] init];
    bottomEmptyView.backgroundColor = [UIColor whiteColor];
    [self addSubview:bottomEmptyView];
    
    CGFloat bottomEmptyViewH = AdapterHfloat(29);
    CGFloat bottomEmptyViewHOY = headView.frame.size.height + bodyView.frame.size.height;
    bottomEmptyView.frame = CGRectMake(0, bottomEmptyViewHOY, selfViewW, bottomEmptyViewH);
    
    selfViewH += bottomEmptyViewH;
    self.frame = CGRectMake(0, 0, headView.frame.size.width, selfViewH);
}


/**
 创建 付款码 - 支付工具展示视图
 */
- (void)createPayToolShowView{
    
    payToolShowView = [[UIView alloc] init];
    payToolShowView.backgroundColor = [UIColor whiteColor];
    [self addSubview:payToolShowView];
    
    UIImage *payToolIconImg = [UIImage imageNamed:@"payToolDef"];
    UIImageView *payToolIconImgV = [[UIImageView alloc] init];
    payToolIconImgV.image = payToolIconImg;
    [payToolShowView addSubview:payToolIconImgV];
    
    UILabel *payToolNameLab = [[UILabel alloc] init];
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
    self.frame = CGRectMake(0, 0, headView.frame.size.width, selfViewH);
}

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
    self.frame = CGRectMake(0, 0, headView.frame.size.width, selfViewH);
    
}

#pragma mark - setter$getter
//条形码赋值
- (void)setOneQrCodeStr:(NSString *)oneQrCodeStr{
    _oneQrCodeStr = oneQrCodeStr;
}
//二维码赋值
- (void)setTwoQrCodeStr:(NSString *)twoQrCodeStr{
    _twoQrCodeStr = twoQrCodeStr;
    twoQrCodeImgView.image = [self twoDimensionCodeWithStr:_twoQrCodeStr size:twoQrCodeImgViewWH];
}
//左右小圆点颜色赋值
- (void)setRoundRLColor:(UIColor *)roundRLColor{
    _roundRLColor = roundRLColor;
    roundViewLeft.backgroundColor = _roundRLColor;
    roundViewRight.backgroundColor = _roundRLColor;
}



#pragma mark - 公共方法

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
- (UIImage *)barCodeImageWithStr:(NSString *)str
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
    
    // 6.将CIImage 转换为UIImage
    UIImage *image = [UIImage imageWithCIImage:urlImage];
    
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

@end

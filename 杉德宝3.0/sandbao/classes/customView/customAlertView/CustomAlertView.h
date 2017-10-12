//
//  CustomAlertView.h
//  collectionTreasure
//
//  Created by tianNanYiHao on 15/7/16.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    CustomAlertViewStyleDefault = 0,
    CustomAlertViewStyleAutnCodeTextInput,
    CustomAlertViewStylePasswordInput,
} CustomAlertViewStyle;

@interface CustomAlertView : UIView

@property (nonatomic,retain) UILabel *msgLabel;
@property (nonatomic,retain) UIFont *messageFont;

@property (nonatomic,retain) UIImage *commImage;
@property (nonatomic,retain) UITextField *commTextFiled;
@property (nonatomic,retain) UIFont *commTextFiledFont;
@property (nonatomic,strong) NSString *commTextFiledplaceholder;

@property (nonatomic,retain) UIImage *payPasswordImage;
@property (nonatomic,retain) UITextField *payPasswordTextFiled;
@property (nonatomic,retain) UITextField *payPasswordTextFiledFont;
@property (nonatomic,strong) NSString *payPasswordTextFiledplaceholder;

@property (nonatomic,assign) CustomAlertViewStyle alertViewStyle;

@property (nonatomic,assign) BOOL   seriesAlert;

/**
 *  @两个按钮纯文本显示（block回调方式）
 */
-(id)initWithTitle:(NSString *)title message:(NSString *)message buttonTitles:(NSString *)otherButtonTitles,... NS_REQUIRES_NIL_TERMINATION;

/**
 *  显示弹出框
 */
-(void)showWithCompletion:(void (^)(NSInteger selectIndex))completeBlock;

-(void)showInView:(UIView *)baseView completion:(void (^)(NSInteger selectIndex))completeBlock;

@end

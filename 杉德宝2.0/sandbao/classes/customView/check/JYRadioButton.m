//
//  JYRadioButton.m
//  sand_mobile_mask
//
//  Created by tianNanYiHao on 14-9-17.
//  Copyright (c) 2014年 sand. All rights reserved.
//

#import "JYRadioButton.h"

#define RADIO_ICON_WH                     (16.0)
#define ICON_TITLE_MARGIN                 (5.0)


static NSMutableDictionary *_groupRadioDic = nil;

@implementation JYRadioButton

@synthesize delegate = _delegate;
@synthesize checked  = _checked;

- (id)initWithDelegate:(id)delegate groupId:(NSString*)groupId {
    self = [super init];
    if (self) {
        _delegate = delegate;
        _groupId = [groupId copy];
        
        [self addToGroup];
        
        self.exclusiveTouch = YES;
        
        [self setImage:[UIImage imageNamed:@"radio_unchecked.png"] forState:UIControlStateNormal];
        [self setImage:[UIImage imageNamed:@"radio_checked.png"] forState:UIControlStateSelected];
        [self addTarget:self action:@selector(radioBtnChecked) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)addToGroup {
    if(!_groupRadioDic){
        _groupRadioDic = [NSMutableDictionary dictionary];
    }
    
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (!_gRadios) {
        _gRadios = [NSMutableArray array];
    }
    [_gRadios addObject:self];
    [_groupRadioDic setObject:_gRadios forKey:_groupId];
}

- (void)removeFromGroup {
    if (_groupRadioDic) {
        NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
        if (_gRadios) {
            [_gRadios removeObject:self];
            if (_gRadios.count == 0) {
                [_groupRadioDic removeObjectForKey:_groupId];
            }
        }
    }
}

- (void)uncheckOtherRadios {
    NSMutableArray *_gRadios = [_groupRadioDic objectForKey:_groupId];
    if (_gRadios.count > 0) {
        for (JYRadioButton *_radio in _gRadios) {
            if (_radio.checked && ![_radio isEqual:self]) {
                _radio.checked = NO;
            }
        }
    }
}

- (void)setChecked:(BOOL)checked {
    if (_checked == checked) {
        return;
    }
    
    _checked = checked;
    self.selected = checked;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
    }
}

- (void)radioBtnChecked {
    if (_checked) {
        return;
    }
    
    self.selected = !self.selected;
    _checked = self.selected;
    
    if (self.selected) {
        [self uncheckOtherRadios];
    }
    
    if (self.selected && _delegate && [_delegate respondsToSelector:@selector(didSelectedRadioButton:groupId:)]) {
        [_delegate didSelectedRadioButton:self groupId:_groupId];
        
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect {
    return CGRectMake(0, (CGRectGetHeight(contentRect) - RADIO_ICON_WH)/2.0, RADIO_ICON_WH, RADIO_ICON_WH);
}

- (CGRect)titleRectForContentRect:(CGRect)contentRect {
    return CGRectMake(RADIO_ICON_WH + ICON_TITLE_MARGIN, 0,
                      CGRectGetWidth(contentRect) - RADIO_ICON_WH - ICON_TITLE_MARGIN,
                      CGRectGetHeight(contentRect));
}

@end

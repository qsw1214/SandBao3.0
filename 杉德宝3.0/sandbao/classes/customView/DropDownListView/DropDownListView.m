//
//  DropDownListView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/3/2.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "DropDownListView.h"

@interface DropDownListView()<UITableViewDelegate, UITableViewDataSource>
{
    
}

@property(nonatomic, retain) UITableView *tableV;
@property(nonatomic, strong) UIView *view;
@property(nonatomic, retain) NSMutableArray *list;
@property(nonatomic, retain) NSMutableArray *delArr;

@end

@implementation DropDownListView

- (id)initWithShowDropDown:(UIView *)view :(NSArray *)arr
{
    self.view = view;
    self = [super init];
    if (self) {
        self.layer.cornerRadius = 5.0f;
        self.layer.borderWidth = 0.8f;
        self.layer.borderColor = [UIColor lightGrayColor].CGColor;
        
        CGRect rect = self.view.frame;
        self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
        self.list = [NSMutableArray arrayWithArray:arr];
        self.delArr = [NSMutableArray arrayWithArray:self.list];
        self.layer.masksToBounds = NO;
        self.layer.cornerRadius = 8;
        //self.layer.shadowOffset = CGSizeMake(-5, 5);
        //self.layer.shadowRadius = 5;
        //self.layer.shadowOpacity = 0.5;
        
        _tableV = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, rect.size.width, 0)];
        _tableV.delegate = self;
        _tableV.dataSource = self;
        _tableV.layer.cornerRadius = 5;
        _tableV.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        _tableV.backgroundColor = [UIColor whiteColor];
        _tableV.rowHeight = rect.size.height;
        [UIView beginAnimations:nil context:nil];
        [UIView setAnimationDuration:0.5];
        
        CGFloat height = 0;
        if (self.list.count < 6) {
            height = rect.size.height * self.list.count;
        } else {
            height = rect.size.height * 6;
        }
        
        self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, height);
        _tableV.frame = CGRectMake(0, 0, rect.size.width, height);
        [UIView commitAnimations];
        [self.view.superview addSubview:self];
        //解决tableView线不能铺满的问题
        if ([_tableV respondsToSelector:@selector(setSeparatorInset:)]){
            [_tableV setSeparatorInset:UIEdgeInsetsZero];
        }
        if ([_tableV respondsToSelector:@selector(setLayoutMargins:)]) {
            [_tableV setLayoutMargins:UIEdgeInsetsZero];
        }
        [self addSubview:_tableV];
    }
    return self;
}

-(void)hideDropDown
{
    CGRect rect = self.view.frame;
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, 0);
    _tableV.frame = CGRectMake(0, 0, rect.size.width, 0);
    [UIView commitAnimations];
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.list.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString* indentifier = @"cell";
    UITableViewCell *cell =[tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier];
    }
    cell.textLabel.font = [UIFont systemFontOfSize:15];
    cell.textLabel.textAlignment = NSTextAlignmentLeft;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.textLabel.textColor = [UIColor grayColor];
    cell.textLabel.text = self.list[indexPath.row];
    
    UIImage *delImage = [UIImage imageNamed:@"list_close.png"];
    UIButton *delBtn = [[UIButton alloc] init];
    delBtn.tag = indexPath.row;
    [delBtn setImage:delImage forState:UIControlStateNormal];
    delBtn.bounds = CGRectMake(0, 0, delImage.size.width, delImage.size.height);
    delBtn.contentMode = UIViewContentModeScaleAspectFit;
    [delBtn addTarget:self action:@selector(buttonAction:) forControlEvents:UIControlEventTouchUpInside];
    cell.accessoryView = delBtn;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *c = [tableView cellForRowAtIndexPath:indexPath];
    [self.delegate selectRowContent:c.textLabel.text];
    [self hideDropDown];
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([cell respondsToSelector:@selector(setSeparatorInset:)]) {
        [cell setSeparatorInset:UIEdgeInsetsZero];
    }
    if ([cell respondsToSelector:@selector(setLayoutMargins:)]) {
        [cell setLayoutMargins:UIEdgeInsetsZero];
    }
}

#pragma  - mark 按钮监听事件
- (void)buttonAction:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    [self.delegate deleteRowContent:btn.tag];
}

/**
 *@brief 添加
 *@param param NSDictionary 参数：添加内容字典
 *
 */
- (void)addRow:(NSDictionary *)param
{
    CGFloat height;
    CGRect rect = self.view.frame;
    
    [self.list addObject:param];
    //刷新下拉视图的size
    if (self.list.count < 6) {
        height = rect.size.height * self.list.count;
    }else{
        height = rect.size.height * 6;
    }
    _tableV.frame = CGRectMake(0, 0, rect.size.width, height);
    [_tableV reloadData];
}

/**
 *@brief 删除
 *@param param NSString 参数：删除索引
 *
 */
- (void)deleteRow:(NSInteger)param
{
    CGFloat height;
    CGRect rect = self.view.frame;
    
    [self.list removeObjectAtIndex:param];
    //刷新下拉视图的size
    if (self.list.count < 6) {
        height = rect.size.height * self.list.count;
    }else{
        height = rect.size.height * 6;
    }
    _tableV.frame = CGRectMake(0, 0, rect.size.width, height);
    self.frame = CGRectMake(rect.origin.x, rect.origin.y+rect.size.height, rect.size.width, height);
    [_tableV reloadData];
}

@end

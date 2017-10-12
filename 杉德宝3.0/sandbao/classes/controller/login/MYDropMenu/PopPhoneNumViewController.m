//
//  cusViewController.m
//  popBtn
//
//  Created by tianNanYiHao on 2017/3/1.
//  Copyright © 2017年 tianNanYiHao. All rights reserved.
//

#import "PopPhoneNumViewController.h"

@interface PopPhoneNumViewController ()<UITableViewDelegate,UITableViewDataSource>

@end

@implementation PopPhoneNumViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor orangeColor];
    
    
    UITableView *t = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width-2*15, 300)];
    [self.view addSubview:t];
    t.delegate = self;
    t.dataSource = self;
    
}


-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 3;
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *idd = @"idd";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:idd];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:idd];
    }
    cell.textLabel.text = [NSString stringWithFormat:@"1515147437%ld",indexPath.row];
    return cell;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (self.callback) {
        self.callback([NSString stringWithFormat:@"%ld",indexPath.row]);
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    
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

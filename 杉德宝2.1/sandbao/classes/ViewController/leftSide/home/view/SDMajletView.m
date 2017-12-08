//
//  SDMajletView.m
//  sandbao
//
//  Created by tianNanYiHao on 2017/10/31.
//  Copyright © 2017年 sand. All rights reserved.
//

#import "SDMajletView.h"
#import "SDMajletCell.h"


@interface SDMajletView ()<UICollectionViewDelegate,UICollectionViewDataSource>
{
    UICollectionView *collectionview;
    CGFloat cellHeight;
}

@end


@implementation SDMajletView


+ (instancetype)createMajletViewOY:(CGFloat)OY{
    
    SDMajletView *majletView = [[SDMajletView alloc] initWithFrame:CGRectMake(0, OY, 0, 0)];
    majletView.userInteractionEnabled = YES;
    return majletView;
    
}


- (instancetype)initWithFrame:(CGRect)frame{
    
    if ([super initWithFrame:frame]) {
        
    }
    
    return self;
}



- (void)setCellSpace:(NSInteger)cellSpace{
    
    _cellSpace = cellSpace;
    
    
    
}

- (void)setColumnNumber:(NSInteger)columnNumber{
    
    _columnNumber = columnNumber;

    [self createUI];
    
}


- (void)createUI{
    
    //flowLayout布局
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    CGFloat spaceCount = _columnNumber + 1 ; //(间隙count永远比列数多1)
    CGFloat cellWith = ([UIScreen mainScreen].bounds.size.width- spaceCount*_cellSpace)/_columnNumber;
    //cell size
    UIImage *iconImag = [UIImage imageNamed:@"index_service_01"];
    cellHeight = iconImag.size.height*2;
    //布局item大小
    flowLayout.itemSize = CGSizeMake(cellWith, cellHeight);
    //布局边距
    flowLayout.sectionInset = UIEdgeInsetsMake(_cellSpace-5, _cellSpace, _cellSpace-5, _cellSpace);
    //布局最小行间距
    flowLayout.minimumLineSpacing = _cellSpace-5;
    //布局最小列间距
    flowLayout.minimumInteritemSpacing = _cellSpace;
    
    collectionview = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 0) collectionViewLayout:flowLayout];
    collectionview.scrollEnabled = NO;
    collectionview.backgroundColor = [UIColor whiteColor];
    //复用ID必须和代理中的ID一致
    [collectionview registerClass:[SDMajletCell class] forCellWithReuseIdentifier:@"SDMajletCell"];
    collectionview.delegate = self;
    collectionview.dataSource = self;
    [self addSubview:collectionview];
    


}


- (void)setMajletArr:(NSMutableArray *)majletArr{
    
    _majletArr = majletArr;
    
    NSInteger lineCount = 0;
    
    if (self.majletArr.count%_columnNumber == 0) {
        lineCount = self.majletArr.count/_columnNumber;
    }
    if ((self.majletArr.count % _columnNumber > 0) && (self.majletArr.count % _columnNumber < _columnNumber)) {
        lineCount = (int)(self.majletArr.count/_columnNumber) + 1;
    }
    
    CGFloat collectionViewH = lineCount*(cellHeight + _cellSpace);
    
    collectionview.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, collectionViewH);
    
    self.frame = collectionview.frame;
    
    [collectionview reloadData];
}


#pragma mark  子件collection代理方法区
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.majletArr.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *cellID = @"SDMajletCell";
    SDMajletCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.font = 11;
    cell.iconName = [self.majletArr[indexPath.row] objectForKey:@"iconKey"];
    cell.title = [self.majletArr[indexPath.row] objectForKey:@"titleKey"];
    return cell;
    
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString *titleName = [self.majletArr[indexPath.row] objectForKey:@"titleKey"];    
    self.titleNameBlock(titleName);
    
}

@end

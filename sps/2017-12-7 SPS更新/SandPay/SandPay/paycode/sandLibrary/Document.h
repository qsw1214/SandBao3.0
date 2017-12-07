//
//  Document.h
//  sand_bluesky_demonstration
//
//  Created by blue sky on 15/5/20.
//  Copyright (c) 2015年 sand. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Document : NSObject{
    NSString *_fileName;
    NSString *_fileType;
    NSString *_filePath;
    NSData *_fileData;
}

-(void)setFileName:(NSString *)newFileName;
-(NSString *)fileName;

-(void)setFileType:(NSString *)newFileType;
-(NSString *)fileType;

-(void)setFilePath:(NSString *)newFilePath;
-(NSString *)filePath;

-(void)setFileData:(NSData *)newFileData;
-(NSData *)fileData;

@end

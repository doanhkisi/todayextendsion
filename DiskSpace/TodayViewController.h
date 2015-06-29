//
//  TodayViewController.h
//  DiskSpace
//
//  Created by Bui Duy Doanh on 6/29/15.
//  Copyright (c) 2015 doanhkisi. All rights reserved.
//
#define kWClosedHeight   40.0
#define kWExpandedHeight 120.0
#import <UIKit/UIKit.h>

@interface TodayViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIProgressView *progressBar;
@property (weak, nonatomic) IBOutlet UILabel *percenLabel;

@property (weak, nonatomic) IBOutlet UILabel *detalsLabel;

@property (nonatomic, assign) unsigned long long fileSystemSize;
@property (nonatomic, assign) unsigned long long freeSize;
@property (nonatomic, assign) unsigned long long usedSize;
@property (nonatomic, assign) double usedRate;

@end

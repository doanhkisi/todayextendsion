//
//  TodayViewController.m
//  DiskSpace
//
//  Created by Bui Duy Doanh on 6/29/15.
//  Copyright (c) 2015 doanhkisi. All rights reserved.
//

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self updateInterface];
    // new
    [self setPreferredContentSize:CGSizeMake(0.0, kWClosedHeight)];
    [self.detalsLabel setAlpha:0.0];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler
{
    
    [self updateSizes];
    
    double newRate = (double)self.usedSize / (double)self.fileSystemSize;
    
    if (newRate - self.usedRate < 0.0001) {
        completionHandler(NCUpdateResultNoData);
    } else {
        [self setUsedRate:newRate];
        [self updateInterface];
        completionHandler(NCUpdateResultNewData);
    }
}
- (void)updateSizes
{
    // Retrieve the attributes from NSFileManager
    NSDictionary *dict = [[NSFileManager defaultManager]
                          attributesOfFileSystemForPath:NSHomeDirectory()
                          error:nil];
    
    // Set the values
    self.fileSystemSize = [[dict valueForKey:NSFileSystemSize]
                           unsignedLongLongValue];
    self.freeSize       = [[dict valueForKey:NSFileSystemFreeSize]
                           unsignedLongLongValue];
    self.usedSize       = self.fileSystemSize - self.freeSize;
}

- (double)usedRate
{
    return [[[NSUserDefaults standardUserDefaults]
             valueForKey:@"diskpace"] doubleValue];
}

- (void)setUsedRate:(double)usedRate
{
    NSUserDefaults *defaults =
    [NSUserDefaults standardUserDefaults];
    [defaults setValue:[NSNumber numberWithDouble:usedRate]
                forKey:@"diskpace"];
    [defaults synchronize];
}

- (void)updateInterface
{
    double rate = self.usedRate; // retrieve the cached value
    self.percenLabel.text =
    [NSString stringWithFormat:@"%.1f%%", (rate * 100)];
    self.progressBar.progress = rate;
}
-(void)updateDetailsLabel
{
    NSByteCountFormatter *formatter =
    [[NSByteCountFormatter alloc] init];
    [formatter setCountStyle:NSByteCountFormatterCountStyleFile];
    
    self.detalsLabel.text =
    [NSString stringWithFormat:
     @"Used:\t%@\nFree:\t%@\nTotal:\t%@",
     [formatter stringFromByteCount:self.usedSize],
     [formatter stringFromByteCount:self.freeSize],
     [formatter stringFromByteCount:self.fileSystemSize]];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (self.preferredContentSize.height == kWClosedHeight) {
        [self updateDetailsLabel];
        [self setPreferredContentSize:
         CGSizeMake(0.0, kWExpandedHeight)];
    } else {
        [self setPreferredContentSize:CGSizeMake(0.0, kWClosedHeight)];
    }
}
@end

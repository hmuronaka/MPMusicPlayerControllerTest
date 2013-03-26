//
//  FlipsideViewController.h
//  MPMusicPlayerControllerTest
//
//  Created by MURONAKA HIROAKI on 2013/03/26.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FlipsideViewController;

@protocol FlipsideViewControllerDelegate
- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller;
@end

@interface FlipsideViewController : UIViewController

@property (weak, nonatomic) id <FlipsideViewControllerDelegate> delegate;

- (IBAction)done:(id)sender;

@end

//
//  MainViewController.h
//  MPMusicPlayerControllerTest
//
//  Created by MURONAKA HIROAKI on 2013/03/26.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import "FlipsideViewController.h"
#import <MediaPlayer/MediaPlayer.h>

@interface MainViewController : UIViewController
<MPMediaPickerControllerDelegate, FlipsideViewControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property(nonatomic, strong) IBOutlet UITableView* tableView;
@property(nonatomic, strong) IBOutlet UILabel* timeLabel;
@property(nonatomic, strong) IBOutlet UILabel* speedLabel;
@property(nonatomic, strong) IBOutlet UISlider* timeSlider;
@property(nonatomic, strong) IBOutlet UISlider* speedSlider;


-(IBAction)pressedInit:(id)sender;
-(IBAction)pressedSelectAlbum:(id)sender;
-(IBAction)pressedPlay:(id)sender;
-(IBAction)pressedStop:(id)sender;
-(IBAction)pressedPause:(id)sender;
-(IBAction)changedTimeValue:(UISlider*)slider;
-(IBAction)changedSpeedValue:(UISlider*)slider;

- (IBAction)showInfo:(id)sender;

@end

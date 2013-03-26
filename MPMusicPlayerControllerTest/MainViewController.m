//
//  MainViewController.m
//  MPMusicPlayerControllerTest
//
//  Created by MURONAKA HIROAKI on 2013/03/26.
//  Copyright (c) 2013年 H.Mu. All rights reserved.
//

#import "MainViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "Utilities.h"

@interface MainViewController ()

@property(nonatomic, strong) MPMusicPlayerController* musicPlayer;
@property(nonatomic, strong) NSTimer* cycleTimer;
@property(nonatomic, strong) MPMediaItemCollection* mediaItemCollection;
@property(nonatomic, strong) NSArray* rowTitleArray;

@end

@implementation MainViewController
@synthesize rowTitleArray = _rowTitleArray;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.cycleTimer = [NSTimer scheduledTimerWithTimeInterval:0.1f target:self selector:@selector(timeoutCycle) userInfo:nil repeats:YES];
    
    [self.speedSlider setMinimumValue:0.0f];
    [self.speedSlider setMaximumValue:2.0f];
    [self.timeSlider setMinimumValue:0.0f];
    [self.timeSlider setMaximumValue:60.0f];
}

-(NSArray*)rowTitleArray
{
    if( _rowTitleArray == nil ) {
        _rowTitleArray = [NSArray arrayWithObjects:
                          @"player status",
                          @"title",
                          nil];
    }
    return _rowTitleArray;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
                       
#pragma mark - timer --

-(void)timeoutCycle
{
    if( self.musicPlayer != nil )
    {
        self.timeLabel.text = [Utilities stringFromNSInterval:self.musicPlayer.currentPlaybackTime];
        self.speedLabel.text = [NSString stringWithFormat:@"%f", self.musicPlayer.currentPlaybackRate];
    }
    
    [self.tableView reloadData];
}

                       

#pragma mark - Flipside View

- (void)flipsideViewControllerDidFinish:(FlipsideViewController *)controller
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)showInfo:(id)sender
{    
    FlipsideViewController *controller = [[FlipsideViewController alloc] initWithNibName:@"FlipsideViewController" bundle:nil];
    controller.delegate = self;
    controller.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:controller animated:YES completion:nil];
}

#pragma mark -- player operations. --

-(void)initPlayer {
    self.musicPlayer = [MPMusicPlayerController applicationMusicPlayer];

    [self registerForMediaPlayerNotifications];
    
    [self.tableView reloadData];
}

// To learn about notifications, see "Notifications" in Cocoa Fundamentals Guide.
- (void) registerForMediaPlayerNotifications {
    
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self];
    
	[notificationCenter addObserver: self
						   selector: @selector (handle_PlaybackStateChanged:)
							   name: MPMusicPlayerControllerPlaybackStateDidChangeNotification
							 object: self.musicPlayer];
    
    
    [self.musicPlayer beginGeneratingPlaybackNotifications];
}

-(void)unregisterForMediaplayerNotifications
{
    [self.musicPlayer endGeneratingPlaybackNotifications];
	NSNotificationCenter *notificationCenter = [NSNotificationCenter defaultCenter];
    
    [notificationCenter removeObserver:self];
}

// When the playback state changes, set the play/pause button in the Navigation bar
//		appropriately.
- (void) handle_PlaybackStateChanged: (id) notification {
    
	MPMusicPlaybackState playbackState = [self.musicPlayer playbackState];
	
	if (playbackState == MPMusicPlaybackStatePaused) {
        NSLog(@"music player state paused.");
	} else if (playbackState == MPMusicPlaybackStatePlaying) {
        NSLog(@"music player state playing.");
	} else if (playbackState == MPMusicPlaybackStateStopped) {
        NSLog(@"music player state Stopped.");
    } else if( playbackState == MPMusicPlaybackStateSeekingForward ) {
        NSLog(@"music player seeking forward.");
    } else if( playbackState == MPMusicPlaybackStateSeekingBackward ) {
        NSLog(@"music player seeking backward.");
    }
    
    [self.tableView reloadData];
}

-(void)play {
    [self.musicPlayer play];
}

-(void)stop {
    [self.musicPlayer stop];
}

-(void)pause {
    [self.musicPlayer pause];
}

#pragma mark -- ui operations. --


-(IBAction)pressedInit:(id)sender {
    [self initPlayer];
}

-(IBAction)pressedPlay:(id)sender {
    [self play];
}
-(IBAction)pressedStop:(id)sender {
    [self stop];
}
-(IBAction)pressedPause:(id)sender {
    [self pause];
}

-(IBAction)pressedSelectAlbum:(id)sender {
    if( self.musicPlayer != nil )
    {
        MPMediaPickerController* controller = [[MPMediaPickerController alloc] initWithMediaTypes:MPMediaTypeMusic];
        controller.allowsPickingMultipleItems = YES;
        controller.delegate = self;
        [self presentViewController:controller animated:YES completion:nil];
    }
}

#pragma mark -- media picker delegate.

- (void) mediaPicker: (MPMediaPickerController *) mediaPicker didPickMediaItems: (MPMediaItemCollection *) aMediaItemCollection {
    [self.musicPlayer setQueueWithItemCollection:aMediaItemCollection];
    self.mediaItemCollection = aMediaItemCollection;
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}

// media picker view controllerで選択をキャンセルした場合
// Invoked when the user taps the Done button in the media item picker having chosen zero
//		media items to play
- (void) mediaPickerDidCancel: (MPMediaPickerController *) mediaPicker {
    [mediaPicker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -- uitable view datamodel

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch(section)
    {
        case 0:
            return self.rowTitleArray.count;
        case 1:
            return (self.mediaItemCollection == nil) ? 0 : self.mediaItemCollection.count;
        default:
            return 0;
    }
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* const cellIdentifier = @"MyCellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if( cell == nil )
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if( indexPath.section == 0)
    {
        [cell.textLabel setText:[self.rowTitleArray objectAtIndex:indexPath.row]];
        
        NSString* detailText = @"";
        if( indexPath.row == 0 )
        {
            detailText = [self playStatusToStr];
        }
        else if( indexPath.row == 1 )
        {
            detailText = [self titleOfNowPlaying];
        }
        [cell.detailTextLabel setText:detailText];
    }
    else if( indexPath.section == 1)
    {
        MPMediaItem* item = [self.mediaItemCollection.items objectAtIndex:indexPath.row];
        NSString* value = @"";
        if( item != nil )
        {
            value = [item valueForKey:MPMediaItemPropertyTitle];
        }
        else
        {
            value = @"item is nil";
        }
        [cell.textLabel setText:value];
    }
    return cell;
}

-(NSString*)playStatusToStr
{
    if( self.musicPlayer == nil) {
        return @"nil";
    }
    
    MPMusicPlaybackState state = self.musicPlayer.playbackState;
    switch(state)
    {
        case MPMusicPlaybackStatePaused:
            return @"paused";
        case MPMusicPlaybackStatePlaying:
            return @"playing";
        case MPMusicPlaybackStateSeekingBackward:
            return @"backword";
        case MPMusicPlaybackStateSeekingForward:
            return @"forward";
        case MPMusicPlaybackStateStopped:
            return @"stopped";
        default:
            return [NSString stringWithFormat:@"%d", state];
    }
}

-(NSString*)titleOfNowPlaying
{
    if( self.musicPlayer == nil ) {
        return @"music Player is nil;";
    }
    
    MPMediaItem* item = self.musicPlayer.nowPlayingItem;
    if( item == nil ) {
        return @"item is nil";
    }
    NSString* title = [item valueForKey:MPMediaItemPropertyTitle];
    return title;
}

-(IBAction)changedTimeValue:(UISlider*)slider
{
    if( self.musicPlayer != nil ){
        self.musicPlayer.currentPlaybackTime = slider.value;
    }
}

-(IBAction)changedSpeedValue:(UISlider*)slider
{
    if( self.musicPlayer != nil ) {
        self.musicPlayer.currentPlaybackRate = slider.value;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if( indexPath.section == 1)
    {
        MPMediaItem* item = [self.mediaItemCollection.items objectAtIndex:indexPath.row];
        self.musicPlayer.nowPlayingItem = item;
        [self.tableView reloadData];
    }
}


@end

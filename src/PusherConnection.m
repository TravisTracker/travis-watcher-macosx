//
//  PusherConnection.m
//  Travis Toolbar
//
//  Created by Henrik Hodne on 5/16/12.
//  Copyright (c) 2012 Travis CI GmbH. All rights reserved.
//

#import <Growl/Growl.h>
#import <Pusher/PTPusherChannel.h>
#import <Pusher/PTPusherEvent.h>
#import "Constants.h"

#import "PusherConnection.h"

@interface PusherConnection ()

@property (strong) PTPusher *pusher;
@property (strong) PTPusherChannel *channel;

- (void)handleStarted:(PTPusherEvent *)event;
- (void)handleFinished:(PTPusherEvent *)event;

@end

@implementation PusherConnection

@synthesize pusher = _pusher;
@synthesize channel = _channel;

- (id)init {
  self = [super init];
  if (self) {
    self.pusher = [PTPusher pusherWithKey:kPusherApiKey delegate:self encrypted:YES];
    self.pusher.reconnectAutomatically = YES;
    
    self.channel = [self.pusher subscribeToChannelNamed:kPusherChannelName];
    
    [self.channel bindToEventNamed:kPusherEventBuildStarted target:self action:@selector(handleStarted:)];
    [self.channel bindToEventNamed:kPusherEventBuildFinished target:self action:@selector(handleFinished:)];
  }
  
  return self;
}

- (void)handleStarted:(PTPusherEvent *)event {
  [GrowlApplicationBridge notifyWithTitle:[[event.data objectForKey:@"repository"] objectForKey:@"slug"]
                              description:@"Starting build!"
                         notificationName:@"Build Information"
                                 iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}

- (void)handleFinished:(PTPusherEvent *)event {
  [GrowlApplicationBridge notifyWithTitle:[[event.data objectForKey:@"repository"] objectForKey:@"slug"]
                              description:@"Finished build!"
                         notificationName:@"Build Information"
                                 iconData:[[NSImage imageNamed:@"travis_logo.png"] TIFFRepresentation]
                                 priority:0
                                 isSticky:NO
                             clickContext:nil];
}

@end

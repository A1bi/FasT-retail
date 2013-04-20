//
//  FasTNode.m
//  FasT-retail
//
//  Created by Albrecht Oster on 17.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTNode.h"
#import "FasTEvent.h"
#import "SocketIOPacket.h"

static FasTNode *defaultNode = nil;
static NSString *kNodeUrl = @"fast.albisigns";

@interface FasTNode ()

@end

@implementation FasTNode

@synthesize event;

+ (FasTNode *)defaultNode
{
	if (!defaultNode) {
		defaultNode = [[super allocWithZone:NULL] init];
	}
	
	return defaultNode;
}

+ (id)allocWithZone:(NSZone *)zone
{
	return [self defaultNode];
}

- (id)init
{
	if (defaultNode) {
		return defaultNode;
	}
	
	self = [super init];
	if (self) {
        io = [[SocketIO alloc] initWithDelegate:self];
        [io setUseSecure:YES];
        [io connectToHost:kNodeUrl onPort:0 withParams:nil withNamespace:@"/retail"];
	}
	
	return self;
}

- (void)dealloc
{
    [io release];
    [event release];
    [super dealloc];
}

#pragma mark SocketIO delegate methods

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSDictionary *info = [packet dataAsJSON][@"args"][0];
    
    if ([[packet name] isEqualToString:@"updateSeats"]) {
        NSDictionary *seats = info[@"seats"];
        [event updateSeats:seats];
        
        NSNotification *notification = [NSNotification notificationWithName:@"updateSeats" object:self userInfo:seats];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    
    } else if ([[packet name] isEqualToString:@"updateEvent"]) {
        [self setEvent:[[FasTEvent alloc] initWithInfo:info[@"event"]]];
    }
}

#pragma mark class methods

- (void)updateOrderWithStep:(NSString *)step info:(NSDictionary *)info callback:(void (^)(NSDictionary *))callback
{
    NSDictionary *data = @{ @"order": @{@"step": step, @"info": info} };
    [io sendEvent:@"updateOrder" withData:data andAcknowledge:callback];
}

@end

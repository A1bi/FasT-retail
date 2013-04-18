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


@implementation NSURLRequest(AllowAllCerts)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host {
    return YES;
}

@end


static FasTNode *defaultNode = nil;
static NSString *kNodeUrl = @"fast.albisigns";

@interface FasTNode ()

- (void)processSeats:(NSDictionary *)seats;
- (void)updateEvent;

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
        [io connectToHost:kNodeUrl onPort:0 withParams:nil withNamespace:@"/purchase"];
        
        event = [[FasTEvent alloc] init];
        
        [self updateEvent];
	}
	
	return self;
}

- (void)dealloc
{
    [io release];
    [event release];
    [super dealloc];
}

#pragma mark class methods

- (void)updateEvent
{
    NSError *error = nil;
    NSString *url = @"https://fast.albisigns/api/events/current";
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    NSData *response = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:&error];
    if (error) NSLog(@"%@", error);
    
    NSDictionary *eventInfo = [NSJSONSerialization JSONObjectWithData:response options:kNilOptions error:&error];
    if (error) NSLog(@"%@", error);
    
    [event updateWithInfo:eventInfo];
}

- (void)processSeats:(NSDictionary *)seats
{
    NSMutableDictionary *eventSeats = [event seats];
    for (NSString *date in seats) {
        NSMutableDictionary *eventDateSeats = [eventSeats objectForKey:date];
        if (!eventDateSeats) {
            eventDateSeats = [NSMutableDictionary dictionary];
            [eventSeats setObject:eventDateSeats forKey:date];
        }
        
        NSDictionary *dateSeats = [seats objectForKey:date];
        for (NSString *seatId in dateSeats) {
            [eventDateSeats setObject:[dateSeats objectForKey:seatId] forKey:seatId];
        }
    }
}

#pragma mark SocketIO delegate methods

- (void)socketIO:(SocketIO *)socket didReceiveEvent:(SocketIOPacket *)packet
{
    NSDictionary *info = [[[packet dataAsJSON] objectForKey:@"args"] objectAtIndex:0];
    
    if ([[packet name] isEqualToString:@"updateSeats"]) {
        [self processSeats:[info objectForKey:@"seats"]];
        
        NSNotification *notification = [NSNotification notificationWithName:@"updateSeats" object:self userInfo:[info objectForKey:@"seats"]];
        [[NSNotificationCenter defaultCenter] postNotification:notification];
    }
}

@end

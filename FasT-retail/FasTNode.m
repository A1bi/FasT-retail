//
//  FasTNode.m
//  FasT-retail
//
//  Created by Albrecht Oster on 17.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTNode.h"

static FasTNode *defaultNode = nil;
static NSString *kNodeUrl = @"fast.albisigns";

@implementation FasTNode

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
	}
	
	return self;
}

- (void)dealloc
{
    [io release];
    [super dealloc];
}

@end

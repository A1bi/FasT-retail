//
//  FasTNode.h
//  FasT-retail
//
//  Created by Albrecht Oster on 17.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SocketIO.h"

@class FasTEvent;

@interface FasTNode : NSObject <SocketIODelegate>
{
    SocketIO *io;
    FasTEvent *event;
}

@property (nonatomic, retain) FasTEvent *event;

+ (FasTNode *)defaultNode;

@end

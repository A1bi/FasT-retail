//
//  FasTTicketPrinter.h
//  FasT-retail
//
//  Created by Albrecht Oster on 27.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PKPrintSettings;
@class PKPrinter;

@interface FasTTicketPrinter : NSObject
{
    CGFloat posX, posY;
    CGFloat ticketWidth, ticketHeight;
    CGContextRef context;
    NSDictionary *fonts;
    NSString *ticketsPath;
    PKPrintSettings *printSettings;
    PKPrinter *printer;
}

- (void)printTicketsWithInfo:(NSDictionary *)info;

@end

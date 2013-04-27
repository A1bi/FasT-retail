//
//  FasTTicketPrinter.m
//  FasT-retail
//
//  Created by Albrecht Oster on 27.04.13.
//  Copyright (c) 2013 Albisigns. All rights reserved.
//

#import "FasTTicketPrinter.h"
#import "PKPrinter.h"
#import "PKPrintSettings.h"
#import "PKPaper.h"

#define kPointsToMilimetersFactor 35.28

@interface FasTTicketPrinter ()

- (void)generatePDFWithTicketInfo:(NSDictionary *)info;
- (void)generateTicketWithInfo:(NSDictionary *)info;
- (void)drawBarcodeWithContent:(NSString *)content;
- (void)drawLogo;
- (void)drawEventInfoWithInfo:(NSDictionary *)info;
- (void)drawTicketInfoWithInfo:(NSDictionary *)info;
- (void)drawBottomInfoWithInfo:(NSDictionary *)info;
- (void)drawSeparatorWithSize:(CGSize)size;
- (CGSize)drawText:(NSString *)text withFont:(UIFont *)font;
- (CGSize)drawText:(NSString *)text withFontSize:(NSString *)size;
- (CGSize)drawText:(NSString *)text withFontSize:(NSString *)size andIncreaseY:(BOOL)incY;

@end

@implementation FasTTicketPrinter

- (id)init
{
    self = [super init];
    if (self) {
        ticketWidth = 595, ticketHeight = 270;
        
        NSString *fontName = @"Avenir";
        NSMutableDictionary *tmpFonts = [NSMutableDictionary dictionary];
        NSDictionary *fontSizes = @{@"normal": @(16), @"small": @(13), @"tiny": @(11)};
        for (NSString *fontSize in fontSizes) {
            tmpFonts[fontSize] = [UIFont fontWithName:fontName size:[fontSizes[fontSize] floatValue]];
        }
        fonts = [NSDictionary dictionaryWithDictionary:tmpFonts];
        
        ticketsPath = [NSString stringWithFormat:@"%@tickets.pdf", NSTemporaryDirectory()];
        
        PKPaper *ticketPaper = [[[PKPaper alloc] initWithWidth:ticketWidth * kPointsToMilimetersFactor Height:ticketHeight * kPointsToMilimetersFactor Left:0 Top:0 Right:0 Bottom:0 localizedName:nil codeName:nil] autorelease];
        printSettings = [PKPrintSettings default];
        [printSettings setPaper:ticketPaper];
        
        printer = [PKPrinter printerWithName:@"HP P1102w 3._ipp._tcp.local."];
    }
    return self;
}

- (void)printTicketsWithInfo:(NSDictionary *)info
{
    [self generatePDFWithTicketInfo:info];

    [printer printURL:[NSURL fileURLWithPath:ticketsPath] ofType:@"application/pdf" printSettings:printSettings];
}

- (void)generatePDFWithTicketInfo:(NSDictionary *)info
{
    UIGraphicsBeginPDFContextToFile(ticketsPath, CGRectMake(0, 0, ticketWidth, ticketHeight), nil);
    context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[UIColor blackColor] CGColor]);
    
    [self generateTicketWithInfo:nil];
    
    UIGraphicsEndPDFContext();
}

- (void)generateTicketWithInfo:(NSDictionary *)info
{
    posX = 0, posY = 0;
    UIGraphicsBeginPDFPage();
    
    [self drawBarcodeWithContent:nil];
    [self drawLogo];
    [self drawEventInfoWithInfo:nil];
    [self drawTicketInfoWithInfo:nil];
    [self drawBottomInfoWithInfo:nil];
}

- (void)drawBarcodeWithContent:(NSString *)content
{
    posX = 10;
    posY = 10;
    //////
    posX += 100;
    
    [self drawSeparatorWithSize:CGSizeMake(.5, ticketHeight - posY * 2)];
    posX += 30;
    posY += 9;
}

- (void)drawLogo
{
    UIImage *logo = [UIImage imageNamed:@"logo.png"];
    CGSize size = [logo size];
    CGFloat width = 100, margin = 20;
    CGRect logoRect = CGRectMake(ticketWidth - width - margin, margin, width, size.height / size.width * width);
    [logo drawInRect:logoRect];
}

- (void)drawEventInfoWithInfo:(NSDictionary *)info
{
    UIFont *eventTitleFont = [UIFont fontWithName:@"SnellRoundhand" size:40];
    CGSize size = [self drawText:@"Example" withFont:eventTitleFont];
    posY += size.height + 10;
    
    [self drawText:@"31. August 2013, 20.00 Uhr" withFontSize:@"normal" andIncreaseY:YES];
    [self drawText:@"Einlass ab 19.00 Uhr" withFontSize:@"small" andIncreaseY:YES];
    posY += 10;
    [self drawText:@"Historischer Ortskern, Kaisersesch" withFontSize:@"small" andIncreaseY:YES];
    posY += 5;
}

- (void)drawTicketInfoWithInfo:(NSDictionary *)info
{
    CGFloat tmpX = posX;
    UIFont *font = fonts[@"normal"];
    
    NSString *printString = @"Erwachsener";
    CGSize size = [printString sizeWithFont:font];
    posX = ticketWidth - size.width - 50;
    [self drawText:printString withFontSize:@"normal" andIncreaseY:YES];
    
    printString = @"12,00 €";
    size = [printString sizeWithFont:font];
    posX = ticketWidth - size.width - 50;
    [self drawText:printString withFontSize:@"normal" andIncreaseY:YES];
    posY += size.height + 15;
    posX = tmpX;
}

- (void)drawBottomInfoWithInfo:(NSDictionary *)info
{
    [self drawSeparatorWithSize:CGSizeMake(ticketWidth-posX-40, .5)];
    posY += 9;
    posX += 5;
    
    CGSize size = [self drawText:@"Ticket: 162534" withFontSize:@"tiny" andIncreaseY:NO];
    posX += 15;
    [self drawSeparatorWithSize:CGSizeMake(.3, size.height)];
    posX += 15.3;
    size = [self drawText:@"Order: 162534" withFontSize:@"tiny" andIncreaseY:NO];
    posX += 15;
    [self drawSeparatorWithSize:CGSizeMake(.3, size.height)];
    posX += 15.3;
    [self drawText:@"www.example.com" withFontSize:@"tiny"];
}

- (void)drawSeparatorWithSize:(CGSize)size
{
    CGContextFillRect(context, CGRectMake(posX, posY, size.width, size.height));
}

- (CGSize)drawText:(NSString *)text withFont:(UIFont *)font
{
    return [text drawAtPoint:CGPointMake(posX, posY) withFont:font];
}

- (CGSize)drawText:(NSString *)text withFontSize:(NSString *)size
{
    return [self drawText:text withFontSize:size andIncreaseY:-1];
}

- (CGSize)drawText:(NSString *)text withFontSize:(NSString *)size andIncreaseY:(BOOL)incY
{
    UIFont *font = fonts[size];
    [self drawText:text withFont:font];
    
    CGSize textSize = [text sizeWithFont:font];
    if (incY == YES) {
        posY += textSize.height;
    } else if (incY == NO) {
        posX += textSize.width;
    }
    
    return textSize;
}

@end

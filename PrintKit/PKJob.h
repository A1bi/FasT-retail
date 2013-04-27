@class PKPrintSettings;

@interface PKJob : NSObject
{
    int number;
    int mediaProgress;
    int mediaSheets;
    int mediaSheetsCompleted;
    NSString *printerDisplayName;
    int printerKind;
    NSString *printerLocation;
    PKPrintSettings *settings;
    int state;
    NSDate *timeAtCompleted;
    NSDate *timeAtCreation;
    NSDate *timeAtProcessing;
    NSData *thumbnailImage;
}

+ (id)jobs;
+ (id)currentJob;
@property(retain, nonatomic) NSData *thumbnailImage; // @synthesize thumbnailImage;
@property(retain, nonatomic) NSDate *timeAtProcessing; // @synthesize timeAtProcessing;
@property(retain, nonatomic) NSDate *timeAtCreation; // @synthesize timeAtCreation;
@property(retain, nonatomic) NSDate *timeAtCompleted; // @synthesize timeAtCompleted;
@property(nonatomic) int state; // @synthesize state;
@property(retain, nonatomic) PKPrintSettings *settings; // @synthesize settings;
@property(retain, nonatomic) NSString *printerLocation; // @synthesize printerLocation;
@property(nonatomic) int printerKind; // @synthesize printerKind;
@property(retain, nonatomic) NSString *printerDisplayName; // @synthesize printerDisplayName;
@property(nonatomic) int mediaSheetsCompleted; // @synthesize mediaSheetsCompleted;
@property(nonatomic) int mediaSheets; // @synthesize mediaSheets;
@property(nonatomic) int mediaProgress; // @synthesize mediaProgress;
@property(nonatomic) int number; // @synthesize number;
- (int)update;
- (int)cancel;

@end


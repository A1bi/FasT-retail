@class PKPaper;

@interface PKPrintSettings : NSObject
{
    NSMutableDictionary *_dict;
    PKPaper *paper;
}

+ (id)printSettingsForPrinter:(id)arg1;
+ (id)photo;
+ (id)default;
@property(retain, nonatomic) PKPaper *paper; // @synthesize paper;
@property(retain, nonatomic) NSMutableDictionary *dict; // @synthesize dict=_dict;
- (id)objectForKey:(id)arg1;
- (void)removeObjectForKey:(id)arg1;
- (void)setObject:(id)arg1 forKey:(id)arg2;
- (id)settingsDict;

@end


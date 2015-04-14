#ifndef story_Setting_h
#define story_Setting_h


@interface Setting : NSObject

@property NSMutableArray *values;
@property NSMutableDictionary *links;
@property (strong, nonatomic) NSNumber *index;

+ (Setting *)settingWithValues:(NSArray*)values;
+ (void)generateSome:(int)howMany;
+ (NSArray*)all;
+ (void)linkThem;

@end



#endif

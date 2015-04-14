#ifndef story_Setting_h
#define story_Setting_h


@interface Setting : NSObject

@property NSMutableArray *values;
@property NSMutableDictionary *links;
@property (strong, nonatomic) NSNumber *index;

+ (Setting *)settingWithValues:(NSArray*)values;
+ (NSArray*)generateSome:(int)howMany;
+ (NSMutableArray*)all;
+ (void)linkThem;

@end



#endif

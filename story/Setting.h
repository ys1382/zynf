@interface Setting : NSObject

@property NSMutableDictionary *values;  // { item.name : { state.name : state.value } }
@property NSMutableDictionary *links;   // { action.index : setting.index }
@property (strong, nonatomic) NSNumber *index;

+ (Setting *)settingWithValues:(NSDictionary *)values;
+ (void)generateSome:(int)howMany;
+ (NSArray*)all;
+ (void)linkThem;
- (NSString *)guid;

@end

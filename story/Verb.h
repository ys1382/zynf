#import "Setting.h"

// attempts to perform action
// returns resulting setting  or nil if impossible
typedef NSString *(^Attempt)(Setting *);

@interface Verb : NSObject

@property (strong, nonatomic) NSString *name;

+ (Verb *)verbWithName:(NSString *)name does:(Attempt)attempt;
+ (NSMutableArray *)all;
- (NSString *)attemptIn:(Setting *)setting;

@end

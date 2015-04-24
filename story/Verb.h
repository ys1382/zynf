#import "Setting.h"
#import "Action.h"


@class Action;


// attempts to perform action
// returns resulting setting  or nil if impossible
typedef NSString *(^Attempt)(Setting*, Action*);

@interface Verb : NSObject

@property (strong, nonatomic) NSString *name;

+ (Verb *)verbWithName:(NSString *)name does:(Attempt)attempt;
+ (NSMutableArray *)all;
- (NSString *)attempt:(Action *)action in:(Setting *)setting;

@end

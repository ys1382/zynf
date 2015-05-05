#import "Verb.h"
#import "Item.h"


@class Verb;


@interface Action : NSObject

+ (NSArray*) generateSome:(NSUInteger)howMany;

@property (strong, nonatomic) Verb *verb;
@property (strong, nonatomic) Item *subject;
@property (strong, nonatomic) Item *object;
@property (strong, nonatomic) NSNumber *index;

+ (NSMutableArray*)all;
- (NSString *)attemptIn:(Setting *)setting;

@end

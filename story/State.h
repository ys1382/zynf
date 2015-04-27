#import <Foundation/Foundation.h>

@interface State : NSObject

@property (strong, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *values;
@property (strong, nonatomic) NSNumber *index;

+ (State*)stateWithName:(NSString*)name values:(NSArray*)values;

@end

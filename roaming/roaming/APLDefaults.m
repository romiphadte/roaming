#import "APLDefaults.h"


NSString *BeaconIdentifier = @"com.example.apple-samplecode.AirLocate";


@implementation APLDefaults

- (id)init
{
    self = [super init];
    if(self)
    {
        // uuidgen should be used to generate UUIDs.
        _supportedProximityUUIDs = @[[[NSUUID alloc] initWithUUIDString:@"6A6908A6-F479-4938-A261-55033FC6A70B"]];
        _defaultPower = @-59;
    }
    
    return self;
}


+ (APLDefaults *)sharedDefaults
{
    static id sharedDefaults = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedDefaults = [[self alloc] init];
    });
    
    return sharedDefaults;
}


- (NSUUID *)defaultProximityUUID
{
    return _supportedProximityUUIDs[0];
}


@end

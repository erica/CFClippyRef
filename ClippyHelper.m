/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */


#import "ClippyHelper.h"

/*
 
 2012-06-19 10:16:45.331 HelloWorld[19042:c07] (
 GetArtsy,
 Save,
 Hide,
 LookRight,
 Hearing,
 RestPose,
 GestureDown,
 IdleSideToSide,
 IdleAtom,
 Print,
 Alert,
 LookUp,
 LookDownRight,
 GestureLeft,
 GetTechy,
 Searching,
 Explain,
 GetWizardy,
 Show,
 Processing,
 CheckingSomething,
 Writing,
 GetAttention,
 IdleEyeBrowRaise,
 IdleRopePile,
 SendMail,
 IdleHeadScratch,
 Wave,
 Congratulate,
 GestureUp,
 IdleFingerTap,
 Idle,
 GestureRight,
 LookDown,
 Greeting,
 LookLeft,
 EmptyTrash,
 IdleSnooze,
 LookUpRight,
 LookUpLeft,
 Thinking,
 GoodBye,
 LookDownLeft
 )
 
 */

@implementation ClippyHelper
@synthesize animations;

- (NSArray *) animationNames
{
    return animations.allKeys;
}

- (NSArray *) animationSequenceNamed: (NSString *) aName
{
    if (![animations.allKeys containsObject:aName]) return nil;
    
    NSDictionary *intermediate = [animations objectForKey:aName];
    if (!intermediate) return nil;
    
    NSMutableArray *frames = [NSMutableArray array];
    
    NSArray *seqArray = [intermediate objectForKey:@"frames"];
    for (id eachItem in seqArray)
    {
        if (![eachItem isKindOfClass:[NSDictionary class]])
        {
            NSLog(@"Encountered non-dict item: %@", eachItem);
            continue;
        }
        
        NSDictionary *dict = (NSDictionary *) eachItem;
        if (![dict objectForKey:@"images"])
        {
            NSLog(@"Skipping item without images: %@", eachItem);
            continue;
        }
        
        // Skip w/key "branching"?
        
        NSArray *coords = [dict objectForKey:@"images"];
        for (NSArray *item in coords)
        {
            uint x = [[item objectAtIndex:0] intValue] / helper.tileSize.width;
            uint y = [[item objectAtIndex:1] intValue] / helper.tileSize.height;
            UIImage *frame = [helper getFrameAtX:x andY:y];
            if (frame) [frames addObject:frame];
        }
    }
    
    return frames;
}

- (UIImageView *) baseImageView
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){.size = helper.tileSize}];
    
    imageView.backgroundColor = [UIColor clearColor];
    
    return imageView;
}

- (void) addAnimation: (NSString *) aName to: (UIImageView *) aView repeats: (BOOL) yorn
{
    NSArray *frames = [self animationSequenceNamed:aName];
    if (!frames)
    {
        aView.animationImages = nil;
        return;
    }
    
    aView.animationImages = frames;
    aView.animationDuration = frames.count * 0.2f;
    aView.animationRepeatCount = yorn ? 0 : 1;
    [aView startAnimating];
}

- (UIImageView *) animationNamed: (NSString *) aName repeats: (BOOL) yorn
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:(CGRect){.size = helper.tileSize}];
    
    NSArray *frames = [self animationSequenceNamed:aName];
    if (!frames) return nil;
    
    imageView.backgroundColor = [UIColor clearColor];
    [imageView setAnimationImages:frames];
    [imageView setAnimationDuration:frames.count * 0.2f];
    imageView.animationRepeatCount = yorn ? 0 : 1;
    [imageView startAnimating];

    return imageView;
}

- (id) init
{
    if (!([super init])) return self;
    
    UIImage *basePNG = [UIImage imageNamed:@"clippymap.png"];
    CGSize tileSize = CGSizeMake(124.0f, 93.0f);

    helper = [TileHelper helperWithMap:basePNG];
    helper.tileSize = tileSize;
    if (!helper.validTileSize)
    {
        NSLog(@"Error initializing Clippy tile size");
        return self;
    }
    
    // Load animations
    NSString *path = [[NSBundle mainBundle] pathForResource:@"animjson" ofType:@"txt"];
    NSString *string = [NSString stringWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
    NSData *data = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    animations = [json objectForKey:@"animations"];

    return self;
}

+ (id) helper
{
    ClippyHelper *aHelper = [[self alloc] init];
    
    return aHelper;
}
@end

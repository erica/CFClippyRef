#CFClippyRef

The Clippy package consists of a core tile image (clippymap.png) and JSON (animjson.txt) that describes how the animation sequences are built from individual tiles. These resources are straight from the [Clippy.JS] (http://www.smore.com/clippy-js) project, by the smore group.

Their project was released under an MIT license. They take care to note *All Microsoft agents, including agent names, the Clippy brand and all resources are the property of Microsoft and their respective owners.*.

My extensions are released under my standard BSD license:
/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 6.x Edition
 BSD License, Use at your own risk
 */

My extensions include a tile helper class (TileHelper) that extracts individual tiles from a combined PNG and a shared Clippy helper (ClippyHelper) which retrieves sequenced animation frames and can build UIImage animations for you.

**Create a helper**
+ (id) helper;

** Create a properly-sized Clippy-ready image view ** 
- (UIImageView *) baseImageView;

**List all animations available**
- (NSArray *) animationNames;
 
*Be aware that I only roughly implement the animations, and there's lots of work to be done adding proper sequencing and branching.*

**Retrieve a fully populated UIImageView with a named animation**
- (UIImageView *) animationNamed: (NSString *) aName repeats: (BOOL) yorn;

**Retrieve an array of animation frames for a named animation**
- (NSArray *) animationSequenceNamed: (NSString *) aName;

**Replace an image view's animation with the named animation sequence**
- (void) addAnimation: (NSString *) aName to: (UIImageView *) aView repeats: (BOOL) yorn;

##Available Animations##
* GetArtsy
* Save
* Hide
* LookRight
* Hearing
* RestPose
* GestureDown
* IdleSideToSide
* IdleAtom
* Print
* Alert
* LookUp
* LookDownRight
* GestureLeft
* GetTechy
* Searching
* Explain
* GetWizardy
* Show
* Processing
* CheckingSomething
* Writing
* GetAttention
* IdleEyeBrowRaise
* IdleRopePile
* SendMail
* IdleHeadScratch
* Wave
* Congratulate
* GestureUp
* IdleFingerTap
* Idle
* GestureRight
* LookDown
* Greeting
* LookLeft
* EmptyTrash
* IdleSnooze
* LookUpRight
* LookUpLeft
* Thinking
* GoodBye
* LookDownLeft




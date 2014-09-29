//
//  CodeaViewController.h
//  Hop Schedule Timer
//
//  Created by starter4ten on Monday, 29 September 2014
//  Copyright (c) starter4ten. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol CodeaAddon;

typedef enum CodeaViewMode
{
    CodeaViewModeStandard,
    CodeaViewModeFullscreen,
    CodeaViewModeFullscreenNoButtons,
} CodeaViewMode;

@interface CodeaViewController : UIViewController

@property (nonatomic, assign) CodeaViewMode viewMode;
@property (nonatomic, assign) BOOL paused;

- (void) setViewMode:(CodeaViewMode)viewMode animated:(BOOL)animated;

- (void) loadProjectAtPath:(NSString*)path;

- (void) registerAddon:(id<CodeaAddon>)addon;

@end

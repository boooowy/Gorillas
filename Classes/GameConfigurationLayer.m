/*
 * This file is part of Gorillas.
 *
 *  Gorillas is open software: you can use or modify it under the
 *  terms of the Java Research License or optionally a more
 *  permissive Commercial License.
 *
 *  Gorillas is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.
 *
 *  You should have received a copy of the Java Research License
 *  along with Gorillas in the file named 'COPYING'.
 *  If not, see <http://stuff.lhunath.com/COPYING>.
 */

//
//  ConfigurationLayer.m
//  Gorillas
//
//  Created by Maarten Billemont on 26/10/08.
//  Copyright 2008-2009, lhunath (Maarten Billemont). All rights reserved.
//

#import "GameConfigurationLayer.h"
#import "GorillasAppDelegate.h"
#import "CityTheme.h"


@interface GameConfigurationLayer ()

- (void)cityTheme:(id)sender;
- (void)gravity:(id)sender;
- (void)level:(id)sender;
- (void)replay:(id)sender;
- (void)followThrow:(id)sender;
- (void)back:(id)selector;

@end



@implementation GameConfigurationLayer


-(id) init {
    
    if(!(self = [super init]))
        return self;
    
    
    // City Theme.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].smallFontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fixedFontName];
    CCMenuItem *themeT    = [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.choose.theme", @"City Theme")];
    [themeT setIsEnabled:NO];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fontName];
    themeI    = [[CCMenuItemToggle alloc] initWithTarget:self selector:@selector(cityTheme:)];
    NSMutableArray *themeMenuItems = [NSMutableArray arrayWithCapacity:[[CityTheme getThemes] count]];
    for (NSString *themeName in [[CityTheme getThemes] allKeys])
        [themeMenuItems addObject:[CCMenuItemFont itemFromString:themeName]];
    themeI.subItems = themeMenuItems;
    [themeI setSelectedIndex:1];
    
    
    // Gravity.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].smallFontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fixedFontName];
    CCMenuItem *gravityT  = [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.choose.gravity", @"Gravity")];
    [gravityT setIsEnabled:NO];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fontName];
    gravityI  = [[CCMenuItemFont alloc] initFromString:[NSString stringWithFormat:@"%d", [[GorillasConfig get].gravity unsignedIntValue]]
                                              target:self selector:@selector(gravity:)];

    
    // Difficulity Level.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].smallFontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fixedFontName];
    CCMenuItem *levelT    = [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.choose.level", @"Level")];
    [levelT setIsEnabled:NO];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fontName];
    levelI    = [[CCMenuItemToggle alloc] initWithTarget:self selector:@selector(level:)];
    NSMutableArray *levelMenuItems = [NSMutableArray arrayWithCapacity:[[CityTheme getThemes] count]];
    for (NSString *levelName in [GorillasConfig get].levelNames)
        [levelMenuItems addObject:[CCMenuItemFont itemFromString:levelName]];
    levelI.subItems = levelMenuItems;
    [levelI setSelectedIndex:1];
    
    
    // Killshot Replays.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].smallFontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fixedFontName];
    CCMenuItem *replayT  = [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.choose.replays", @"Replays")];
    [replayT setIsEnabled:NO];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fontName];
    replayI  = [[CCMenuItemToggle itemWithTarget:self selector:@selector(replay:) items:
                [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.off", @"Off")],
                [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.on", @"On")],
                nil] retain];
    
    
    // Follow Throw.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].smallFontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fixedFontName];
    CCMenuItem *followT  = [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.choose.follow", @"Follow Throw")];
    [followT setIsEnabled:NO];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    [CCMenuItemFont setFontName:[GorillasConfig get].fontName];
    followI  = [[CCMenuItemToggle itemWithTarget:self selector:@selector(followThrow:) items:
                [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.off", @"Off")],
                [CCMenuItemFont itemFromString:NSLocalizedString(@"entries.on", @"On")],
                nil] retain];
    
    
    CCMenu *menu = [CCMenu menuWithItems:themeT, themeI, gravityT, levelT, gravityI, levelI, replayT, followT, replayI, followI, nil];
    [menu alignItemsInColumns:
     [NSNumber numberWithUnsignedInteger:1],
     [NSNumber numberWithUnsignedInteger:1],
     [NSNumber numberWithUnsignedInteger:2],
     [NSNumber numberWithUnsignedInteger:2],
     [NSNumber numberWithUnsignedInteger:2],
     [NSNumber numberWithUnsignedInteger:2],
     nil];
    [self addChild:menu];
    
    
    // Back.
    [CCMenuItemFont setFontSize:[[GorillasConfig get].largeFontSize intValue]];
    CCMenuItem *back     = [CCMenuItemFont itemFromString:@"   <   "
                                               target:self
                                             selector:@selector(back:)];
    [CCMenuItemFont setFontSize:[[GorillasConfig get].fontSize intValue]];
    
    CCMenu *backMenu = [CCMenu menuWithItems:back, nil];
    [backMenu setPosition:ccp([[GorillasConfig get].fontSize intValue], [[GorillasConfig get].fontSize intValue])];
    [backMenu alignItemsHorizontally];
    [self addChild:backMenu];
    
    return self;
}


-(void) reset {
    
    NSUInteger theme = 0;
    NSArray *cityThemes = [[CityTheme getThemes] allKeys];
    if ([cityThemes containsObject:[GorillasConfig get].cityTheme])
        theme = [cityThemes indexOfObject:[GorillasConfig get].cityTheme];
    [themeI setSelectedIndex:theme];
    gravityI.label = [CCLabelTTF labelWithString:[NSString stringWithFormat:@"%d", [[GorillasConfig get].gravity unsignedIntValue]]
                                   fontName:[GorillasConfig get].fontName fontSize:[[GorillasConfig get].fontSize intValue]];
    [levelI setSelectedIndex:[[GorillasConfig get].levelNames indexOfObject:[GorillasConfig get].levelName]];
    [replayI setSelectedIndex:[[GorillasConfig get].replay boolValue]? 1: 0];
    [followI setSelectedIndex:[[GorillasConfig get].followThrow boolValue]? 1: 0];

    themeI.isEnabled = ![[GorillasAppDelegate get].gameLayer checkGameStillOn];
}


-(void) onEnter {
    
    [self reset];
    
    [super onEnter];
}


-(void) level: (id) sender {
    
    [[GorillasAudioController get] clickEffect];

    NSUInteger curLevelInd = [[GorillasConfig get].levelNames indexOfObject:[GorillasConfig get].levelName];
    float newLevel = (float)((curLevelInd + 1) % [[GorillasConfig get].levelNames count]) / [[GorillasConfig get].levelNames count];
    [GorillasConfig get].level = [NSNumber numberWithFloat:fminf(0.9f, fmaxf(0.1f, newLevel))];
}


-(void) gravity: (id) sender {
    
    [[GorillasAudioController get] clickEffect];
    NSUInteger minGravity = [[GorillasConfig get].minGravity unsignedIntValue];
    NSUInteger maxGravity = [[GorillasConfig get].maxGravity unsignedIntValue];
    NSUInteger newGravity = [[GorillasConfig get].gravity unsignedIntValue] + 10;
    if (newGravity > maxGravity || newGravity < minGravity)
        newGravity = minGravity;

    [GorillasConfig get].gravity = [NSNumber numberWithUnsignedInt:newGravity];
}


-(void) cityTheme: (id) sender {

    [[GorillasAudioController get] clickEffect];

    NSArray *themes = [[CityTheme getThemes] allKeys];
    NSString *newTheme = [themes objectAtIndex:0];
    
    BOOL found = NO;
    for(NSString *theme in themes) {
        if(found) {
            newTheme = theme;
            break;
        }
        
        if([[GorillasConfig get].cityTheme isEqualToString:theme])
            found = YES;
    }
    
    [[[CityTheme getThemes] objectForKey:newTheme] apply];
    [GorillasConfig get].cityTheme = newTheme;
    
    [[GorillasAppDelegate get].gameLayer reset];
}


-(void) replay: (id) sender {
    
    [[GorillasAudioController get] clickEffect];
    [GorillasConfig get].replay = [NSNumber numberWithBool:![[GorillasConfig get].replay boolValue]];
}


-(void) followThrow: (id) sender {
    
    [[GorillasAudioController get] clickEffect];
    [GorillasConfig get].followThrow = [NSNumber numberWithBool:![[GorillasConfig get].followThrow boolValue]];
}


-(void) back: (id) sender {
    
    [[GorillasAudioController get] clickEffect];
    [[GorillasAppDelegate get] popLayer];
}


-(void) dealloc {
    
    [super dealloc];
}


@end

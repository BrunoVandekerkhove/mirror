//
//  ProjectStatsPanelController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 28/10/16.
//  Copyright (c) 2016 BV. All rights reserved.
//

#import "Project.h"
#import "ProjectStatsDictionary.h"
#import "ProjectStatsPanelController.h"

#pragma mark Project Statistics Panel Controller

@implementation ProjectStatsPanelController

@synthesize project = _project;

#pragma mark Constructors

- (instancetype)init {
    
    return [super initWithNibName:self.nibName bundle:nil];
    
}

- (NSString *)nibName {
    
    return [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"Controller" withString:@""];
    
}

- (NSString *)panelIdentifier {
    
    return [self.nibName stringByAppendingString:@"Identifier"];
}

- (NSString *)panelTitle {
    
    NSString *title = [NSStringFromClass([self class]) stringByReplacingOccurrencesOfString:@"PanelController" withString:@""];
    return [title stringByReplacingOccurrencesOfString:@"ProjectStats" withString:@""];
    
}

- (NSImage *)panelIcon {
    
    return nil;
    
}

@end

#pragma mark Custom Project Stats Panel Controllers

@implementation ProjectStatsFilesPanelController

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:NSImageNameMultipleDocuments];

}

@end

@implementation ProjectStatsOverviewPanelController

@synthesize outlineView = _outlineView;

- (void)setProject:(Project *)project {
    
    [project.statistics setOutlineView:nil];
    [super setProject:project];
    [project.statistics setOutlineView:_outlineView];
    
}

- (NSImage *)panelIcon {
    
    return [NSImage imageNamed:@"Network"];

}

- (void)dealloc {
    
    self.outlineView = nil;
    
    [super dealloc];
    
}

@end
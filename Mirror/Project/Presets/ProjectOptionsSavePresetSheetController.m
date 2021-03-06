//
//  ProjectOptionsSavePresetSheetController.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 14/12/15.
//  Copyright (c) 2015 BV. All rights reserved.
//

#import "NSApp+Additions.h"
#import "PreferencesConstants.h"
#import "ProjectOptionsSavePresetSheetController.h"

#pragma mark Project Options Save Preset Sheet Controller

@interface ProjectOptionsSavePresetSheetController ()

@property (nonatomic, retain) IBOutlet NSTextField *textField, *warningLabel;
@property (nonatomic, retain) IBOutlet NSButton *cancelButton, *okButton;

@end

@implementation ProjectOptionsSavePresetSheetController

@synthesize delegate = _delegate, textField = _textField, warningLabel = _warningLabel, cancelButton = _cancelButton, okButton = _okButton;

#pragma mark Constructors

- (instancetype)init {
    
    return [super initWithWindowNibName:[self nibName] owner:self];
    
}

#pragma mark Interface

- (NSString *)nibName {
    
    return @"ProjectOptionsSavePresetSheet";
    
}

- (NSString *)presetName {
    
    return [[[_textField stringValue] copy] autorelease];
    
}
- (void)awakeFromNib {
    
    [_warningLabel setStringValue:@""]; // Reset warning label
    
}

#pragma mark Presentation

- (void)presentOnWindow:(NSWindow *)window completionHandler:(void (^)(NSModalResponse code))completionBlock {
    
    if ([[self window] isVisible]) // The panel is already visible, and is therefor removed
        return (IS_PRE_YOSEMITE ? [NSApp endSheet:[self window] returnCode:0] : block(NSModalResponseCancel));
    
    if (block != NULL) // Reset completion block
        Block_release(block);
    
    [_textField setStringValue:@""];
    
    if (IS_PRE_YOSEMITE)
        [NSApp beginSheet:[self window] modalForWindow:window didEndBlock:completionBlock];
    else {
        
        block = Block_copy(completionBlock);
        modalWindow = window;
        
        [window beginSheet:[self window] completionHandler:^(NSModalResponse returnCode) {
            block(returnCode);
        }];
        
    }
    
}

- (void)endSheetPresentation:(NSButton *)senderButton {
    
    NSModalResponse response = (senderButton == _okButton ? NSModalResponseOK : NSModalResponseCancel);
    
    if (response == NSModalResponseOK) {
        
        NSString *presetName = [self presetName];
        
        NSString *warning = nil;
        if (self.delegate)
            warning = [self.delegate projectOptionsSavePresetSheetController:self errorForPresetName:presetName];
        if (warning)
            return [_warningLabel setStringValue:warning];
        
    }
    
    if (IS_PRE_YOSEMITE)
        [NSApp endSheet:[self window] returnCode:response];
    else
        [modalWindow endSheet:[self window] returnCode:response];
    
    [_warningLabel setStringValue:@""];
    
    [[self window] orderOut:self];
    
}

#pragma mark Memory Management

- (void)dealloc {
    
    if (block != NULL)
        Block_release(block);
    
    self.warningLabel = nil;
    self.okButton = nil;
    self.warningLabel = nil;
    self.textField = nil;
    
    [super dealloc];
    
}

@end

//
//  ProjectSocketList.m
//  Mirror
//
//  Created by Bruno Vandekerkhove on 07/09/17.
//  Copyright (c) 2017 BV. All rights reserved.
//

#import "ProjectSocket.h"
#import "ProjectSocketList.h"

#pragma mark Project Socket List

@implementation ProjectSocketList

@dynamic status;

#pragma mark Constructors

- (id)init {
    
    if (self = [super init]) {
        
        self.automaticallyRearrangesObjects = true;
        self.usesLazyFetching = false;
        self.clearsFilterPredicateOnInsertion = false;
        self.content = [NSMutableArray array];
        
    }
    
    return self;
    
}

#pragma mark Properties

- (NSUInteger)size {
    
    return ((NSMutableArray *)self.content).count;
    
}

- (NSString *)status {
    
    NSInteger nbOfSockets = [self.content count];
    return (nbOfSockets == 0 ? @"No connections." : [NSString stringWithFormat:(nbOfSockets == 1 ? @"%li connection." : @"%li connections."), (long)nbOfSockets]);

}

#pragma mark Mutating

- (void)setContent:(id)content {
    
    [self willChangeValueForKey:@"status"];
    [super setContent:content];
    [self didChangeValueForKey:@"status"];
    
}

- (void)addObject:(id)object {
    
    if ([object isMemberOfClass:[ProjectSocket class]]) {
        [self willChangeValueForKey:@"status"];
        [self.content addObject:object];
        [self rearrangeObjects];
        [self didChangeValueForKey:@"status"];
    }
    
}

@end

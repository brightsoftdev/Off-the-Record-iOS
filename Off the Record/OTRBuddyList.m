//
//  OTRBuddyList.m
//  Off the Record
//
//  Created by Chris Ballinger on 12/20/11.
//  Copyright (c) 2011 Chris Ballinger. All rights reserved.
//

#import "OTRBuddyList.h"

@implementation OTRBuddyList

@synthesize xmppBuddies;
@synthesize oscarBuddies;
@synthesize activeConversations;

-(id)init
{
    if(self = [super init])
    {
        self.xmppBuddies = [[NSMutableDictionary alloc] init];
        self.oscarBuddies = [[NSMutableDictionary alloc] init];
        self.activeConversations = [[NSMutableSet alloc] init];
    }
    return self;
}

+(NSArray*)sortBuddies:(NSMutableDictionary*)buddies
{
    NSSortDescriptor *buddyNameDescriptor = [[NSSortDescriptor alloc] initWithKey:@"displayName" ascending:YES selector:@selector(localizedCaseInsensitiveCompare:)];
    
    NSSortDescriptor *statusDescriptor = [[NSSortDescriptor alloc] initWithKey:@"status"
                                                      ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:statusDescriptor, buddyNameDescriptor, nil];
    
    return [[buddies allValues] sortedArrayUsingDescriptors:sortDescriptors];
}

-(NSMutableDictionary*)allBuddies
{
    NSMutableDictionary *allBuddies = [NSMutableDictionary dictionaryWithCapacity:[self count]];
    
    if(xmppBuddies)
        [allBuddies addEntriesFromDictionary:xmppBuddies];
    if(oscarBuddies)
        [allBuddies addEntriesFromDictionary:oscarBuddies];
    
    return allBuddies;
}

-(NSUInteger)count
{
    return [xmppBuddies count] + [oscarBuddies count];
}

-(void)removeXmppBuddies
{
    [xmppBuddies removeAllObjects];
}

-(void)removeOscarBuddies
{
    [oscarBuddies removeAllObjects];
}

-(void)removeAllBuddies
{
    [xmppBuddies removeAllObjects];
    [oscarBuddies removeAllObjects];
}

-(void)addBuddy:(OTRBuddy*)newBuddy
{
    if([newBuddy.protocol isEqualToString:@"prpl-oscar"])
    {
        [oscarBuddies setObject:newBuddy forKey:newBuddy.accountName];
    }
    else if([newBuddy.protocol isEqualToString:@"xmpp"])
    {
        [xmppBuddies setObject:newBuddy forKey:newBuddy.accountName];
    }
}

-(OTRBuddy*)getBuddyByName:(NSString*)buddyName
{
    OTRBuddy *buddy = nil;
    
    buddy = [oscarBuddies objectForKey:buddyName];
    if(!buddy)
        buddy = [xmppBuddies objectForKey:buddyName];
    return buddy;
}

@end

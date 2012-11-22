//
//  KNetworkVariable.m
//  KNetworkRequest
//
//  Created by Kyle Carson on 11/21/12.
//  Copyright (c) 2012 Kyle Carson. All rights reserved.
//

#import "KNetworkVariable.h"

@implementation KNetworkVariable
@synthesize value,key;
- (id) init
{
	if (self = [super init])
	{
		key = @"";
		value = @0;
	}
	return self;
}
- (id) initWithKey: (NSString *) aKey value:(id)aValue
{
	if (self = [self init])
	{
		key = [aKey copy];
		value = [aValue copy];
	}
	return self;
}
@end

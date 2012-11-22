//
//  KNetworkVariable.h
//  KNetworkRequest
//
//  Created by Kyle Carson on 11/21/12.
//  Copyright (c) 2012 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KNetworkVariable : NSObject
{
	NSString * key;
	id value;
}
- (id) initWithKey: (NSString *) aKey value:(id)aValue;
@property (readwrite, copy) NSString * key;
@property (readwrite, copy) id value;
@end

//
//  KNetworkFileUpload.h
//  KNetworkRequest
//
//  Created by Kyle Carson on 11/21/12.
//  Copyright (c) 2012 Kyle Carson. All rights reserved.
//

#import "KNetworkVariable.h"

@interface KNetworkFileUpload : KNetworkVariable
{
	NSString * fileType;
	NSString * fileName;
}
@property (readwrite, copy) NSString * fileType;
@property (readwrite, copy) NSString * fileName;
@end

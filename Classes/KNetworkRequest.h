//
//  KNetworkRequest.h
//  KNetworkRequest
//
//  Created by Kyle Carson on 11/21/12.
//  Copyright (c) 2012 Kyle Carson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KNetworkVariable.h"

typedef void(^KNetworkBlock)(id);

enum KMethod {
	KGET_METHOD = 0,
	KPOST_METHOD
};

enum KReturnType {
	kTEXT_RETURN_TYPE = 0,
	kDATA_RETURN_TYPE,
	kJSON_RETURN_TYPE
};

@interface KNetworkRequest : NSObject
{
	NSURL * url;
	NSMutableArray * variables;
	
	enum KMethod method;
	enum KReturnType returnType;
	__unsafe_unretained KNetworkBlock callback;
	BOOL asynchronous;
}
// Public Functions
- (id) initWithURL: (NSURL *) aUrl;
- (void) addFile: (NSData *) file forKey: (NSString *) key fileType: (NSString *) fileType fileName: (NSString *)fileName;
- (void) setFile:(NSData *) file forKey: (NSString *) key fileType: (NSString *) fileType fileName: (NSString *)fileName;
- (void) addValue:(id)value forKey:(NSString *) key;
- (void) setValue:(id)value forKey:(NSString *) key;
- (void) removeKey: (NSString *) key;
- (void) setCallback: (KNetworkBlock) callback;
- (void) send;

// Private
- (NSURLRequest *) request;
- (NSString *) httpMethod;
- (NSData *) body;
- (NSString *) boundary;
- (NSURL *) modifiedURL;

@property (readwrite, copy) NSURL * url;
@property (readwrite) enum KMethod method;
@property (readwrite) enum KReturnType returnType;
@property (readwrite) KNetworkBlock callback;
@property (readwrite) BOOL asynchronous;
@end

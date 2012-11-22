//
//  KNetworkRequest.m
//  KNetworkRequest
//
//  Created by Kyle Carson on 11/21/12.
//  Copyright (c) 2012 Kyle Carson. All rights reserved.
//

#import "KNetworkRequest.h"
#import "KNetworkFileUpload.h"

@implementation KNetworkRequest
@synthesize url, method, returnType, callback, asynchronous;
- (id) init
{
	if (self = [super init])
	{
		variables = [[NSMutableArray alloc] init];
		method = KGET_METHOD;
	}
	
	return self;
}
- (id) initWithURL: (NSURL *) aUrl
{
	if (self = [self init])
	{
		url = [aUrl copy];
		asynchronous = YES;
	}
	
	return self;
}
- (void) setValue:(id)value forKey:(NSString *)key
{
	[self removeKey:key];
	[self addValue:value forKey:key];
}
- (void) setFile:(NSData *) file forKey: (NSString *) key fileType: (NSString *) fileType fileName: (NSString *)fileName
{
	[self removeKey:key];
	
	[self addFile:file forKey:key fileType:fileType fileName:fileName];
}
- (void) addFile: (NSData *) file forKey: (NSString *) key fileType: (NSString *) fileType fileName: (NSString *)fileName
{
	KNetworkFileUpload * variable = [[KNetworkFileUpload alloc] initWithKey:key value:file];
	variable.fileType = fileType;
	variable.fileName = fileName;
	
	[variables addObject:variable];
}
- (void) addValue:(id)value forKey:(NSString *) key
{
	KNetworkVariable * variable = [[KNetworkVariable alloc] initWithKey:key value:value];
	[variables addObject:variable];
}
- (void) removeKey: (NSString *) key
{
	for (KNetworkVariable * variable in [variables copy])
	{
		if ([variable.key isEqualToString:key])
		{
			[variables removeObject:variable];
		}
	}
}
- (void) setValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
	for (NSString * key in keyedValues)
	{
		id value = keyedValues[key];
		
		[self setValue:value forKey:key];
	}
}
- (NSURL *) modifiedURL
{
	if (method != KGET_METHOD) return url;
	
	NSMutableString * urlString = [NSMutableString stringWithString:[url absoluteString]];
	
	if (url.query.length > 0)
	{
		[urlString appendString:@"&"];
	} else {
		[urlString appendString:@"?"];
	}
	
	BOOL ampersand = NO;
	
	for (KNetworkVariable * variable in variables)
	{
		if (ampersand) [urlString appendString:@"&"];
		
		[urlString appendFormat:@"%@=%@", variable.key, variable.value];
		ampersand = YES;
	}
	
	NSURL * newURL = [NSURL URLWithString:[urlString stringByAddingPercentEscapesUsingEncoding: NSASCIIStringEncoding]];
	
	NSLog(@"%@", newURL);

	return newURL;
}
- (NSString *) boundary
{
	return @"---------------------------14737809831466499882746641449";
}
- (NSData *) dataForValue: (id) value
{
	if ([value isKindOfClass:[NSData class]]) return value;
	
	if (! [value respondsToSelector:@selector(dataUsingEncoding)])
	{
		if ([value respondsToSelector:@selector(stringValue)])
		{
			value = [value stringValue];
		} else {
			value = [value description];
		}
	}
	value = [value dataUsingEncoding:NSUTF8StringEncoding];
	
	return value;
}
- (NSData *) body
{
	NSMutableData *body = [NSMutableData data];
	
	if (method == KGET_METHOD) return body;
	
	for (KNetworkVariable * variable in variables)
	{
		
		[body appendData:[[NSString stringWithFormat:@"--%@\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
		if ([variable isKindOfClass:[KNetworkFileUpload class]])
		{
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", variable.key, ((KNetworkFileUpload *) variable).fileName] dataUsingEncoding:NSUTF8StringEncoding]];
			[body appendData:[[NSString stringWithFormat:@"Content-Type: %@\r\n\r\n", ((KNetworkFileUpload *) variable).fileType] dataUsingEncoding:NSUTF8StringEncoding]];
		} else {
			[body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"%@\"\r\n\r\n", variable.key] dataUsingEncoding:NSUTF8StringEncoding]];
		}
		
		id value = [self dataForValue:variable.value];
		
		[body appendData:value];
		[body appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
	}
	
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", self.boundary] dataUsingEncoding:NSUTF8StringEncoding]];
	
	return body;
}
- (NSString *) httpMethod
{
	if (method == KGET_METHOD) return @"GET";
	if (method == KPOST_METHOD) return @"POST";
	
	return @"GET";
}
- (NSURLRequest *) request
{
	NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
	[request setURL: self.modifiedURL];
    [request setHTTPMethod: self.httpMethod];
	[request setHTTPBody: self.body];
	
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", self.boundary];
    [request addValue:contentType forHTTPHeaderField:@"Content-Type"];
	
	return request;
}
- (id) formatResponse: (NSData *) data
{
	if (returnType == kDATA_RETURN_TYPE) return data;
	if (returnType == kTEXT_RETURN_TYPE)
	{
		return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
	}
	if (returnType == kJSON_RETURN_TYPE)
	{
		return [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableLeaves error:nil];
	}
	
	return data;
}
- (void) send
{
	if (asynchronous)
	{
		NSURLResponse * response;
		NSData * data = [NSURLConnection sendSynchronousRequest:self.request returningResponse:&response error:nil];
	
		callback([self formatResponse:data]);
	} else {
		NSOperationQueue * queue = [NSOperationQueue currentQueue];
		
		[NSURLConnection sendAsynchronousRequest:self.request queue:queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * err) {
			callback([self formatResponse: data]);
		}];
	}
	
	

}
@end

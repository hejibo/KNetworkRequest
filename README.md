KNetworkRequest
===============

Objective C Framework for easy GET/POST/File Uploads

Usage
====
request.method = kGET_METHOD —OR— kPOST_METHOD

request.returnType = kTEXT_RETURN_TYPE —OR— kDATA_RETURN_TYPE — OR — kJSON_RETURN_TYPE

request.callback = callback.  Runs callback(id result)

[request setValue:@“Search” forKey:@“q”] // “url.com?q=Search”

[request setFile: (NSData *) file forKey:@“file”]

request.asynchronous = YES
	
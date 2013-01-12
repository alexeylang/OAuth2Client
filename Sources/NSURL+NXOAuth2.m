//
//  NSURL+NXOAuth2.m
//  OAuth2Client
//
//  Created by Ullrich Schäfer on 07.10.09.
//
//  Copyright 2010 nxtbgthng. All rights reserved.
//
//  Licenced under the new BSD-licence.
//  See README.md in this repository for
//  the full licence.
//

#import "NSString+NXOAuth2.h"

#import "NSURL+NXOAuth2.h"


@implementation NSURL (NXOAuth2)

- (NSURL *)nxoauth2_URLByAddingParameters:(NSDictionary *)parameterDictionary {
    if (!parameterDictionary || [parameterDictionary count] == 0) {
        return self;
    }

    NSString *newParameterString = [NSString nxoauth2_stringWithEncodedQueryParameters:parameterDictionary];
    
    NSString *absoluteString = [self absoluteString];
    if ([absoluteString rangeOfString:@"?"].location == NSNotFound) {    // append parameters?
        absoluteString = [NSString stringWithFormat:@"%@?%@", absoluteString, newParameterString];
    } else {
        absoluteString = [NSString stringWithFormat:@"%@&%@", absoluteString, newParameterString];
    }

    return [NSURL URLWithString:absoluteString];
}

- (NSString *)nxoauth2_valueForQueryParameterKey:(NSString *)key;
{
    NSString *result = nil;
    NSString *queryString = [self query];
    NSDictionary *parameters = [queryString nxoauth2_parametersFromEncodedQueryString];
    result = [parameters objectForKey:key];

    if ( !result )
    {
        NSString *hashString = [self fragment];
        NSDictionary *hashParameters = [hashString nxoauth2_parametersFromEncodedQueryString];
        result = [hashParameters objectForKey:key];
    }
    return result;
}

- (NSURL *)nxoauth2_URLWithoutQueryString;
{
    return [NSURL URLWithString:[self nxoauth2_URLStringWithoutQueryString]];
}

- (NSString *)nxoauth2_URLStringWithoutQueryString;
{
    NSArray *parts = [[self absoluteString] componentsSeparatedByString:@"?"];
    parts = [[parts objectAtIndex:0] componentsSeparatedByString:@"#"];
    return [parts objectAtIndex:0];
}

@end

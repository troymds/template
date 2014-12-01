//
//  aboutModel.m
//  XinNet
//
//  Created by YY on 14-11-26.
//  Copyright (c) 2014年 tianj. All rights reserved.
//

#import "aboutModel.h"

@implementation aboutModel
@synthesize company_about,company_address,company_email,company_logo,company_website,company_weixin,name,company_tel;



- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeObject:self.company_about forKey:@"company_about"];
    [aCoder encodeObject:self.company_address forKey:@"company_address"];
    [aCoder encodeObject:self.company_email forKey:@"company_email"];
    [aCoder encodeObject:self.company_logo forKey:@"company_logo"];
    [aCoder encodeObject:self.company_website forKey:@"company_website"];
    [aCoder encodeObject:self.company_weixin forKey:@"company_weixin"];
    [aCoder encodeObject:self.company_tel forKey:@"company_tel"];
}


- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.name = [aDecoder decodeObjectForKey:@"name"];
    self.company_about = [aDecoder decodeObjectForKey:@"company_about"];
    self.company_address = [aDecoder decodeObjectForKey:@"company_address"];
    self.company_email = [aDecoder decodeObjectForKey:@"company_email"];
    self.company_logo = [aDecoder decodeObjectForKey:@"company_logo"];
    self.company_website = [aDecoder decodeObjectForKey:@"company_website"];
    self.company_weixin = [aDecoder decodeObjectForKey:@"company_weixin"];
    self.company_tel = [aDecoder decodeObjectForKey:@"company_tel"];

    return self;
}

@end

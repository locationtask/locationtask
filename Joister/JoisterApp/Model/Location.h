//
//  Location.h
//  JoisterApp
//
//  Created by Narendra.b on 04/11/15.
//  Copyright (c) 2015 Narendra.b. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Location : NSObject
@property (nonatomic,strong) NSString *availablity_Id;
@property (nonatomic,strong) NSString *availablity_type;
@property (nonatomic,strong) NSString *address_one;
@property (nonatomic,strong) NSString *address_two;
@property (nonatomic,strong) NSString *landmark;
@property (nonatomic,strong) NSString *country;
@property (nonatomic,strong) NSString *states;
@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *pincode;
@property (nonatomic,strong) NSString *latitude;
@property (nonatomic,strong) NSString *longitude;
@property (nonatomic,strong) NSString *node_id;
@property (nonatomic,strong) NSString *product_id;
@property (nonatomic,strong) NSString *updated;

-(void)initWith:(NSArray *)locArray;
@end

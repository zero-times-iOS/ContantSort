//
//  Person.m
//  联系人排序
//
//  Created by 叶长生 on 2018/12/20.
//  Copyright © 2018 Hoa. All rights reserved.
//

#import "Person.h"

@implementation Person

- (NSString *)description {
    return [[NSString alloc] initWithFormat:@"name: %@, sort: %@",_name, _sort];
}



@end

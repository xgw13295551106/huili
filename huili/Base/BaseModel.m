//
//  BaseModel.m
//  EduParent
//
//  Created by Carl on 17/8/24.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import "BaseModel.h"

@implementation BaseModel

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    if (self = [super init]) {
        Class c = self.class; // 截取类和父类的成员变量
        while (c && c != [NSObject class]) {
            unsigned int count = 0;
            Ivar *ivars = class_copyIvarList(c, &count);
            for (int i = 0; i < count; i++) {
                NSString *key = [NSString stringWithUTF8String:ivar_getName(ivars[i])];
                id value = [aDecoder decodeObjectForKey:key];
                if (!value && [key isKindOfClass:[NSString class]]) {
                    value = @"";
                }
                [self setValue:value forKey:key];
            }
            // 获得c的父类
            c = [c superclass];
            free(ivars);
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    Class c = self.class; // 截取类和父类的成员变量
    while (c && c != [NSObject class]) {
        unsigned int count = 0;
        Ivar *ivars = class_copyIvarList(c, &count);
        for (int i = 0; i < count; i++) {
            Ivar ivar = ivars[i];
            NSString *key = [NSString stringWithUTF8String:ivar_getName(ivar)];
            id value = [self valueForKey:key];
            [aCoder encodeObject:value forKey:key];
        }
        c = [c superclass]; // 释放内存
        free(ivars);
    }
}

@end

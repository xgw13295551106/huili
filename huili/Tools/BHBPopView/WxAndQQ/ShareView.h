//
//  ShareView.h
//  EduParent
//
//  Created by Carl on 2017/9/26.
//  Copyright © 2017年 yangH4. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ShareView : NSObject

+(ShareView *) ShareViewClient;

-(void)shareClick:(NSString*)url setTitle:(NSString*)title setContent:(NSString*)content setIcon:(NSString*)icon;

@end

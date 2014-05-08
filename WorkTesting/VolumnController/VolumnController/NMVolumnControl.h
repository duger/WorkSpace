//
//  NMVolumnControl.h
//  VolumnController
//
//  Created by Duger on 14-4-28.
//  Copyright (c) 2014年 Duger. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

@interface NMVolumnControl : NSObject<AVAudioSessionDelegate>
+(NMVolumnControl *)shareManager;

@end

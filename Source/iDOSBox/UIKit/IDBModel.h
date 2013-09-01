//
//  IDBModel.h
//  iDOSBox
//
//  Created by user on 9/1/13.
//  Copyright (c) 2013 user. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface IDBModel : NSObject

@property (readwrite, nonatomic) BOOL paused;

- (void)sendText:(NSString *)text;
- (void)sendCommand:(NSString *)command;

@end

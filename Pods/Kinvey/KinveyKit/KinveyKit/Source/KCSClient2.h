//
//  KCSClient2.h
//  KinveyKit
//
//  Copyright (c) 2015 Kinvey. All rights reserved.
//
// This software is licensed to you under the Kinvey terms of service located at
// http://www.kinvey.com/terms-of-use. By downloading, accessing and/or using this
// software, you hereby accept such terms of service  (and any agreement referenced
// therein) and agree that you have read, understand and agree to be bound by such
// terms of service and are of legal age to agree to such terms with Kinvey.
//
// This software contains valuable confidential and proprietary information of
// KINVEY, INC and is subject to applicable licensing agreements.
// Unauthorized reproduction, transmission or distribution of this file and its
// contents is a violation of applicable laws.
//

#ifndef KinveyKit_KCSClient2_h
#define KinveyKit_KCSClient2_h

@import Foundation;

@class KCSClientConfiguration;

KCS_DEPRECATED(Please use KCSClient instead, 1.41.0)
@interface KCSClient2 : NSObject

+ (instancetype) sharedClient;

@property (nonatomic, strong) KCSClientConfiguration* configuration;

@end

#endif

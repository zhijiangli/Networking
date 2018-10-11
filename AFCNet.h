//
//  AFCNet.h
//  TextProject
//
//  Created by 小黎 on 2017/12/7.
//  Copyright © 2017年 小黎. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AFNetworking.h"
@interface AFCNetFaliedModel : NSObject
@property(nonatomic,assign)  NSInteger code;
@property(nonatomic,copy)    NSString * message;
@property(nonatomic,copy)    NSError  * error;
@end
/**
 将JSON数据中的 null 转为@""
 */
@interface NSDictionary (NSNull)
+(NSDictionary *)nullDic:(NSDictionary *)myDic;
+(NSArray *)nullArr:(NSArray *)myArr;
@end
/** 请求成功block
 */
typedef void (^AFCSuccessBlock)(NSDictionary * OCJSON);
/** 请求失败block
 */
typedef void (^AFCFaliedBlock)(AFCNetFaliedModel * faliedModel);
/** 视频上传进度
 */
typedef void(^ UploadProgress)(CGFloat Progress);
@interface AFCNet : NSObject
/** GET请求*/
+(void)GET:(NSString *)urlStr Param:(NSDictionary *)param Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied;
/** POST请求*/
+(void)POST:(NSString *)urlStr Param:(NSDictionary *)param Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied;
/** POST上传单张图片*/
+(void)POST:(NSString *) urlStr Param:(NSDictionary *)param image:(UIImage *) image Success:(AFCSuccessBlock)
succes  Falied:(AFCFaliedBlock) falied;
/** POST提交视频*/
+(void)POST:(NSString *) urlStr Param:(NSDictionary *)param videoData:(NSData *) data UploadProgress:(UploadProgress ) progress Success:(AFCSuccessBlock) succes  Falied:(AFCFaliedBlock) falied;
@end



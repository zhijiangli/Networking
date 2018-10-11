//
//  AFCNet.m
//  TextProject
//
//  Created by 小黎 on 2017/12/7.
//  Copyright © 2017年 小黎. All rights reserved.
//

#import "AFCNet.h"
static AFHTTPSessionManager * manager;
#define BaseUrlStr @""
@implementation AFCNet
+ (void)getAFCNetManager{
    if(manager==nil){
        manager=[AFHTTPSessionManager manager];
        manager.requestSerializer = [AFHTTPRequestSerializer serializer];
        manager.requestSerializer.timeoutInterval = 20;
        //manager.requestSerializer setValue:@"" forHTTPHeaderField:@""
        manager.responseSerializer = [AFHTTPResponseSerializer serializer];
        manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json", @"text/html",@"text/json",@"text/javascript",@"image/jpeg", nil];
        //AFSecurityPolicy *security = [AFSecurityPolicy policyWithPinningMode:AFSSLPinningModeNone];
        //[security setValidatesDomainName:NO];
        //security.allowInvalidCertificates = YES;
        //manager.securityPolicy = security;
    }
}
/** GET请求*/
+(void)GET:(NSString *)urlStr Param:(NSDictionary *)param Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied{
    [self getAFCNetManager];
    NSString * url = [BaseUrlStr stringByAppendingString:urlStr];
    [manager GET:url parameters:param progress:^(NSProgress * _Nonnull downloadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       [self handleResponseData:responseObject Success:success Falied:falied];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleRequestFaliedError:error Falied:falied];
    }];
    
}
/** POST请求*/
+(void)POST:(NSString *)urlStr Param:(NSDictionary *)param Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied{
    [self getAFCNetManager];
    NSString * url = [BaseUrlStr stringByAppendingString:urlStr];
    [manager POST:url parameters:param progress:^(NSProgress * _Nonnull uploadProgress) {
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponseData:responseObject Success:success Falied:falied];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleRequestFaliedError:error Falied:falied];
    }];
}
/** POST上传单张图片*/
+(void)POST:(NSString *) urlStr Param:(NSDictionary *)param image:(UIImage *) image Success:(AFCSuccessBlock)
success Falied:(AFCFaliedBlock) falied{
    [self getAFCNetManager];
     NSString * url = [BaseUrlStr stringByAppendingString:urlStr];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        // 1、对图片压缩
        NSData * imageData = UIImageJPEGRepresentation(image, 0.5);
        // 2、上传的参数名 以当前时间为参数名  保证所有参数名不一样
        NSDate *currentDate = [NSDate date];//获取当前时间，日期
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"YYYY-MM-dd-HH:mm:ss:SS"];
        NSString * Name = [dateFormatter stringFromDate:currentDate];
        // 3、上传filename
        NSString * fileName = [NSString stringWithFormat:@"%@.png", Name];
        [formData appendPartWithFileData:imageData name:@"file" fileName:fileName mimeType:@"image/png"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
     } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        [self handleResponseData:responseObject Success:success Falied:falied];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        [self handleRequestFaliedError:error Falied:falied];
    }];
}
/** POST提交视频*/
+(void)POST:(NSString *) urlStr Param:(NSDictionary *)param videoData:(NSData *) data UploadProgress:(UploadProgress ) progress Success:(AFCSuccessBlock) success  Falied:(AFCFaliedBlock) falied{
    [self getAFCNetManager];
    NSString * url = [BaseUrlStr stringByAppendingString:urlStr];
    [manager POST:url parameters:param constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        [formData appendPartWithFileData:data name:@"file" fileName:@"video1.mov" mimeType:@"video/quicktime"];
    } progress:^(NSProgress * _Nonnull uploadProgress) {
        progress(uploadProgress.completedUnitCount / uploadProgress.totalUnitCount*1.00);
    } success:^(NSURLSessionDataTask * _Nonnull task, id _Nullable responseObject) {
        [self handleResponseData:responseObject Success:success Falied:falied];
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
         [self handleRequestFaliedError:error Falied:falied];
    }];
}

#pragma mark -
+(void)handleResponseData:(NSData *)data Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied{
    NSError *error;
    NSDictionary * OCJSON = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers  error:&error];
    if (error != nil){
        AFCNetFaliedModel * faliedModel = [AFCNetFaliedModel new];
        faliedModel.code = 0;
        faliedModel.message = @"数据解析出错";
        falied(faliedModel);
    }else{
        [self handleRequestSuccessData:OCJSON Success:success Falied:falied];
    }
}
/** 处理请求成功数据 每个项目返回数据结构不一样，是协商而定*/
+(void)handleRequestSuccessData:(NSDictionary *)ocJson Success:(AFCSuccessBlock)success Falied:(AFCFaliedBlock)falied{
    success(ocJson);
}
/** 处理请求失败数据*/
+(void)handleRequestFaliedError:(NSError *)error Falied:(AFCFaliedBlock)falied{
    AFCNetFaliedModel * faliedModel = [AFCNetFaliedModel new];
    faliedModel.code = 0;
    faliedModel.message = @"数据解析出错";
    falied(faliedModel);
}
@end
@implementation AFCNetFaliedModel
@end
@implementation NSDictionary (NSNull)
//将NSDictionary中的Null类型的项目转化成@""
+(NSDictionary *)nullDic:(NSDictionary *)myDic
{
    NSArray *keyArr = [myDic allKeys];
    NSMutableDictionary *resDic = [[NSMutableDictionary alloc]init];
    for (int i = 0; i < keyArr.count; i ++)
    {
        id obj = [myDic objectForKey:keyArr[i]];
        
        obj = [self changeType:obj];
        
        [resDic setObject:obj forKey:keyArr[i]];
    }
    return resDic;
}

//将NSDictionary中的Null类型的项目转化成@""
+(NSArray *)nullArr:(NSArray *)myArr
{
    NSMutableArray *resArr = [[NSMutableArray alloc] init];
    for (int i = 0; i < myArr.count; i ++)
    {
        id obj = myArr[i];
        
        obj = [self changeType:obj];
        
        [resArr addObject:obj];
    }
    return resArr;
}

//将NSString类型的原路返回
+(NSString *)stringToString:(NSString *)string
{
    return string;
}

//将Null类型的项目转化成@""
+(NSString *)nullToString
{
    return @"";
}

#pragma mark - 公有方法
//类型识别:将所有的NSNull类型转化成@""
+(id)changeType:(id)myObj
{
    if ([myObj isKindOfClass:[NSDictionary class]])
    {
        return [self nullDic:myObj];
    }
    else if([myObj isKindOfClass:[NSArray class]])
    {
        return [self nullArr:myObj];
    }
    else if([myObj isKindOfClass:[NSString class]])
    {
        return [self stringToString:myObj];
    }
    else if([myObj isKindOfClass:[NSNull class]])
    {
        return [self nullToString];
    }
    else
    {
        return myObj;
    }
}
@end



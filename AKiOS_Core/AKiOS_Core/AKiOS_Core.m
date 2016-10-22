//
//  AKiOS_Core.m
//
//  AKiOS Universal Unity Plugin for iOS, https://github.com/alex-kir/AKiOS
//
//  Created by Alexander Kirienko on 01.07.13.
//  Copyright (c) 2013-2015 Alexander Kirienko. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

#import "AKiOS_Core.h"

#import <Foundation/Foundation.h>
#import <objc/runtime.h>

typedef int    gboolean;
typedef void * gpointer;

static void * _returnedBytes = 0;

void * AKiOS_Core_CreateClass(const char * szClassName, const char * szSuperClassName)
{
    NSString * sSuperClassName = [[NSString alloc] initWithCString:szSuperClassName encoding:NSUTF8StringEncoding];
//    NSString * sClassName = [[NSString alloc] initWithCString:szClassName encoding:NSUTF8StringEncoding];
    
    Class aSuperClass = NSClassFromString(sSuperClassName);
    Class aClass = objc_allocateClassPair(aSuperClass, szClassName/*[sClassName UTF8String]*/, 0);
    
    return (__bridge void*)aClass;
}

void AKiOS_Core_AddProtocol(void * pClass, const char * szProtocolName)
{
    Class aClass = (__bridge Class)pClass;
    NSString * sProtocolName = [[NSString alloc] initWithCString:szProtocolName encoding:NSUTF8StringEncoding];
    Protocol * protocol = NSProtocolFromString(sProtocolName);
    class_addProtocol(aClass, protocol);
}

void AKiOS_Core_RegisterClass(void * pClass)
{
    Class aClass = (__bridge Class)pClass;
    objc_registerClassPair(aClass);
}

void * AKiOS_Core_GetClass(const char * szClassName)
{
    NSString * sClassName = [[NSString alloc] initWithCString:szClassName encoding:NSUTF8StringEncoding];
    return (__bridge void*)NSClassFromString(sClassName);
}

BOOL AKiOS_Core_HasMethod(void * pInstance, const char * szMethodName)
{
    id anInstance = (__bridge id)pInstance;
    
    NSString * sMethodName = [[NSString alloc] initWithCString:szMethodName encoding:NSUTF8StringEncoding];
    SEL aSelector = NSSelectorFromString(sMethodName);
    if (!aSelector)
    {
        NSLog(@"AKiOS_Core_CallMethod(): aSelector is NULL, %s", szMethodName);
        return NO;
    }
    
    return [anInstance respondsToSelector:aSelector];
}

void * AKiOS_Core_CallMethod(void * pInstance, const char * szMethodName, void ** ppArgs, int argsCount, void ** ppReturnedBytes)
{
    //NSLog(@"AKiOS_Core_CallMethod(%p, %s, %d)", pInstance, szMethodName, argsCount);
    
    NSString * sMethodName = [[NSString alloc] initWithCString:szMethodName encoding:NSUTF8StringEncoding];
    SEL aSelector = NSSelectorFromString(sMethodName);
    if (!aSelector)
    {
        NSLog(@"AKiOS_Core_CallMethod(): aSelector is NULL, %s", szMethodName);
        return 0;
    }
    
    id anInstance = (__bridge id)pInstance;
    if (!anInstance)
    {
        NSLog(@"AKiOS_Core_CallMethod(): anInstance is NULL, %s", szMethodName);
        return 0;
    }
    
    NSMethodSignature * aSignature = [anInstance methodSignatureForSelector:aSelector];
    if (!aSignature)
    {
        NSLog(@"AKiOS_Core_CallMethod(): aSignature is NULL, %s", szMethodName);
        return 0;
    }
    
    NSInvocation * invocation = [NSInvocation invocationWithMethodSignature:aSignature];
    invocation.target = anInstance;
    invocation.selector = aSelector;
    if (argsCount != aSignature.numberOfArguments - 2)
    {
        NSLog(@"(warning) AKiOS_Core_CallMethod(): argsCount(%d) != aSignature.numberOfArguments(%d)", argsCount, (int)aSignature.numberOfArguments - 2);
    }
        
    for (int i = 0; i < argsCount; i++)
    {
        [invocation setArgument:ppArgs[i] atIndex:2 + i];
    }

    [invocation invoke];


    
    NSString * returnType = [NSString stringWithUTF8String:[aSignature methodReturnType]];
//    NSLog(@"AKiOS_Core_CallMethod(): [aSignature methodReturnType] = %@", returnType);
//    NSLog(@"AKiOS_Core_CallMethod(): [aSignature methodReturnLength] = %d", [aSignature methodReturnLength]);
    // v = ? // void
    // @ = 4 // id
    // c = 1 // bool
    // f = 4 // float
    // d = 8 // double
    // {CGRect={CGPoint=ff}{CGSize=ff}} = 16 // CGRect
    
    if ([returnType isEqualToString:@"v"])
    {
        *ppReturnedBytes = 0;
        return 0;
    }
    else if ([returnType isEqualToString:@"@"])
    {
        void * result = 0;
        [invocation getReturnValue:&result];
        *ppReturnedBytes = 0;
        return result;
    }
    else
    {
        NSInteger len = aSignature.methodReturnLength;
        if (_returnedBytes)
            free(_returnedBytes);
        _returnedBytes = malloc(len);
        [invocation getReturnValue:_returnedBytes];
        *ppReturnedBytes = _returnedBytes;
        return (void *)len;
    }
}










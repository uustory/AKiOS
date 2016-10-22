//
//  AKiOS_Core.h
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
#if defined __cplusplus
extern "C" {
#endif
    
    void * AKiOS_Core_CreateClass(const char * szClassName, const char * szSuperClassName);
    void AKiOS_Core_AddProtocol(void * pClass, const char * szProtocolName);
    void AKiOS_Core_AddMethod(void * pClass, const char * szMethodName, const char * szTypes);
    void AKiOS_Core_RegisterClass(void * pClass);

    void * AKiOS_Core_GetClass(const char * szClassName);
    
    BOOL AKiOS_Core_HasMethod(void * pInstance, const char * szMethodName);
    void * AKiOS_Core_CallMethod(void * pInstance, const char * szMethodName, void ** ppArgs, int argsCount, void ** ppReturnedBytes);
    
#if defined __cplusplus
};
#endif

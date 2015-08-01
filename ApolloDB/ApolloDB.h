//
//ApolloDB
//
//The MIT License (MIT)
//
//Copyright (c) 2015 Juan Carlos Chomali
//
//Permission is hereby granted, free of charge, to any person obtaining a copy
//of this software and associated documentation files (the "Software"), to deal
//in the Software without restriction, including without limitation the rights
//to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//copies of the Software, and to permit persons to whom the Software is
//furnished to do so, subject to the following conditions:
//
//The above copyright notice and this permission notice shall be included in
//all copies or substantial portions of the Software.
//
//THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//THE SOFTWARE.
//

#import <Foundation/Foundation.h>

@interface ApolloDB : NSObject


//-----------------
// Shared instance
//-----------------
+ (id)sharedManager;


//-----------------
// Start a session with the specified passcode for encrypting and decrypting the DB, returns YES if the passcode is valid.
//-----------------
-(BOOL)startSessionWithPasscode:(NSString *)pass;


//-----------------
// Set the object for the specified key
//-----------------
-(void)setObject:(id)object forKey:(NSString *)key;


//-----------------
// Set the objects for the specified keys
//-----------------
-(void)setObjects:(NSArray *)objects forKeys:(NSArray *)keys;


//-----------------
// Removes the object for the specified key
//-----------------
-(void)removeObjectForKey:(NSString *)key;


//-----------------
// Removes the objects for the specified keys
//-----------------
-(void)removeObjectsForKeys:(NSArray *)keys;


//-----------------
// Returns an object for the specified key
//-----------------
-(id)objectForKey:(NSString *)key;


//-----------------
// Returns an array containing the objects for the specified keys
//-----------------
-(NSArray *)objectsForKeys:(NSArray *)keys;


//-----------------
// Get all the data from the DB
//-----------------
-(NSDictionary *)allData;


@end
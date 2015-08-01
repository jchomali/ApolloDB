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

#import "ApolloDB.h"
#import <CommonCrypto/CommonCryptor.h>

#pragma mark - Encryption Methods
@interface NSData (AES256)
- (NSData *)AES256EncryptWithKey:(NSString *)key;
- (NSData *)AES256DecryptWithKey:(NSString *)key;
@end

@implementation NSData (AES256)

- (NSData *)AES256EncryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesEncrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCEncrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesEncrypted);
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesEncrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

- (NSData *)AES256DecryptWithKey:(NSString *)key {
    // 'key' should be 32 bytes for AES256, will be null-padded otherwise
    char keyPtr[kCCKeySizeAES256+1]; // room for terminator (unused)
    bzero(keyPtr, sizeof(keyPtr)); // fill with zeroes (for padding)
    
    // fetch key data
    [key getCString:keyPtr maxLength:sizeof(keyPtr) encoding:NSUTF8StringEncoding];
    
    NSUInteger dataLength = [self length];
    
    //See the doc: For block ciphers, the output size will always be less than or
    //equal to the input size plus the size of one block.
    //That's why we need to add the size of one block here
    size_t bufferSize = dataLength + kCCBlockSizeAES128;
    void *buffer = malloc(bufferSize);
    
    size_t numBytesDecrypted = 0;
    CCCryptorStatus cryptStatus = CCCrypt(kCCDecrypt, kCCAlgorithmAES128, kCCOptionPKCS7Padding,
                                          keyPtr, kCCKeySizeAES256,
                                          NULL /* initialization vector (optional) */,
                                          [self bytes], dataLength, /* input */
                                          buffer, bufferSize, /* output */
                                          &numBytesDecrypted);
    
    if (cryptStatus == kCCSuccess) {
        //the returned NSData takes ownership of the buffer and will free it on deallocation
        return [NSData dataWithBytesNoCopy:buffer length:numBytesDecrypted];
    }
    
    free(buffer); //free the buffer;
    return nil;
}

@end

@interface ApolloDB ()

@property (strong, nonatomic) NSMutableDictionary *dbData;
@property (strong, nonatomic) NSString *passcode;

@end

@implementation ApolloDB

@synthesize dbData, passcode;

+ (id)sharedManager {
    static ApolloDB *sharedManager = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedManager = [[self alloc] init];
    });
    return sharedManager;
}

- (id)init {
    if (self = [super init]) {
        
        dbData = [[NSMutableDictionary alloc]init];
        passcode = [[NSString alloc]init];
        
    }
    return self;
}

-(BOOL)startSessionWithPasscode:(NSString *)pass{
    
    passcode=pass;
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbfilePath = [documentsPath stringByAppendingPathComponent:@"data.apdb"];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:dbfilePath];
    
    //Generate the DB file if it doesnt exists
    if (fileExists==NO) {
        NSData *data = [[NSJSONSerialization dataWithJSONObject:[NSDictionary dictionaryWithObject:@"blank" forKey:@"apdbStatus"] options:kNilOptions error:nil] AES256EncryptWithKey:pass];
        [data writeToFile:dbfilePath atomically:YES];
    }
    
    NSData *decryptedData = [[NSData dataWithContentsOfFile:dbfilePath] AES256DecryptWithKey:pass];
    
    NSError *error = nil;
    dbData = [[NSMutableDictionary alloc]initWithDictionary:[NSJSONSerialization JSONObjectWithData:decryptedData options:NSJSONReadingAllowFragments error:&error]];
    if (error) {
        NSLog(@"Error: %@", error);
    }
    
    //If data is nil return NO because passcode is wrong
    if (dbData==nil) {
        dbData = [[NSMutableDictionary alloc]init];
        return NO;
    }
    
    return YES;
}
-(void)saveData{
    //Remove apdbStatus from data if db changed
    if (dbData.allKeys.count>1) {
        [dbData removeObjectForKey:@"apdbStatus"];
    }
    else if (dbData.allKeys.count==0){
        [dbData setObject:@"blank" forKey:@"apdbStatus"];
    }
    
    //Get db path
    NSString* documentsPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *dbfilePath = [documentsPath stringByAppendingPathComponent:@"data.apdb"];
    
    //Save db file
    NSData *data = [[NSJSONSerialization dataWithJSONObject:dbData options:kNilOptions error:nil] AES256EncryptWithKey:passcode];
    [data writeToFile:dbfilePath atomically:YES];
}
#pragma mark - DB Objects Methods
-(void)setObject:(id)object forKey:(NSString *)key{
    [dbData setObject:object forKey:key];
    [self saveData];
}
-(void)setObjects:(NSArray *)objects forKeys:(NSArray *)keys{
    for (int objectIndex = 0; objectIndex<objects.count; objectIndex++){
        [dbData setObject:[objects objectAtIndex:objectIndex] forKey:[keys objectAtIndex:objectIndex]];
    }
    [self saveData];
}
-(void)removeObjectForKey:(NSString *)key{
    [dbData removeObjectForKey:key];
    [self saveData];
}
-(void)removeObjectsForKeys:(NSArray *)keys{
    [dbData removeObjectsForKeys:keys];
    [self saveData];
}
-(id)objectForKey:(NSString *)key{
    return [dbData objectForKey:key];
}
-(NSDictionary *)allData{
    return dbData;
}
-(NSArray *)objectsForKeys:(NSArray *)keys{
    return [dbData objectsForKeys:keys notFoundMarker:nil];
}

@end
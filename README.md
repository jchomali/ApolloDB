![ApolloDB](https://github.com/jchomali/ApolloDB/blob/master/banner.png)

An easy to implement and secure database for your apps.

## Why using ApolloDB?
I basically love how easy is to save data in NSUserDefaults but how insecure and illogic to save it in a place designed for the user preferences. So I built ApolloDB, an easy to implement and secure database. 

## Usage
It's simple, first of all add the framework ```JavaScriptCore.framework```to start a session, you must use the following code anywhere but before saving or getting an object from the DB.
```Objective-C
BOOL passcodeIsValid = [[ApolloDB sharedManager]startSessionWithPasscode:@"yourDBPasscode"]; //Set a passcode for encrypting and decrypting your DB
if (passcodeIsValid==false){
//The given passcode is different from the DB passcode
}
```
Before starting the session, you can use any of the following methods for setting or getting an object from the DB. Remember thet for saving custom classes as objects you must configure before the ```encodeWithCoder``` and ```initWithCoder``` methods
```Objective-C
[[ApolloDB sharedManager]setObject:@"foo" forKey:@"bar"]; //Set an object for a key
[[ApolloDB sharedManager]setObjects:@[@"foo", @"testing"] forKeys:@[@"bar", @"status"]]; //Set objects for the specified keys
[[ApolloDB sharedManager]removeObjectForKey:@"bar"]; //Remove the object corresponding to the specified key
[[ApolloDB sharedManager]removeObjectForKey:@[@"bar", @"status"]]; //Remove the objects corresponding to the specified keys
[[ApolloDB sharedManager]objectForKey:@"bar"]; //Get the object corresponding to the specified key
[[ApolloDB sharedManager]objectsForKeys:@[@"bar", @"status"]]; //Get the objects corresponding to the specified keys
NSDictionary *myData = [[ApolloDB sharedManager]allData]; //Get all the DB data
```
## License
The MIT License (MIT)

Copyright (c) 2015 Juan Carlos Chomali

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
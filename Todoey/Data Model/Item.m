//
//  Item.m
//  Todoey
//
//  Created by REVE Systems on 7/9/23.
//

#import "Item.h"

@implementation Item

+ (BOOL)supportsSecureCoding {
    return YES;
}

- (void)encodeWithCoder:(NSCoder *)coder {
    [coder encodeObject:self.title forKey:@"title"];
    [coder encodeBool:self.done forKey:@"done"];
}

- (instancetype)initWithCoder:(NSCoder *)coder {
    self = [super init];
    if (self) {
        self.title = [coder decodeObjectForKey:@"title"];
        self.done = [coder decodeBoolForKey:@"done"];
    }
    return self;
}

- (instancetype)initWithTitle:(NSString *)title done:(BOOL)done {
    self = [super init];
    if (self) {
        _title = title;
        _done = done;
    }
    return self;
}

@end

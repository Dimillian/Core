//
// iDOSBox
// Copyright (C) 2013  Matthew Vilim
//
// This program is free software: you can redistribute it and/or modify
// it under the terms of the GNU General Public License as published by
// the Free Software Foundation, either version 3 of the License, or
// (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import "IDBQueue.h"
#import "IDBLinkedList.h"
#import "IDBDebug.h"

@interface IDBQueue ()

@property (readwrite, nonatomic) IDBLinkedList *linkedList;

@end

@implementation IDBQueue

#pragma mark Initializers
+ (id)queue {
    return [[IDBQueue alloc] init];
}

// designated initializer
- (id)init {
    if (self = [super init]) {
        _linkedList = [IDBLinkedList linkedList];
    }
    return self;
}

#pragma mark Methods
- (void)enqueue:(id)anObject {
    NSAssert(anObject, FIArgumentNilError);

    [self.linkedList appendObject:anObject];
    return;
}

- (id) dequeue {
    if (self.count != 0) {
        id firstObject = [self.linkedList headObject];
        [self.linkedList removeHead];
        return firstObject;
    } else {
        return nil;
    }
}

- (id) peek {
    if (self.count != 0) {
        return [self.linkedList headObject];
    } else {
        return nil;
    }
}

- (void)removeAllObjects {
    [self.linkedList removeAllObjects];
    return;
}

- (BOOL)containsObject:(id)anObject {
    return [self.linkedList containsObject:anObject];
}

#pragma mark Accessors
- (NSUInteger)count {
    return [self.linkedList count];
}

#pragma mark NSFastEnumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    return [self.linkedList countByEnumeratingWithState:state objects:buffer count:len];
}

@end
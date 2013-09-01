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

#import "IDBLinkedList.h"
#import "IDBDebug.h"

@interface IDBLinkedListNode ()

@property (readwrite, nonatomic) id anObject;

@end

@implementation IDBLinkedListNode

#pragma mark Initializers
// designated initializer
- (id)initWithObject:(id)anObject {
    if (self = [super init]) {
        NSAssert(anObject, FIArgumentNilError);
        _anObject = anObject;
        _nextNode = nil;
        _previousNode = nil;
    }
    return self;
}

-(id) init {
    return [self initWithObject:nil];
}

@end

@interface IDBLinkedList ()

@property (readwrite, nonatomic) IDBLinkedListNode *head;
@property (readwrite, nonatomic) IDBLinkedListNode *tail;
@property (readwrite, nonatomic) NSUInteger count;

@end

@implementation IDBLinkedList

#pragma mark Initializers
+ (id)linkedList {
    return [[self alloc] init];
}

// designated initializer
- (id)init {
    if (self = [super init]) {
        _head = nil;
        _tail = nil;
        _count = 0;
    }
    return self;
}

#pragma mark Methods
- (void)appendObject:(id)anObject {
    NSAssert(anObject, FIArgumentNilError);

    IDBLinkedListNode *node = [[IDBLinkedListNode alloc] initWithObject:anObject];
    node.previousNode = self.tail;
    self.tail.nextNode = node;
    self.tail = node;
    self.count++;
    return;
}

- (void)prependObject:(id)anObject {
    NSAssert(anObject, FIArgumentNilError);

    IDBLinkedListNode *node = [[IDBLinkedListNode alloc] initWithObject:anObject];
    node.nextNode = self.head;
    self.head.previousNode = node;
    self.head = node;
    self.count++;
    return;
}

- (void)removeObject:(id)anObject {
    for (IDBLinkedListNode *node = self.head; node; node = node.nextNode) {
        if (anObject == node) {
            node.previousNode.nextNode = node.nextNode;
            node.nextNode.previousNode = node.previousNode;
            self.count--;
            return;
        }
    }
}

- (BOOL)containsObject:(id)anObject {
    for (IDBLinkedListNode *node = self.head; node; node = node.nextNode) {
        if (anObject == node) {
            return YES;
        }
    }
    return NO;
}

- (id)headObject {
    return self.head.anObject;
}

- (id)tailObject {
    return self.tail.anObject;
}

- (void)removeHead {
    self.head = self.head.nextNode;
    self.head.previousNode = nil;
    return;
}

- (void)removeTail {
    self.tail = self.tail.previousNode;
    self.tail.nextNode = nil;
    return;
}

- (void)removeAllObjects {
    NSMutableArray *nodesToRemove = [NSMutableArray array];
    for (IDBLinkedListNode *node = self.head; node; node = node.nextNode) {
        [nodesToRemove addObject:node];
    }

    for (IDBLinkedListNode *node in nodesToRemove) {
        node.previousNode = nil;
        node.nextNode = nil;
    }

    return;
}

#pragma mark Accessors
- (void)setHead:(IDBLinkedListNode *)head {
    _head = head;
    if (!self.tail) {
        self.tail = head;
    }
    return;
}

- (void)setTail:(IDBLinkedListNode *)tail {
    _tail = tail;
    if (!self.head) {
        self.head = tail;
    }
    return;
}

#pragma mark NSFastEnumeration
- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len {
    if (state->state == 0) {
        state->state = 1;
        state->mutationsPtr = (unsigned long *)&_count;
        state->extra[0] = (unsigned long)_head;
    }

    IDBLinkedListNode *currentNode = (__bridge IDBLinkedListNode *)((void *)state->extra[0]);

    NSUInteger i;
    for (i = 0; i < len && currentNode; i++) {
        buffer[i] = currentNode.anObject;
        currentNode = currentNode.nextNode;
    }

    state->extra[0] = (unsigned long)currentNode;
    state->itemsPtr = buffer;

    return i;
}

@end

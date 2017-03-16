//
//  SCGPushCoreDataManager.m
//  SCGPushSDK
//
//  Created by Angel Terziev on 3/15/17.
//  Copyright © 2017 Syniverse. All rights reserved.
//

#import "SCGPushCoreDataManager.h"

#import <CoreData/CoreData.h>

static NSString* const _modelName = @"PushInbox";
static NSString* const _dbName = @"PushInbox.sqlite";

@interface SCGPushCoreDataManager ()

@property (nonatomic, strong, readonly) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong, readonly) NSRecursiveLock* contextGuard;
@property (nonatomic, strong, readonly) NSMutableDictionary<NSString*, NSManagedObjectID*>* messagesIndex;
@property (nonatomic, strong, readonly) NSMutableArray<NSManagedObjectID *>* messages;
@end

@implementation SCGPushCoreDataManager

+ (instancetype) sharedInstance
{
    static SCGPushCoreDataManager* _sharedInstance;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[SCGPushCoreDataManager alloc] init];
    });
    
    return _sharedInstance;
}

- (id) init {

    if (nil != (self = [super init])) {
        _contextGuard = [[NSRecursiveLock alloc] init];

        _messagesIndex = [[NSMutableDictionary alloc] init];
        _messages = [[NSMutableArray alloc] init];
        
        [self setUpCoreDataStack];
    }
    
    return  self;
}


//MARK: - Setup Core Data

-(void)setUpCoreDataStack
{
    [self.contextGuard lock];
    
    do {
        
        NSBundle* sdkBundle = [NSBundle bundleWithIdentifier:@"com.syniverse.scg.push.sdk"];
        if (nil == sdkBundle) {
            NSLog(@"Error failed to load sdk bundle");
            break;
        }
        
        NSString* modelPath = [sdkBundle pathForResource:_modelName ofType:@"momd"];
        if (nil == modelPath) {
            NSLog(@"Error failed to find model in bundle");
            break;
        }
        
        NSURL* modelUrl = [NSURL fileURLWithPath: modelPath];
        if (nil == modelUrl) {
            NSLog(@"Error failed to find url with path speficified");
            break;
        }
        
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc]initWithContentsOfURL: modelUrl];
        if ( nil == model) {
            NSLog(@"Error initializing model");
            break;
        }
        
        NSPersistentStoreCoordinator *psc = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
        if ( nil == psc) {
            NSLog(@"Error creating PersistentStoreCoordinator");
            break;
        }
        
        NSURL *url = [[[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject] URLByAppendingPathComponent:_dbName];
        
        NSDictionary *options = @{NSPersistentStoreFileProtectionKey: NSFileProtectionNone,
                                  NSMigratePersistentStoresAutomaticallyOption:@(YES),
                                  NSInferMappingModelAutomaticallyOption:@(YES)};
        NSError *error = nil;
        NSPersistentStore *store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&error];
        if (!store)
        {
            NSLog(@"Error adding persistent store. Error (%ld) %s",
                     (error != nil) ? (long)error.code : 0,
                     (error != nil && error.localizedDescription != nil) ? error.localizedDescription.UTF8String : "unknown");
            
            NSError *deleteError = nil;
            if (NO == [[NSFileManager defaultManager] removeItemAtURL:url error:&deleteError])
            {
                // Also inform the user...
                NSLog(@"Failed to delete persistent store. Error (%ld) %s",
                         (deleteError != nil) ? (long)deleteError.code : 0,
                         (deleteError != nil && deleteError.localizedDescription != nil) ? deleteError.localizedDescription.UTF8String : "unknown");
                break;
            }
            
            NSError *createError = nil;
            store = [psc addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:url options:options error:&createError];
            if (!store)
            {
                // Also inform the user...
                NSLog(@"Failed to create persistent store. Error (%ld) %s",
                         (createError != nil) ? (long)createError.code : 0,
                         (createError != nil && createError.localizedDescription != nil) ? createError.localizedDescription.UTF8String : "unknown");
                break;
            }
        }
        
        _managedObjectContext = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSPrivateQueueConcurrencyType];
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error creating NSManagedObjectContext");
            break;
        }
        
        self.managedObjectContext.persistentStoreCoordinator = psc;
        
        NSLog(@"Successfully set up CoreData stack at url: %@", url);
        
        [self buildMessagesIndex];
        
    } while (false);

    [self.contextGuard unlock];
}


//MARK: - Private

// This method is not for calling it has been called autmatically inside setupCoredataStack
- (void) buildMessagesIndex {
    
    [self.contextGuard lock];

    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        [self.managedObjectContext performBlockAndWait:^{

            NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Message"];
            
            // sort them by date descending ( most recent first )
            NSSortDescriptor* sortDecriptor = [NSSortDescriptor sortDescriptorWithKey:@"created" ascending:NO];
            request.sortDescriptors = @[sortDecriptor];
            
            NSError* error;
            NSArray *allMessages = [self.managedObjectContext executeFetchRequest:request error:&error];
            
            if (!error) {
                for (NSManagedObject* managed in allMessages) {
                    NSString* messageId = [managed valueForKey:@"identifier"];
                    [self addMessageId:messageId withObjectId:managed.objectID];
                }
                
                NSLog(@"Debug: There are %ld messages into Inbox", (long) self.messages.count);
            } else {
                NSLog(@"Error: failed to build messages index");
            }
        }];
        
    } while (false);
    
    
    [self.contextGuard unlock];
}

// This method must be called ninside lock/unlock
- (void) addMessageId: (NSString          *) identifier
         withObjectId: (NSManagedObjectID *) objectID
{
    [self.messagesIndex setObject:objectID forKey:identifier];
    [self.messages addObject: objectID];
}

// This method must be called ninside lock/unlock
- (BOOL) isMessageWithIdExist: (NSString*) messageId
{
    id value = [self.messagesIndex objectForKey:messageId];
    
    return (nil != value);
}

// This method must be called ninside lock/unlock
- (void) deleteMessageId: ( NSString* ) messageId
{
    NSManagedObjectID* objectId = [self.messagesIndex objectForKey:messageId];
    if (nil != objectId)
        [self.messages removeObject: objectId];
    
    [self.messagesIndex removeObjectForKey: messageId];
}

// This method must be called ninside lock/unlock
- (void) deleteAll
{
    [self.messages removeAllObjects];
    [self.messagesIndex removeAllObjects];
}

//MARK: - Interface
- (NSUInteger) numberOfMessages
{
    NSUInteger count = 0;
    
    [self.contextGuard lock];
    count = self.messagesIndex.count;
    [self.contextGuard unlock];

    return count;
}

- (SCGPushMessage* _Nullable) messageAtIndex:(NSUInteger) index
{
    SCGPushMessage* message;
    
    [self.contextGuard lock];
    // TODO: Fetch message by message id
    [self.contextGuard unlock];
    
    return message;
}

- (BOOL) addNewMessage: (SCGPushMessage* _Nonnull) message
{
    __block BOOL fOk = NO;
    
    [self.contextGuard lock];
    
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        if ([self isMessageWithIdExist: message.identifier]) {
            NSLog(@"Warning: message with the specified id already exist: %@",
                  message.identifier);
            break;
        }

        NSManagedObject* managed =
        [NSEntityDescription insertNewObjectForEntityForName: @"Message"
                                      inManagedObjectContext: self.managedObjectContext];
        
        [managed setValue:message.identifier forKey:@"identifier"];
        [managed setValue:message.created forKey:@"created"];
        [managed setValue:message.body forKey:@"body"];
        
        if (message.deepLink)
            [managed setValue:message.deepLink forKey:@"deepLink"];
        
        if (message.showNotification)
            [managed setValue:@(message.showNotification) forKey:@"showNotification"];
        
        if (message.attachmentId)
            [managed setValue:message.attachmentId forKey:@"attachmentId"];
        
        [self.managedObjectContext performBlockAndWait:^{
            
            NSError* saveError = nil;
            fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to save message '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                [self addMessageId: message.identifier withObjectId: managed.objectID];
                NSLog(@"Success: saved new message '%@'",
                      message.identifier);
            }
        }];

    } while (false);

    [self.contextGuard unlock];
    
    return fOk;
}

- (BOOL) deleteMessage: (SCGPushMessage* _Nonnull) message
{
    __block BOOL fOk = NO;
    
    [self.contextGuard lock];
    
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
 
        if (![self isMessageWithIdExist: message.identifier]) {
            NSLog(@"Error: Object with specified id does not exist: %@",
                  message.identifier);
            break;
        }

        [self.managedObjectContext performBlockAndWait:^{
            NSManagedObjectID* objectId = [self.messagesIndex objectForKey: message.identifier];
            NSManagedObject* managed = [self.managedObjectContext objectWithID: objectId];
            [self.managedObjectContext deleteObject: managed];
            
            NSError* saveError = nil;
            fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to delete message '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                [self deleteMessageId: message.identifier];
            }
        }];
        
    } while (false);
    
    [self.contextGuard unlock];
    
    return fOk;
}

- (BOOL) deleteMessageAtIndex: (NSUInteger) index
{
    __block BOOL fOk = NO;

    [self.contextGuard lock];
    
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        if (index >= self.messages.count) {
            NSLog(@"Error: Index '%ld' exceeds number of messages '%ld'",
                  (long)index,
                  (long)self.messages.count);
            break;
        }

        NSString* messageId = (NSString*) [self.messages objectAtIndex: index];
        if (![self isMessageWithIdExist: messageId]) {
            NSLog(@"Error: Object with specified id does not exist: %@",
                  messageId);
            break;
        }
        
        [self.managedObjectContext performBlockAndWait:^{
            NSManagedObjectID* objectId = [self.messagesIndex objectForKey: messageId];
            NSManagedObject* managed = [self.managedObjectContext objectWithID: objectId];
            [self.managedObjectContext deleteObject: managed];
            
            NSError* saveError = nil;
            fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to delete message '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                [self deleteMessageId: messageId];
            }
        }];
        
    } while (false);
    
    [self.contextGuard unlock];

    return fOk;
}

- (BOOL) deleteAllMessages
{
    __block BOOL fOk = NO;
    
    [self.contextGuard lock];
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        if (self.messages.count == 0) {
            NSLog(@"Error: No messages to delete");
            break;
        }
        
        [self.managedObjectContext performBlockAndWait:^{

            for (NSManagedObject* managed in self.messages) {
                [self.managedObjectContext deleteObject:managed];
            }
            
            NSError* saveError = nil;
            fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to delete message '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                [self deleteAll];
            }
        }];
        
    } while (false);
    
    [self.contextGuard unlock];
    
    return fOk;
}

/* Future API
- (SCGPushAttachment* _Nullable) attachmentWithMessage: (SCGPushMessage* _Nonnull) message
{
    SCGPushAttachment* attachment;
    
    [self.contextGuard lock];
    // TODO: Fetch attachment by message here
    [self.contextGuard unlock];
    
    return attachment;
}
*/

@end

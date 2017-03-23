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
    NSManagedObjectID* managedId = (NSManagedObjectID*) [self.messagesIndex objectForKey:messageId];
    
    return (nil != managedId);
}

// This method must be called ninside lock/unlock
- (BOOL) isAttachmentWithIdExist: (NSString*) attachmentId
{
    NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Attachment"];
    request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", attachmentId];
    
    NSError* error;
    NSArray *fetchedAttachments = [self.managedObjectContext executeFetchRequest:request error:&error];
    
    if (error != nil)
        return NO;
    
    return (fetchedAttachments.count > 0);
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

// This method must be called ninside lock/unlock
- (SCGPushAttachment* _Nullable) loadAttachmentWithId: (NSString*) attachmentId
{
    __block SCGPushAttachment* attachment;
    
    if (nil == self.managedObjectContext ) {
        return attachment;
    }

    [self.managedObjectContext performBlockAndWait:^{
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Attachment"];
        request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", attachmentId];
        
        NSError* error;
        NSArray *fetchedAttachments = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (!error) {
            if (fetchedAttachments.count) {
                NSManagedObject* managed = fetchedAttachments[0];
                NSString* identifier = (NSString*) [managed valueForKey:@"identifier"];
                attachment = [[SCGPushAttachment alloc] initWithIdentifier: identifier];
                attachment.state = (SCGPushAttachmentDownloadState)[[managed valueForKey:@"state"] integerValue];
                attachment.retryCount = [[managed valueForKey:@"retryCount"] integerValue];
                
                if (attachment.state == SCGPushAttachmentDownloadSucceeded) {
                    NSString* contentType = (NSString*) [managed valueForKey:@"contentType"];
                    if (contentType.length)
                        attachment.contentType = contentType;
                    
                    NSData* data = (NSData*) [managed valueForKey:@"data"];
                    if (data)
                        attachment.data = data;
                }
            }
        } else {
            NSLog(@"Error: failed to fetch attachment");
        }
        
    }];
    
    return attachment;
}

//MARK: - Interface
- (NSUInteger) numberOfMessages
{
    NSUInteger count = 0;
    
    [self.contextGuard lock];
    count = self.messages.count;
    [self.contextGuard unlock];

    return count;
}

- (SCGPushMessage* _Nullable) messageAtIndex:(NSUInteger) index
{
    SCGPushMessage* message;
    
    [self.contextGuard lock];
    if (index < self.messages.count) {
        NSManagedObjectID* objectId = self.messages[index];
        NSManagedObject* managed = [self.managedObjectContext objectWithID: objectId];
        if (managed) {
            NSString* msgId = [managed valueForKey: @"identifier"];
            NSDate* created = [managed valueForKey: @"created"];
            NSString* body = [managed valueForKey: @"body"];
            
            message = [[SCGPushMessage alloc] initWithId:msgId dateCreated:created andBody:body];
            
            if (nil != [managed valueForKey: @"attachmentId"]) {
                message.attachmentId = [managed valueForKey: @"attachmentId"];
            }
            
            if (nil != [managed valueForKey: @"deepLink"]) {
                message.deepLink = [managed valueForKey: @"deepLink"];
            }
            if (nil != [managed valueForKey: @"showNotification"]) {
                message.showNotification = [[managed valueForKey: @"showNotification"] boolValue];
            }
        }
    }
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
        
        [self.managedObjectContext performBlockAndWait:^{
            NSManagedObjectID* objectId = self.messages[index];
            NSManagedObject* managed = [self.managedObjectContext objectWithID: objectId];
            
            if (nil != managed) {
                NSString* messageId = (NSString*) [managed valueForKey:@"identifier"];
                [self.managedObjectContext deleteObject: managed];
                
                NSError* saveError = nil;
                fOk = [self.managedObjectContext save: &saveError];
                
                if (!fOk) {
                    NSLog(@"Error: failed to delete message '%@'",
                          saveError ? saveError.localizedDescription : @"Unspecified error");
                } else {
                    [self deleteMessageId: messageId];
                }
            } else {
                NSLog(@"Error: object with id does not exists in db.");
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

- (SCGPushAttachment* _Nullable) loadAttachmentForMessage: (SCGPushMessage* _Nonnull) message
{
    SCGPushAttachment* attachment;

    if( message.attachmentId.length ) {
        [self.contextGuard lock];
        attachment = [self loadAttachmentWithId: message.attachmentId];
        [self.contextGuard unlock];
    }
    
    return attachment;
}

- (BOOL) updateAttachment: (SCGPushAttachment* _Nonnull) attachment
{
    __block BOOL fOk = NO;
    
    [self.contextGuard lock];
    
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Attachment"];
        request.predicate = [NSPredicate predicateWithFormat:@"identifier == %@", attachment.identifier];
        
        NSError* error;
        NSArray *fetched = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (error != nil || fetched.count == 0) {
            NSLog(@"Error: cannot load attachment with id: %@",
                  attachment.identifier);
            break;
        }
        
        NSManagedObject* managed = fetched[0];
        
        [managed setValue:@(attachment.state) forKey:@"state"];
        [managed setValue:@(attachment.retryCount) forKey:@"retryCount"];
        if (attachment.contentType.length)
            [managed setValue: attachment.contentType forKey:@"contentType"];
        if (attachment.data)
            [managed setValue:attachment.data forKey:@"data"];
        
        [self.managedObjectContext performBlockAndWait:^{
            
            NSError* saveError = nil;
            BOOL fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to update attachment '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                NSLog(@"Success: updated attachment '%@'",
                      attachment.identifier);
            }
        }];
        
    } while (false);
    
    [self.contextGuard unlock];
 
    return fOk;
}

- (SCGPushAttachment* _Nullable) createAttachmentWithId: (NSString*) attachmentId
{
    SCGPushAttachment* attachment;
    [self.contextGuard lock];
    
    do {
        
        if ( nil == self.managedObjectContext) {
            NSLog(@"Error: context not initialzed");
            break;
        }
        
        if ([self isAttachmentWithIdExist: attachmentId]) {
            NSLog(@"Warning: attachment with the specified id already exist: %@",
                  attachmentId);
            break;
        }

        NSFetchRequest* request = [NSFetchRequest fetchRequestWithEntityName: @"Message"];
        request.predicate = [NSPredicate predicateWithFormat:@"attachmentId == %@", attachmentId];
        
        NSError* error;
        NSArray *fetchedMessages = [self.managedObjectContext executeFetchRequest:request error:&error];
        
        if (error != nil || fetchedMessages.count == 0) {
            NSLog(@"Error: cannot save attachment because message with this attachmentId is missing: %@",
                  attachmentId);
            break;
        }
        
        NSManagedObject* message = fetchedMessages[0];
        NSManagedObject* managed =
        [NSEntityDescription insertNewObjectForEntityForName: @"Attachment"
                                      inManagedObjectContext: self.managedObjectContext];
        
        [managed setValue:attachmentId forKey:@"identifier"];
        [managed setValue:@(SCGPushAttachmentDownloadNotStarted) forKey:@"state"];
        [managed setValue:message forKey:@"attachment_message"];
        
        [self.managedObjectContext performBlockAndWait:^{
            
            NSError* saveError = nil;
            BOOL fOk = [self.managedObjectContext save: &saveError];
            
            if (!fOk) {
                NSLog(@"Error: failed to save attachment '%@'",
                      saveError ? saveError.localizedDescription : @"Unspecified error");
            } else {
                NSLog(@"Success: saved new attachment '%@'",
                      attachmentId);
            }
        }];
        
    } while (false);
    
    [self.contextGuard unlock];
    
    return attachment;
}

@end

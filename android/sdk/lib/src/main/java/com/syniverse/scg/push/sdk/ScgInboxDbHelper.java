package com.syniverse.scg.push.sdk;

import android.content.ContentValues;
import android.content.Context;
import android.database.Cursor;
import android.database.sqlite.SQLiteDatabase;
import android.database.sqlite.SQLiteOpenHelper;
import android.os.Bundle;
import android.util.Log;

import java.util.ArrayList;
import java.util.List;

/**
 * Created by yordan on 3/14/17.
 */

final class ScgInboxDbHelper extends SQLiteOpenHelper {
    private static final String TAG = "ScgDb";
    private static ScgInboxDbHelper mInstance;

    /*
     * Cache the message ids in order to support indexes
     */
    private List<String> mMessageIds;

    // Database Version
    private static final int DATABASE_VERSION = 1;

    // Database Name
    private static final String DATABASE_NAME = "scgInbox";

    // Messages table name
    private static final String TABLE_MESSAGES = "messages";

    static final String MESSAGE_BODY = "body";
    static final String MESSAGE_ID = "scg_message_id";
    static final String MESSAGE_DEEP_LINK = "deep_link";
    static final String MESSAGE_APP_DATA = "app_data";
    static final String MESSAGE_ATTACHMENT_ID = "scg_attachment_id";
    static final String MESSAGE_SHOW_NOTIFICATION = "show_notification";
    static final String MESSAGE_TIME_RECEIVED = "received_time";

    static final ScgInboxDbHelper getInstance(Context context) {
        if (mInstance == null) {
            mInstance = new ScgInboxDbHelper(context);
        }

        return mInstance;
    }

    private ScgInboxDbHelper(Context context) {
        super(context, DATABASE_NAME, null, DATABASE_VERSION);
    }

    // Creating Tables
    @Override
    public void onCreate(SQLiteDatabase db) {
        String CREATE_MESSAGES_TABLE = "CREATE TABLE " + TABLE_MESSAGES + "("
                + MESSAGE_ID + " TEXT PRIMARY KEY, " + MESSAGE_BODY + " TEXT, "
                + MESSAGE_APP_DATA + " TEXT, " + MESSAGE_ATTACHMENT_ID + " TEXT, "
                + MESSAGE_DEEP_LINK + " TEXT, " + MESSAGE_SHOW_NOTIFICATION + " TEXT, "
                + MESSAGE_TIME_RECEIVED + " INTEGER"+ ")";
        db.execSQL(CREATE_MESSAGES_TABLE);
    }

    // Upgrading database
    @Override
    public void onUpgrade(SQLiteDatabase db, int oldVersion, int newVersion) {
        // Drop older table if existed
        db.execSQL("DROP TABLE IF EXISTS " + TABLE_MESSAGES);

        // Create tables again
        onCreate(db);
    }

    // Adding new contact
    public void addMessage(ScgMessage scgMessage) {
        SQLiteDatabase db = this.getWritableDatabase();

        String messageId = scgMessage.getId();
        ContentValues values = new ContentValues();
        values.put(MESSAGE_ID, messageId);
        values.put(MESSAGE_BODY, scgMessage.getBody());
        values.put(MESSAGE_APP_DATA, scgMessage.getAppData());
        values.put(MESSAGE_ATTACHMENT_ID, scgMessage.getAttachment());
        values.put(MESSAGE_DEEP_LINK, scgMessage.getDeepLink());
        values.put(MESSAGE_SHOW_NOTIFICATION, String.valueOf(scgMessage.isInbox()));
        values.put(MESSAGE_TIME_RECEIVED, scgMessage.getReceivedTimeUtc());

        // Inserting Row
        db.insertWithOnConflict(TABLE_MESSAGES, null, values, SQLiteDatabase.CONFLICT_REPLACE);
        db.close(); // Closing database connection

        if (mMessageIds != null) {
            mMessageIds.remove(messageId);
            mMessageIds.add(messageId);
        }
    }

    // Getting single message
    public ScgMessage getMessage(String id) {
        SQLiteDatabase db = this.getReadableDatabase();

        Cursor cursor = db.query(true, TABLE_MESSAGES, null, MESSAGE_ID + "=?",
                new String[] { id }, null, null, null, "1");
        if (cursor == null) {
            return null;
        }
        if (!cursor.moveToFirst()) {
            return null;
        }
        return createMessageFromCursor(cursor);
    }

    public ScgMessage getMessage(int index) {
        if (mMessageIds == null) {
            initMessageIndexes();
        }
        try {
            String id = mMessageIds.get(index);

            return getMessage(id);
        } catch (Exception e) {
            Log.w(TAG, "getMessage: ", e);
            return null;
        }
    }

    private void initMessageIndexes() {
        mMessageIds = new ArrayList<>();

        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.query(TABLE_MESSAGES, new String[] { MESSAGE_ID }, null,
                null, null, null, MESSAGE_TIME_RECEIVED);

        if (cursor.moveToFirst()) {
            do {
                mMessageIds.add(cursor.getString(0));
            } while (cursor.moveToNext());
        }
        cursor.close();
    }

    // Getting All messages
    public List<ScgMessage> getAllMessages() {
        List<ScgMessage> messages = new ArrayList<ScgMessage>();
        // Select All Query
        String selectQuery = "SELECT * FROM " + TABLE_MESSAGES + " ORDER BY " + MESSAGE_TIME_RECEIVED;

        SQLiteDatabase db = this.getWritableDatabase();
        Cursor cursor = db.rawQuery(selectQuery, null);

        if (cursor.moveToFirst()) {
            do {
                messages.add(createMessageFromCursor(cursor));
            } while (cursor.moveToNext());
        }
        cursor.close();

        return messages;
    }

    private ScgMessage createMessageFromCursor(Cursor cursor) {
        Bundle bundle = new Bundle();
        bundle.putString(ScgMessage.MESSAGE_ID, cursor.getString(0));
        bundle.putString(ScgMessage.MESSAGE_BODY, cursor.getString(1));
        bundle.putString(ScgMessage.MESSAGE_APP_DATA, cursor.getString(2));
        bundle.putString(ScgMessage.MESSAGE_ATTACHMENT_ID, cursor.getString(3));
        bundle.putString(ScgMessage.MESSAGE_DEEP_LINK, cursor.getString(4));
        bundle.putString(ScgMessage.MESSAGE_SHOW_NOTIFICATION, cursor.getString(5));
        bundle.putLong(ScgMessage.MESSAGE_TIME_RECEIVED, cursor.getLong(6));
        return ScgMessage.from(bundle);
    }

    // Getting messages Count
    public int getMessagesCount() {
        String countQuery = "SELECT * FROM " + TABLE_MESSAGES;
        SQLiteDatabase db = this.getReadableDatabase();
        Cursor cursor = db.rawQuery(countQuery, null);

        int count = cursor.getCount();
        cursor.close();
        return count;
    }

//    // Updating single message
//    public int updateMessage(ScgMessage message) {
//
//    }

    // Deleting single message
    public void deleteMessage(ScgMessage message) {
        deleteMessage(message.getId());
    }

    public void deleteMessage(String messageId) {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_MESSAGES, MESSAGE_ID + " = ?", new String[] { messageId });
        db.close();

        if (mMessageIds != null) {
            mMessageIds.remove(messageId);
        }
    }

    public void deleteMessage(int index) {
        if (mMessageIds == null) {
            initMessageIndexes();
        }
        try {
            String id = mMessageIds.get(index);

            deleteMessage(id);
        } catch (Exception e) {
            Log.w(TAG, "deleteMessage: ", e);
        }
    }

    public void deleteAllMessages() {
        SQLiteDatabase db = this.getWritableDatabase();
        db.delete(TABLE_MESSAGES, null, null);
        db.close();

        if (mMessageIds != null) {
            mMessageIds.clear();
        }
    }
}

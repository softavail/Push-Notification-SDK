package com.syniverse.scg.push.sdk;

import android.os.Bundle;
import androidx.test.platform.app.InstrumentationRegistry;

import org.junit.After;
import org.junit.Before;
import org.junit.Test;

import java.util.List;

import static junit.framework.Assert.assertEquals;
import static junit.framework.Assert.assertFalse;
import static junit.framework.Assert.assertNull;

/**
 * Created by yordan on 3/15/17.
 */

public class ScgInboxDbHelperUnitTest {

    private ScgInboxDbHelper mScgInboxDbHelper;

    @Before
    public void setUp(){
        if (mScgInboxDbHelper == null) {
            mScgInboxDbHelper = ScgInboxDbHelper.getInstance(InstrumentationRegistry.getTargetContext());
//            mScgInboxDbHelper.onUpgrade(mScgInboxDbHelper.getWritableDatabase(), 1, 2);
        }
    }

    @After
    public void finish() {
        if (mScgInboxDbHelper != null) {
            mScgInboxDbHelper.deleteAllMessages();
        }
    }

    @Test
    public void test1_addMessage() throws Exception {

        int message2Create = 2;
        createMessages(message2Create, 0);

        assertEquals(message2Create, mScgInboxDbHelper.getMessagesCount());

        List<ScgMessage> messages = mScgInboxDbHelper.getAllMessages();
        assertEquals(messages.size(), message2Create);

        ScgMessage message = mScgInboxDbHelper.getMessage("0");
        assertEquals(message.getBody(), "Body 0");
        assertNull(message.getAttachment());
        assertFalse(message.isInbox());
        assertEquals(message.getReceivedTimeUtc(), 1000);

        mScgInboxDbHelper.deleteMessage(message);
        message = mScgInboxDbHelper.getMessage("0");
        assertNull(message);

        mScgInboxDbHelper.deleteAllMessages();
        assertEquals(0, mScgInboxDbHelper.getMessagesCount());
    }

    private void createMessages(int number, int start) {
        for (int i = start; i < number + start; i++) {
            Bundle bundle = new Bundle();
            bundle.putString(ScgMessage.MESSAGE_ID, String.valueOf(i));
            bundle.putString(ScgMessage.MESSAGE_BODY, "Body " + i);
            bundle.putLong(ScgMessage.MESSAGE_TIME_RECEIVED, 1000 + i * 1000);
            bundle.putString(ScgMessage.MESSAGE_SHOW_NOTIFICATION, "true");
            ScgMessage message = ScgMessage.from(bundle);

            mScgInboxDbHelper.addMessage(message);
        }
    }

    @Test
    public void test2_checkIndexes() throws Exception {
        createMessages(10, 0);

        ScgMessage message = mScgInboxDbHelper.getMessage(9);
        assertEquals(message.getId(), "9");

        createMessages(1, 10);
        message = mScgInboxDbHelper.getMessage(10);
        assertEquals(message.getId(), "10");

        mScgInboxDbHelper.deleteMessage(10);
        assertEquals(10, mScgInboxDbHelper.getMessagesCount());

        assertEquals("0", mScgInboxDbHelper.getMessage(0).getId());
        assertEquals("9", mScgInboxDbHelper.getMessage(9).getId());

        assertNull(mScgInboxDbHelper.getMessage(10));
    }
}

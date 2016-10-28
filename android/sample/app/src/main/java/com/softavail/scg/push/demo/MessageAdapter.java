package com.softavail.scg.push.demo;

import android.app.PendingIntent;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.net.Uri;
import android.support.design.widget.Snackbar;
import android.support.v7.widget.RecyclerView;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.google.firebase.messaging.RemoteMessage;
import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;
import com.softavail.scg.push.sdk.ScgPushReceiver;

import java.util.ArrayList;


/**
 * Created by lekov on 7/8/16.
 */
class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> implements View.OnClickListener {

    private final ArrayList<MessageData> dataset = new ArrayList<>();
    private final Context context;

    MessageAdapter(Context context) {
        this.context = context;
    }

    @Override
    public void onClick(final View v) {

        final MessageViewHolder holder = (MessageViewHolder) v.getTag();
        final MessageData data = dataset.get(holder.getAdapterPosition());

        switch (v.getId()) {
            case R.id.messageDelivery:
                ScgClient.getInstance().deliveryConfirmation(data.id, new ScgCallback() {
                    @Override
                    public void onSuccess(int code, String message) {
                        dataset.remove(holder.getAdapterPosition());
                        notifyItemRemoved(holder.getAdapterPosition());
                        Snackbar.make(v, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
                    }

                    @Override
                    public void onFailed(int code, String message) {
                        Snackbar.make(v, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
                    }
                });
                break;
            case R.id.messageAttachment:

                new ScgClient.DownloadAttachment(context) {

                    private ProgressDialog progress;

                    @Override
                    protected void onPreExecute() {
                        progress = ProgressDialog.show(context, "Download attachment", "Downloading, please wait...", true, false);
                    }

                    @Override
                    protected void onPostExecute(Uri uri) {

                        progress.dismiss();

                        if (uri == null) {
                            return;
                        }

                        Intent attachmentIntent = new Intent(Intent.ACTION_VIEW);
                        attachmentIntent.setData(uri);
                        context.startActivity(Intent.createChooser(attachmentIntent, "Open with..."));
                    }
                }.execute(data.id, data.attachment);
                break;
        }


    }

    static class MessageData {
        final String id;
        final String body;
        final String when;
        String attachment;

        MessageData(String when, RemoteMessage message) {
            this.when = when;
            this.id = message.getData().get(ScgPushReceiver.MESSAGE_ID);
            this.body = message.getData().get(MainReceiver.MESSAGE_BODY);
            this.attachment = message.getData().get(MainReceiver.MESSAGE_ATTACHMENT_ID);
        }
    }

    void addMessage(MessageData msg) {
        dataset.add(msg);
        notifyDataSetChanged();
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_item, parent, false);

        MessageViewHolder holder = new MessageViewHolder(v);
        holder.mDelivery.setOnClickListener(this);
        holder.mDelivery.setTag(holder);

        holder.mAttachment.setOnClickListener(this);
        holder.mAttachment.setTag(holder);

        return holder;
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        final MessageData data = dataset.get(position);
        holder.mMessageId.setText(data.id);
        holder.mMessageBody.setText(data.body);
        holder.mMessageDate.setText(data.when);
        holder.mAttachment.setEnabled(data.attachment != null);
    }

    @Override
    public int getItemCount() {
        return dataset.size();
    }

    static class MessageViewHolder extends RecyclerView.ViewHolder {
        TextView mMessageId;
        TextView mMessageBody;
        TextView mMessageDate;
        Button mDelivery;
        Button mAttachment;


        MessageViewHolder(View v) {
            super(v);

            mMessageId = (TextView) v.findViewById(R.id.messageId);
            mMessageBody = (TextView) v.findViewById(R.id.messageBody);
            mMessageDate = (TextView) v.findViewById(R.id.messageDate);
            mDelivery = (Button) v.findViewById(R.id.messageDelivery);
            mAttachment = (Button) v.findViewById(R.id.messageAttachment);
        }
    }
}

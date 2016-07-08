package com.softavail.scg.push.demo;

import android.content.Context;
import android.support.design.widget.Snackbar;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Button;
import android.widget.TextView;
import android.widget.Toast;

import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;

import java.util.ArrayList;


/**
 * Created by lekov on 7/8/16.
 */
public class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> implements View.OnClickListener {

    private final Context mContext;
    private final ArrayList<MessageData> dataset = new ArrayList<>();

    @Override
    public void onClick(final View v) {
        final MessageViewHolder holder = (MessageViewHolder) v.getTag();
        if (v.getId() == holder.mDelivery.getId()) {

            ScgClient.getInstance().deliveryConfirmation(holder.mMessageId.getText().toString(), new ScgCallback() {
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
        }
    }

    public static class MessageData {
        final String id;
        final String body;
        final String when;
        private boolean delivered;

        public MessageData(String when, String id, String body) {
            this.when = when;
            this.id = id;
            this.body = body;
            delivered = false;
        }

        public boolean isDelivered() {
            return delivered;
        }

        public void delivered() {
            delivered = true;
        }
    }

    public MessageAdapter(Context context) {
        mContext = context;
    }

    public void addMessage(MessageData msg) {
        dataset.add(msg);
        notifyDataSetChanged();
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_item, parent, false);

        MessageViewHolder holder = new MessageViewHolder(v);
        holder.mDelivery.setOnClickListener(this);
        holder.mDelivery.setTag(holder);

        return holder;
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        final MessageData data = dataset.get(position);
        holder.mMessageId.setText(data.id);
        holder.mMessageBody.setText(data.body);
        holder.mMessageDate.setText(data.when);
    }

    @Override
    public int getItemCount() {
        return dataset.size();
    }

    public static class MessageViewHolder extends RecyclerView.ViewHolder {
        public TextView mMessageId;
        public TextView mMessageBody;
        public TextView mMessageDate;
        public Button mDelivery;


        public MessageViewHolder(View v) {
            super(v);

            mMessageId = (TextView) v.findViewById(R.id.messageId);
            mMessageBody = (TextView) v.findViewById(R.id.messageBody);
            mMessageDate = (TextView) v.findViewById(R.id.messageDate);
            mDelivery = (Button) v.findViewById(R.id.messageDelivery);
        }
    }
}

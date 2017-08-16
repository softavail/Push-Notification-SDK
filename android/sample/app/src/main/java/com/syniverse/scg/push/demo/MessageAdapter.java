package com.syniverse.scg.push.demo;

import android.app.AlertDialog;
import android.app.ProgressDialog;
import android.content.Context;
import android.content.Intent;
import android.databinding.DataBindingUtil;
import android.databinding.ViewDataBinding;
import android.net.Uri;
import android.support.design.widget.Snackbar;
import android.support.v7.widget.RecyclerView;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.widget.Toast;

import com.syniverse.scg.push.demo.databinding.MessageItemBinding;
import com.syniverse.scg.push.sdk.ScgCallback;
import com.syniverse.scg.push.sdk.ScgClient;
import com.syniverse.scg.push.sdk.ScgMessage;
import com.syniverse.scg.push.sdk.ScgState;

import java.util.ArrayList;
import java.util.List;


/**
 * Created by lekov on 7/8/16.
 */
class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> implements View.OnClickListener {

    private List<ScgMessage> dataset = new ArrayList<>();
    private final Context context;
    private boolean isInboxList;

    MessageAdapter(Context context) {
        this.context = context;
    }

    @Override
    public void onClick(final View v) {

        final MessageViewHolder holder = (MessageViewHolder) v.getTag();
        int position = holder.getAdapterPosition();
        if (position < 0) {
            return;
        }
        final ScgMessage data = dataset.get(position);
        final View view = holder.itemView;
        final boolean isInbox = isInboxList;
        final ScgCallback result = new ScgCallback() {
            @Override
            public void onSuccess(final int code, final String message) {

                // Redirect
                if (code > 300 && code < 400) {
                    if (view == null || view.getContext() == null || !view.isShown()) {
                        return;
                    }

                    Snackbar.make(view, "Resolved URL successful", Snackbar.LENGTH_LONG).setAction("Open", new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            Intent intent = new Intent(Intent.ACTION_VIEW, Uri.parse(message));

                            if (intent.resolveActivity(context.getPackageManager()) == null) {
                                new AlertDialog.Builder(context).setTitle(R.string.error)
                                        .setMessage(context.getString(R.string.alert_cannot_handle_url_, message))
                                        .show();
                            } else {
                                context.startActivity(intent);
                            }

                        }
                    }).show();
                } else {
                    if (!isInbox) {
                        if (dataset.remove(data)) {
                            notifyDataSetChanged();
                        }
                    }
                    String text = String.format("Success (%s): %s", code, message);
                    if (view != null && view.getContext() != null && view.isShown()) {
                        Snackbar.make(view, text, Snackbar.LENGTH_LONG).show();
                    } else {
                        Toast.makeText(context, text, Toast.LENGTH_LONG).show();
                    }
                }
            }

            @Override
            public void onFailed(int code, String message) {
                String text = String.format("Failed (%s): %s", code, message);
                if (view != null && view.getContext() != null && view.isShown()) {
                    Snackbar.make(view, text, Snackbar.LENGTH_LONG).show();
                } else {
                    Toast.makeText(context, text, Toast.LENGTH_LONG).show();
                }
            }
        };

        switch (v.getId()) {
            case R.id.messageDelivery:
                ScgClient.getInstance().confirm(data.getId(), ScgState.DELIVERED, result);
                break;
            case R.id.messageClicktrhu:
                ScgClient.getInstance().confirm(data.getId(), ScgState.CLICKTHRU, result);
                break;
            case R.id.messageRead:
                ScgClient.getInstance().confirm(data.getId(), ScgState.READ, result);
                break;
            case R.id.messageDeeplink:
                if (data.hasDeepLink()) {
                    ScgClient.getInstance().resolveTrackedLink(data.getDeepLink(), result);
                }
                break;
            case R.id.messageAttachment:
                if (!data.hasAttachment())
                    break;

                new ScgClient.DownloadAttachment(context) {

                    private AlertDialog progress;

                    @Override
                    protected void onPreExecute() {
                        progress = ProgressDialog.show(context, "Download attachment", "Downloading, please wait...", true, false);
                    }

                    @Override
                    protected void onResult(String mimeType, Uri result) {
                        progress.dismiss();

                        if (result == null) {
                            return;
                        }

                        Intent attachmentIntent = new Intent(Intent.ACTION_VIEW);
                        attachmentIntent.setDataAndType(result, mimeType);
                        context.startActivity(Intent.createChooser(attachmentIntent, "Open with..."));
                    }

                    @Override
                    protected void onFailed(int code, String error) {
                        progress.dismiss();
                        progress = new AlertDialog.Builder(context).setTitle(R.string.error).setMessage(error).show();
                    }
                }.execute(data.getId(), data.getAttachment());
                break;
            case R.id.messageDelete:
                ScgClient.getInstance().deleteInboxMessageAtIndex(holder.getAdapterPosition());
                dataset.remove(holder.getAdapterPosition());
                notifyItemRemoved(holder.getAdapterPosition());
                break;
        }


    }

    void addMessage(ScgMessage msg) {
        if (isInboxList) {
            dataset.add(msg);
        }
        notifyItemInserted(dataset.size() - 1);
    }

    void setMessgaes(List<ScgMessage> msgs, boolean isInbox) {
        isInboxList = isInbox;
        dataset = msgs;
        notifyDataSetChanged();
    }

    @Override
    public MessageViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View v = LayoutInflater.from(parent.getContext()).inflate(R.layout.message_item, parent, false);
        return new MessageViewHolder(v);
    }

    @Override
    public void onBindViewHolder(MessageViewHolder holder, int position) {
        final ScgMessage data = dataset.get(position);
        holder.getBinding().setVariable(com.syniverse.scg.push.demo.BR.message, data);
        holder.getBinding().executePendingBindings();

        holder.binding.messageAttachment.setOnClickListener(this);
        holder.binding.messageAttachment.setTag(holder);

        holder.binding.messageClicktrhu.setOnClickListener(this);
        holder.binding.messageClicktrhu.setTag(holder);

        holder.binding.messageDelivery.setOnClickListener(this);
        holder.binding.messageDelivery.setTag(holder);

        holder.binding.messageRead.setOnClickListener(this);
        holder.binding.messageRead.setTag(holder);

        holder.binding.messageDeeplink.setOnClickListener(this);
        holder.binding.messageDeeplink.setTag(holder);

        holder.binding.messageDelete.setOnClickListener(this);
        holder.binding.messageDelete.setTag(holder);
    }

    @Override
    public int getItemCount() {
        return dataset.size();
    }

    static class MessageViewHolder extends RecyclerView.ViewHolder {

        private MessageItemBinding binding;

        MessageViewHolder(View v) {
            super(v);
            binding = DataBindingUtil.bind(v);
        }

        public ViewDataBinding getBinding() {
            return binding;
        }
    }
}

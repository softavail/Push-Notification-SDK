package com.softavail.scg.push.demo;

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

import com.softavail.scg.push.demo.databinding.MessageItemBinding;
import com.softavail.scg.push.sdk.ScgCallback;
import com.softavail.scg.push.sdk.ScgClient;
import com.softavail.scg.push.sdk.ScgMessage;
import com.softavail.scg.push.sdk.ScgState;

import java.util.ArrayList;


/**
 * Created by lekov on 7/8/16.
 */
class MessageAdapter extends RecyclerView.Adapter<MessageAdapter.MessageViewHolder> implements View.OnClickListener {

    private final ArrayList<ScgMessage> dataset = new ArrayList<>();
    private final Context context;

    MessageAdapter(Context context) {
        this.context = context;
    }

    @Override
    public void onClick(final View v) {

        final MessageViewHolder holder = (MessageViewHolder) v.getTag();
        final ScgMessage data = dataset.get(holder.getAdapterPosition());
        final ScgCallback result = new ScgCallback() {
            @Override
            public void onSuccess(final int code, final String message) {

                // Redirect
                if (code > 300 && code < 400) {
                    Snackbar.make(v, "Resolved URL successful", Snackbar.LENGTH_INDEFINITE).setAction("Open", new View.OnClickListener() {
                        @Override
                        public void onClick(View view) {
                            context.startActivity(new Intent(Intent.ACTION_VIEW, Uri.parse(message)));
                        }
                    }).show();
                } else {
                    dataset.remove(holder.getAdapterPosition());
                    notifyItemRemoved(holder.getAdapterPosition());
                    Snackbar.make(v, String.format("Success (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
                }
            }

            @Override
            public void onFailed(int code, String message) {
                Snackbar.make(v, String.format("Failed (%s): %s", code, message), Snackbar.LENGTH_INDEFINITE).show();
            }
        };

        switch (v.getId()) {
            case R.id.messageDelivery:
                ScgClient.getInstance().confirm(data.getId(), ScgState.DELIVERED, result);
                break;
            case R.id.messageClicktrhu:
                ScgClient.getInstance().confirm(data.getId(), ScgState.CLICKTHRU, result);
                break;
            case R.id.messageDeeplink:
                if (data.hasDeepLink()) {
                    ScgClient.getInstance().resolveTrackedLink(data.getDeepLink(), result);
                }
                break;
            case R.id.messageAttachment:
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
                        progress = new AlertDialog.Builder(context).setTitle("Error").setMessage(error).show();
                    }
                }.execute(data.getId(), data.getAttachment());
                break;
        }


    }

    void addMessage(ScgMessage msg) {
        dataset.add(msg);
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
        holder.getBinding().setVariable(BR.message, data);
        holder.getBinding().executePendingBindings();

        holder.binding.messageAttachment.setOnClickListener(this);
        holder.binding.messageAttachment.setTag(holder);

        holder.binding.messageClicktrhu.setOnClickListener(this);
        holder.binding.messageClicktrhu.setTag(holder);

        holder.binding.messageDelivery.setOnClickListener(this);
        holder.binding.messageDelivery.setTag(holder);

        holder.binding.messageDeeplink.setOnClickListener(this);
        holder.binding.messageDeeplink.setTag(holder);
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

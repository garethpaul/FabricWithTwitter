package samples.twitterkit.fabric.twitter.com.wearexample;

import android.content.Intent;
import android.app.PendingIntent;
import android.os.Build;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.util.Log;

import com.google.android.gms.wearable.MessageEvent;
import com.google.android.gms.wearable.WearableListenerService;

public class ListenerService extends WearableListenerService {
    private static final String TAG = ListenerService.class.getSimpleName();
    private static final String PATH = "/new_tweet";
    private static final int NOTIFICATION_ID = 1;

    @Override
    public void onMessageReceived( final MessageEvent messageEvent ) {
        if (messageEvent == null || messageEvent.getPath() == null) {
            Log.e(TAG, "Ignoring wear message without path");
            return;
        }
        if (!PATH.equals(messageEvent.getPath())) {
            Log.d(TAG, "Ignoring unexpected wear path");
            return;
        }

        byte[] messageData = messageEvent.getData();
        if (messageData == null || messageData.length == 0) {
            Log.e(TAG, "Ignoring wear message without tweet payload");
            return;
        }
        String tweet = WearMessagePolicy.decodeTweetPayload(messageData);
        if (tweet == null) {
            Log.e(TAG, "Ignoring invalid wear tweet payload");
            return;
        }

        // Build intent for validated notification content
        Intent viewIntent = new Intent(this, NotificationActivity.class);
        viewIntent.putExtra(NotificationActivity.TWEET_KEY, tweet);
        PendingIntent viewPendingIntent =
                PendingIntent.getActivity(this, 0, viewIntent,
                        WearMessagePolicy.pendingIntentFlags(Build.VERSION.SDK_INT));

        NotificationCompat.Builder notificationBuilder =
                new NotificationCompat.Builder(this)
                        .setSmallIcon(R.drawable.ic_launcher)
                        .setContentTitle("Tweet")
                        .setContentText(tweet)
                        .setContentIntent(viewPendingIntent);

        // Get an instance of the NotificationManager service
        NotificationManagerCompat notificationManager =
                NotificationManagerCompat.from(this);

        // Build the notification and issues it with notification manager.
        notificationManager.notify(NOTIFICATION_ID, notificationBuilder.build());

    }
}

package samples.twitterkit.fabric.twitter.com.wearexample;

import android.content.Intent;
import android.app.PendingIntent;
import android.support.v4.app.NotificationCompat;
import android.support.v4.app.NotificationManagerCompat;
import android.util.Log;

import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.wearable.MessageEvent;
import com.google.android.gms.wearable.Wearable;
import com.google.android.gms.wearable.WearableListenerService;

import java.nio.charset.Charset;


public class ListenerService extends WearableListenerService {
    private static final String TAG = ListenerService.class.getSimpleName();
    private static final String PATH = "/new_tweet";
    private static final int NOTIFICATION_ID = 1;
    private static final Charset UTF_8 = Charset.forName("UTF-8");

    private GoogleApiClient client;

    @Override
    public void onCreate() {
        super.onCreate();
        client = new GoogleApiClient.Builder(this)
                .addApi(Wearable.API)
                .build();
        client.connect();
        Wearable.MessageApi.addListener( client, this );
    }

    @Override
    public void onMessageReceived( final MessageEvent messageEvent ) {
        if (messageEvent == null || messageEvent.getPath() == null) {
            Log.e(TAG, "Ignoring wear message without path");
            return;
        }
        if (!PATH.equals(messageEvent.getPath())) {
            Log.d(TAG, "Ignoring unexpected wear path: " + messageEvent.getPath());
            return;
        }

        byte[] messageData = messageEvent.getData();
        if (messageData == null || messageData.length == 0) {
            Log.e(TAG, "Ignoring wear message without tweet payload");
            return;
        }

        // Build intent for notification content
        Intent viewIntent = new Intent(this, NotificationActivity.class);
        String tweet = new String(messageData, UTF_8);
        viewIntent.putExtra(NotificationActivity.TWEET_KEY, tweet);
        PendingIntent viewPendingIntent =
                PendingIntent.getActivity(this, 0, viewIntent, 0);

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

    @Override
    public void onDestroy() {
        if (client != null) {
            Wearable.MessageApi.removeListener(client, this);
            if (client.isConnected() || client.isConnecting()) {
                client.disconnect();
            }
        }
        super.onDestroy();
    }
}

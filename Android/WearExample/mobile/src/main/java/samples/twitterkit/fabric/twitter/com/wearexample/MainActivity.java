package samples.twitterkit.fabric.twitter.com.wearexample;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.view.View;

import com.google.android.gms.common.ConnectionResult;
import com.google.android.gms.common.api.GoogleApiClient;
import com.google.android.gms.wearable.MessageApi;
import com.google.android.gms.wearable.Node;
import com.google.android.gms.wearable.NodeApi;
import com.google.android.gms.wearable.Wearable;
import android.content.Intent;
import android.widget.RelativeLayout;

import java.nio.charset.Charset;

import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.Callback;
import com.twitter.sdk.android.core.Result;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.TwitterSession;
import com.twitter.sdk.android.core.identity.TwitterLoginButton;
import com.twitter.sdk.android.core.models.Tweet;
import com.twitter.sdk.android.tweetui.LoadCallback;
import com.twitter.sdk.android.tweetui.TweetUtils;
import com.twitter.sdk.android.tweetui.TweetView;


import io.fabric.sdk.android.Fabric;

public class MainActivity extends Activity implements GoogleApiClient.ConnectionCallbacks, GoogleApiClient.OnConnectionFailedListener {

    private GoogleApiClient client;
    private TwitterLoginButton loginButton;
    private volatile boolean activityDestroyed;

    private static final String PATH = "/new_tweet";
    private static final String TAG = MainActivity.class.getSimpleName();
    private static final String TWITTER_KEY = "";
    private static final String TWITTER_SECRET = "";
    private static final Charset UTF_8 = Charset.forName("UTF-8");
    private static final int MAX_TWEET_PAYLOAD_BYTES = 1024;


    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);

        // Setup TwitterAuth with TWITTER_KEY/consumerKey and TWITTER_SECRET/consumerSecret.
        final TwitterAuthConfig authConfig = new TwitterAuthConfig(TWITTER_KEY, TWITTER_SECRET);
        Fabric.with(this, new Twitter(authConfig));
        setContentView(R.layout.activity_main);

        // myLayout is a placeholder RelativeLayout within activity_main.xml, which will render a tweet in.
        RelativeLayout myLayout = (RelativeLayout) findViewById(R.id.tweet_view);

        loginButton = (TwitterLoginButton)
                findViewById(R.id.login_button);
        if (loginButton != null) {
            loginButton.setCallback(new Callback<TwitterSession>() {
                @Override
                public void success(Result<TwitterSession> result) {
                    if (activityDestroyed) {
                        Log.d(TAG, "Skipping login callback for destroyed activity");
                        return;
                    }
                    // Do something with result, which provides a
                    // TwitterSession for making API calls
                    loadTweets();
                    if (activityDestroyed) {
                        Log.d(TAG, "Skipping login callback for destroyed activity");
                        return;
                    }
                    if (loginButton != null) {
                        loginButton.setVisibility(View.INVISIBLE);
                    }
                }

                @Override
                public void failure(TwitterException exception) {
                    Log.d(TAG, "Twitter login failed");
                }
            });
        } else {
            Log.w(TAG, "Twitter login button not found");
        }

        // Setup WearablesClient
        setupClient();
    }


    private void loadTweets() {
        final long  tweetId = 524971209851543553L;
        TweetUtils.loadTweet(tweetId, new LoadCallback<Tweet>() {
            @Override
            public void success(Tweet tweet) {
                if (activityDestroyed) {
                    Log.d(TAG, "Skipping tweet callback for destroyed activity");
                    return;
                }
                if (tweet == null || tweet.text == null || tweet.text.trim().length() == 0) {
                    Log.d(TAG, "Skipping wear message without tweet text");
                    return;
                }
                sendMessage(PATH, tweet.text.trim());
                if (activityDestroyed) {
                    Log.d(TAG, "Skipping tweet callback for destroyed activity");
                    return;
                }
                final RelativeLayout tweetContainer
                        = (RelativeLayout) findViewById(R.id.tweet_view);
                if (tweetContainer == null) {
                    Log.w(TAG, "Tweet display container not found");
                    return;
                }
                tweetContainer.addView(new TweetView(
                        MainActivity.this, tweet));
            }

            @Override
            public void failure(TwitterException e) {

            }
        });
    }


    private void setupClient() {
        client = new GoogleApiClient.Builder(this)
                .addApi(Wearable.API)
                .addConnectionCallbacks(this)
                .addOnConnectionFailedListener(this)
                .build();
        if (!client.isConnected()) {
            client.connect();
        }
    }


    private void sendMessage( final String path, final String tweetText ) {
        final GoogleApiClient messageClient = client;
        if (activityDestroyed) {
            Log.d(TAG, "Skipping wear message for destroyed activity");
            return;
        }
        if (path == null || tweetText == null || messageClient == null) {
            Log.d(TAG, "Skipping wear message without path, tweet, or client");
            return;
        }
        final String safeTweetText = tweetText.trim();
        if (safeTweetText.length() == 0) {
            Log.d(TAG, "Skipping wear message without tweet text");
            return;
        }
        final byte[] tweetPayload = safeTweetText.getBytes(UTF_8);
        if (tweetPayload.length > MAX_TWEET_PAYLOAD_BYTES) {
            Log.d(TAG, "Skipping oversized wear tweet payload");
            return;
        }

        new Thread(new Runnable() {
            @Override
            public void run() {
                if (activityDestroyed) {
                    Log.d(TAG, "Skipping wear message for destroyed activity");
                    return;
                }
                if (!messageClient.isConnected() && !messageClient.blockingConnect().isSuccess()) {
                    Log.d(TAG, "Skipping wear message without connected client");
                    return;
                }
                if (activityDestroyed) {
                    messageClient.disconnect();
                    Log.d(TAG, "Skipping wear message for destroyed activity");
                    return;
                }

                NodeApi.GetConnectedNodesResult nodes = Wearable.NodeApi.getConnectedNodes(messageClient).await();
                for (Node node : nodes.getNodes()) {
                    MessageApi.SendMessageResult result = Wearable.MessageApi.sendMessage(
                            messageClient, node.getId(), path, tweetPayload).await();
                }
            }
        }).start();
    }


    @Override
    protected void onDestroy() {
        activityDestroyed = true;
        if (client != null && (client.isConnected() || client.isConnecting())) {
            client.disconnect();
        }
        super.onDestroy();
    }


    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        // Inflate the menu; this adds items to the action bar if it is present.
        getMenuInflater().inflate(R.menu.menu_main, menu);
        return true;
    }


    @Override
    public boolean onOptionsItemSelected(MenuItem item) {
        // Handle action bar item clicks here. The action bar will
        // automatically handle clicks on the Home/Up button, so long
        // as you specify a parent activity in AndroidManifest.xml.
        int id = item.getItemId();

        //noinspection SimplifiableIfStatement
        if (id == R.id.action_settings) {
            return true;
        }

        return super.onOptionsItemSelected(item);
    }


    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if (loginButton != null) {
            loginButton.onActivityResult(requestCode, resultCode, data);
        }
    }


    @Override
    public void onConnected(Bundle bundle) {
        Log.d(TAG, "onConnected");
    }


    @Override
    public void onConnectionSuspended(int i) {
        Log.d(TAG, "onConnectionSuspend");
    }


    @Override
    public void onConnectionFailed(ConnectionResult connectionResult) {
        Log.d(TAG, "onConnectionFailed");
    }
}

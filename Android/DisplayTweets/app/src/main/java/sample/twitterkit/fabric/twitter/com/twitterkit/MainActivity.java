package sample.twitterkit.fabric.twitter.com.twitterkit;

import android.app.Activity;
import android.os.Bundle;
import android.util.Log;
import android.view.Menu;
import android.view.MenuItem;
import android.widget.LinearLayout;

import com.twitter.sdk.android.Twitter;
import com.twitter.sdk.android.core.TwitterAuthConfig;
import com.twitter.sdk.android.core.TwitterException;
import com.twitter.sdk.android.core.models.Tweet;
import com.twitter.sdk.android.tweetui.CompactTweetView;
import com.twitter.sdk.android.tweetui.LoadCallback;
import com.twitter.sdk.android.tweetui.TweetUtils;

import java.util.Arrays;
import java.util.List;

import io.fabric.sdk.android.Fabric;


public class MainActivity extends Activity {

    // Note: Your consumer key/TWITTER_KEY and secret/TWITTER_SECRET should be obfuscated in your source code before shipping.
    private static final String TAG = MainActivity.class.getSimpleName();
    private static final String TWITTER_KEY = "";
    private static final String TWITTER_SECRET = "";
    private volatile boolean activityDestroyed;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);


        final TwitterAuthConfig authConfig = new TwitterAuthConfig(TWITTER_KEY, TWITTER_SECRET);

        Fabric.with(this, new Twitter(authConfig));
        setContentView(R.layout.activity_main);

        final LinearLayout myLayout
                = (LinearLayout) findViewById(R.id.tweets);

        final List<Long> tweetIds =
                Arrays.asList(531132223265992704L, 20L);

        TweetUtils.loadTweets(tweetIds, new LoadCallback<List<Tweet>>() {
            @Override
            public void success(List<Tweet> tweets) {
                if (activityDestroyed) {
                    Log.d(TAG, "Skipping tweet callback for destroyed activity");
                    return;
                }
                for (Tweet tweet : tweets) {
                    if (activityDestroyed) {
                        Log.d(TAG, "Skipping tweet callback for destroyed activity");
                        return;
                    }
                    Log.v(TAG, "Loaded tweet for display");
                    myLayout.addView(new CompactTweetView(MainActivity.this, tweet));
                }
            }

            @Override
            public void failure(TwitterException exception) {
                Log.v(TAG, "Tweet load failed");
            }
        });
    }

    @Override
    protected void onDestroy() {
        activityDestroyed = true;
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
}

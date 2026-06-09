package samples.twitterkit.fabric.twitter.com.wearexample;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import android.util.Log;
import android.widget.TextView;

public class NotificationActivity extends Activity {
    private static final String TAG = NotificationActivity.class.getSimpleName();
    public static final String TWEET_KEY = "tweet";
    private TextView mTextView;

    @Override
    protected void onCreate(Bundle savedInstanceState) {
        Log.v(TAG, "onCreate");
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_notification);
        mTextView = (TextView) findViewById(R.id.text_view);

        Intent intent = getIntent();
        if (intent != null) {
            // Push Tweet to TextView
            String tweet = intent.getStringExtra(TWEET_KEY);
            if (tweet != null && tweet.length() > 0) {
                mTextView.setText(tweet);
            }
        }
    }
}

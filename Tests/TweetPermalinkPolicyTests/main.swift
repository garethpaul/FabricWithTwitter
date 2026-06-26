import Foundation

private var failureCount = 0

private func expect(_ urlString: String?, accepted expected: Bool, _ message: String) {
    let url: NSURL?
    if let urlString = urlString {
        url = NSURL(string: urlString)
    } else {
        url = nil
    }

    let actual = validatedTweetPermalink(url: url) != nil
    if actual != expected {
        failureCount += 1
        print("FAIL: \(message): expected \(expected), got \(actual)")
    }
}

expect("https://twitter.com/example/status/1", accepted: true, "Twitter host")
expect("https://www.twitter.com/example/status/1?ref=app", accepted: true, "www Twitter host")
expect("https://x.com/example/status/1", accepted: true, "X host")
expect("https://www.x.com/example/status/1#context", accepted: true, "www X host")
expect("https://TWITTER.COM/example/status/1", accepted: true, "mixed-case host")
expect("https://twitter.com/example/status/1234567890/", accepted: true, "trailing slash")
expect(nil, accepted: false, "missing URL")
expect("http://twitter.com/example/status/1", accepted: false, "non-HTTPS scheme")
expect("https://user@twitter.com/example/status/1", accepted: false, "userinfo")
expect("https://user:password@twitter.com/example/status/1", accepted: false, "password")
expect("https://twitter.com:8443/example/status/1", accepted: false, "explicit port")
expect("https://mobile.twitter.com/example/status/1", accepted: false, "unlisted subdomain")
expect("https://twitter.com.evil.example/status/1", accepted: false, "host suffix")
expect("https://evil-twitter.com/example/status/1", accepted: false, "host prefix")
expect("https://example.com/twitter/status/1", accepted: false, "unrelated host")
expect("https:///example/status/1", accepted: false, "hostless URL")
expect("https://twitter.com/", accepted: false, "host root is not a tweet permalink")
expect("https://twitter.com/example", accepted: false, "profile URL is not a tweet permalink")
expect("https://twitter.com/example/status/not-a-number", accepted: false, "non-numeric status ID")
expect("https://twitter.com/examplе/status/1", accepted: false, "Cyrillic handle lookalike")
expect("https://twitter.com/example/status/١", accepted: false, "non-ASCII status digits")
expect("https://twitter.com/example/status/1/analytics", accepted: false, "extra path component")
expect("https://twitter.com/example/lists/status/1", accepted: false, "misplaced status component")

if failureCount > 0 {
    exit(1)
}

print("TweetPermalinkPolicy behavioral tests passed")

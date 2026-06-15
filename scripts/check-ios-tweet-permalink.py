#!/usr/bin/env python3
import sys
from pathlib import Path
import re
from urllib.parse import urlsplit

CANONICAL_HOSTS = ("twitter.com", "www.twitter.com", "x.com", "www.x.com")


source = Path(sys.argv[1]).read_text(encoding="utf-8")
plan = Path(sys.argv[2]).read_text(encoding="utf-8")

required = [
    "func isCanonicalTweetPermalinkHost(host: String?) -> Bool",
    "func validatedTweetPermalink(url: NSURL?) -> NSURL?",
    'candidate.scheme?.lowercaseString == "https"',
    "candidate.user == nil",
    "candidate.password == nil",
    "candidate.port == nil",
    "isCanonicalTweetPermalinkHost(candidate.host)",
    "validatedTweetPermalink(tweet?.permalink)",
    "webView.loadRequest(NSURLRequest(URL: permalink))",
    'println("Tweet permalink was rejected")',
]
for fragment in required:
    if fragment not in source:
        raise SystemExit("iOS tweet permalink boundary missing: " + fragment)

helper_start = source.find("func isCanonicalTweetPermalinkHost")
validator_start = source.find("func validatedTweetPermalink", helper_start)
helper = source[helper_start:validator_start]
for forbidden in ("hasSuffix", "containsString", "candidateHost !=", "return true"):
    if forbidden in helper:
        raise SystemExit("iOS tweet permalink hosts must use exact equality")
allowed_hosts = re.findall(r'candidateHost == "([^"]+)"', helper)
if allowed_hosts != list(CANONICAL_HOSTS):
    raise SystemExit("iOS tweet permalink allowlist must contain exactly four canonical hosts")

selection = source.find(
    "func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!)"
)
validation = source.find("validatedTweetPermalink(tweet?.permalink)", selection)
web_view = source.find("let webView = UIWebView", selection)
request = source.find("webView.loadRequest(NSURLRequest(URL: permalink))", selection)
navigation = source.find("pushViewController(webViewController", selection)
if -1 in (selection, validation, web_view, request, navigation) or not (
    selection < validation < web_view < request < navigation
):
    raise SystemExit("Tweet permalink validation must precede web-view, request, and navigation creation.")
if "NSURLRequest(URL: tweet.permalink)" in source:
    raise SystemExit("Raw tweet permalinks must not reach NSURLRequest.")


def accepts(url):
    if url is None:
        return False
    parsed = urlsplit(url)
    return (
        parsed.scheme.lower() == "https"
        and parsed.username is None
        and parsed.password is None
        and parsed.port is None
        and parsed.hostname in CANONICAL_HOSTS
    )


accepted = [
    "https://twitter.com/example/status/1",
    "HTTPS://www.twitter.com/example/status/1?ref=app",
    "https://x.com/example/status/1",
    "https://www.x.com/example/status/1#context",
]
rejected = [
    None,
    "http://twitter.com/example/status/1",
    "https:///example/status/1",
    "https://user@twitter.com/example/status/1",
    "https://user:pass@twitter.com/example/status/1",
    "https://twitter.com:8443/example/status/1",
    "https://mobile.twitter.com/example/status/1",
    "https://twitter.com.evil.example/status/1",
    "https://evil-twitter.com/example/status/1",
    "https://example.com/twitter/status/1",
    "javascript:alert(1)",
]
if not all(accepts(url) for url in accepted):
    raise SystemExit("Permalink boundary rejected an allowed HTTPS URL.")
if any(accepts(url) for url in rejected):
    raise SystemExit("Permalink boundary accepted a rejected URL.")

for evidence in ("status: completed", "hostile mutations were rejected", "make check"):
    if evidence not in plan:
        raise SystemExit("iOS tweet permalink plan missing: " + evidence)

print("iOS tweet permalink checks passed.")

#!/usr/bin/env python3
import sys
from pathlib import Path
from urllib.parse import urlsplit


source = Path(sys.argv[1]).read_text(encoding="utf-8")
plan = Path(sys.argv[2]).read_text(encoding="utf-8")

required = [
    "func validatedTweetPermalink(url: NSURL?) -> NSURL?",
    'candidate.scheme?.lowercaseString == "https"',
    "candidate.user == nil",
    "candidate.password == nil",
    "if let host = candidate.host",
    "if !host.isEmpty",
    "validatedTweetPermalink(tweet?.permalink)",
    "webView.loadRequest(NSURLRequest(URL: permalink))",
    'println("Tweet permalink was rejected")',
]
for fragment in required:
    if fragment not in source:
        raise SystemExit("iOS tweet permalink boundary missing: " + fragment)

selection = source.find(
    "func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!)"
)
validation = source.find("validatedTweetPermalink(tweet?.permalink)", selection)
request = source.find("webView.loadRequest(NSURLRequest(URL: permalink))", selection)
navigation = source.find("pushViewController(webViewController", selection)
if -1 in (selection, validation, request, navigation) or not (
    selection < validation < request < navigation
):
    raise SystemExit("Tweet permalink validation must precede web request and navigation.")
if "NSURLRequest(URL: tweet.permalink)" in source:
    raise SystemExit("Raw tweet permalinks must not reach NSURLRequest.")


def accepts(url):
    if url is None:
        return False
    parsed = urlsplit(url)
    return (
        parsed.scheme.lower() == "https"
        and bool(parsed.hostname)
        and parsed.username is None
        and parsed.password is None
    )


accepted = [
    "https://twitter.com/example/status/1",
    "HTTPS://mobile.twitter.com/example/status/1?ref=app",
]
rejected = [
    None,
    "http://twitter.com/example/status/1",
    "https:///example/status/1",
    "https://user@twitter.com/example/status/1",
    "https://user:pass@twitter.com/example/status/1",
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

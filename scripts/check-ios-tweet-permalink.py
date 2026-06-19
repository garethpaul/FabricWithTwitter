#!/usr/bin/env python3
"""Verify the production and navigation tweet permalink boundary."""

from pathlib import Path
import re
import sys
from urllib.parse import urlsplit

CANONICAL_HOSTS = ("twitter.com", "www.twitter.com", "x.com", "www.x.com")
TWEET_PATH = re.compile(r"^/[A-Za-z0-9_]+/status/[0-9]+/?$")


def accepts(url: str) -> bool:
    candidate = urlsplit(url)
    return (
        candidate.scheme.lower() == "https"
        and candidate.username is None
        and candidate.password is None
        and candidate.port is None
        and candidate.hostname in CANONICAL_HOSTS
        and TWEET_PATH.fullmatch(candidate.path) is not None
    )


def main() -> None:
    if len(sys.argv) != 3:
        raise SystemExit(
            "usage: check-ios-tweet-permalink.py "
            "<TweetPermalinkPolicy.swift> <ViewController.swift>"
        )

    source = Path(sys.argv[1]).read_text(encoding="utf-8")
    navigation = Path(sys.argv[2]).read_text(encoding="utf-8")
    required = (
        'candidateHost == "twitter.com"',
        'candidateHost == "www.twitter.com"',
        'candidateHost == "x.com"',
        'candidateHost == "www.x.com"',
        "#if EXECUTABLE_POLICY_TESTS",
        "let candidateHost = host.lowercased()",
        "let candidateHost = host.lowercaseString",
        "let normalizedScheme = scheme.lowercased()",
        "let normalizedScheme = scheme.lowercaseString",
        'normalizedScheme == "https"',
        "let hasCanonicalHost = isCanonicalTweetPermalinkHost",
        "let hasCanonicalPath = isCanonicalTweetPermalinkPath",
        "if hasCanonicalHost && hasCanonicalPath",
        "candidate.port == nil",
        "isCanonicalTweetPermalinkHost(candidate.host)",
    )
    missing = [contract for contract in required if contract not in source]
    if missing:
        raise SystemExit("Missing iOS permalink contracts: " + ", ".join(missing))

    helper_start = source.find("func isCanonicalTweetPermalinkHost")
    validator_start = source.find("func validatedTweetPermalink", helper_start)
    helper = source[helper_start:validator_start]
    forbidden = ("hasSuffix", "containsString", "candidateHost !=", "return true")
    if helper_start == -1 or validator_start == -1 or any(token in helper for token in forbidden):
        raise SystemExit("iOS permalink hosts must use exact equality")
    if re.findall(r'candidateHost == "([^"]+)"', helper) != list(CANONICAL_HOSTS):
        raise SystemExit("iOS permalink allowlist must contain exactly four canonical hosts")

    selection = navigation.find(
        "func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!)"
    )
    validation = navigation.find("validatedTweetPermalink(tweet?.permalink)", selection)
    web_view = navigation.find("let webView = UIWebView", selection)
    request = navigation.find("webView.loadRequest(NSURLRequest(URL: permalink))", selection)
    push = navigation.find("pushViewController", selection)
    if -1 in (selection, validation, web_view, request, push) or not (
        selection < validation < web_view < request < push
    ):
        raise SystemExit("Tweet permalink validation must precede request and navigation creation")
    if "func validatedTweetPermalink" in navigation:
        raise SystemExit("ViewController must delegate to the production permalink policy")

    accepted = (
        "https://twitter.com/example/status/1",
        "https://www.twitter.com/example/status/1?ref=app",
        "https://x.com/example/status/1",
        "https://www.x.com/example/status/1#context",
        "https://TWITTER.COM/example/status/1",
    )
    rejected = (
        "http://twitter.com/example/status/1",
        "https://user@twitter.com/example/status/1",
        "https://twitter.com:8443/example/status/1",
        "https://mobile.twitter.com/example/status/1",
        "https://twitter.com.evil.example/status/1",
        "https://evil-twitter.com/example/status/1",
        "https://example.com/twitter/status/1",
        "https:///example/status/1",
        "https://twitter.com/",
        "https://twitter.com/example",
        "https://twitter.com/example/status/not-a-number",
        "https://twitter.com/example/status/1/analytics",
        "https://twitter.com/example/lists/status/1",
    )
    if not all(accepts(url) for url in accepted):
        raise SystemExit("Canonical iOS permalink matrix rejected a valid URL")
    if any(accepts(url) for url in rejected):
        raise SystemExit("Canonical iOS permalink matrix accepted an invalid URL")

    print("iOS tweet permalink checks passed.")


if __name__ == "__main__":
    main()

//
//  ViewController.swift
//
//

import UIKit
import TwitterKit

func validatedTweetPermalink(url: NSURL?) -> NSURL? {
    if let candidate = url {
        if candidate.scheme?.lowercaseString == "https" &&
            candidate.user == nil &&
            candidate.password == nil {
            if let host = candidate.host {
                if !host.isEmpty {
                    return candidate
                }
            }
        }
    }

    return nil
}

class ViewController: UITableViewController , TWTRTweetViewDelegate {

    // setup a 'container' for Tweets
    var tweets: [TWTRTweet] = [] {
        didSet {
            tableView.reloadData()
        }
    }

    var prototypeCell: TWTRTweetTableViewCell?

    let tweetTableCellReuseIdentifier = "TweetCell"

    var isLoadingTweets = false


    override func viewDidLoad() {
        super.viewDidLoad()

        // Create a single prototype cell for height calculations.
        self.prototypeCell = TWTRTweetTableViewCell(style: .Default, reuseIdentifier: tweetTableCellReuseIdentifier)

        // Register the identifier for TWTRTweetTableViewCell.
        self.tableView.registerClass(TWTRTweetTableViewCell.self, forCellReuseIdentifier: tweetTableCellReuseIdentifier)
        // Setup table data

        loadTweets()

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        // Make sure the navigation bar is not translucent when scrolling the table view.
        self.navigationController?.navigationBar.translucent = false
    }


    func loadTweets() {
        // Do not trigger another request if one is already in progress.
        if self.isLoadingTweets {
            return
        }
        self.isLoadingTweets = true

        // set tweetIds to find
        var tweetIDs = ["266031293945503744", "440322224407314432"];

        // load tweets with guest login
        Twitter.sharedInstance().logInGuestWithCompletion { (session: TWTRGuestSession!, error: NSError!) in
            if session == nil {
                self.isLoadingTweets = false
                println("Twitter guest login failed")
                return
            }

            // Find the tweets with the tweetIDs
            Twitter.sharedInstance().APIClient.loadTweetsWithIDs(tweetIDs) {
                (twttrs, error) -> Void in
                self.isLoadingTweets = false

                // If there are tweets do something magical
                if let loadedTweetObjects = twttrs {
                    var loadedTweets: [TWTRTweet] = []
                    for i in loadedTweetObjects {
                        if let tweet = i as? TWTRTweet {
                            loadedTweets.append(tweet)
                        }
                    }
                    self.tweets = loadedTweets
                } else {
                    println("Twitter tweet load failed")
                }

            }
        }

    }

    func refreshInvoked() {
        // Trigger a load for the most recent Tweets.
        loadTweets()
    }

    // MARK: TWTRTweetViewDelegate
    func tweetView(tweetView: TWTRTweetView!, didSelectTweet tweet: TWTRTweet!) {
        if let permalink = validatedTweetPermalink(tweet?.permalink) {
            // Display a Web View only for a validated Tweet permalink.
            let webViewController = UIViewController()
            let webView = UIWebView(frame: webViewController.view.bounds)
            webView.loadRequest(NSURLRequest(URL: permalink))
            webViewController.view = webView
            self.navigationController?.pushViewController(webViewController, animated: true)
        } else {
            println("Tweet permalink was rejected")
        }
    }

    // MARK: UITableViewDataSource
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // Return the number of Tweets.
        return tweets.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // Retrieve the Tweet cell.
        let cell = tableView.dequeueReusableCellWithIdentifier(tweetTableCellReuseIdentifier, forIndexPath: indexPath) as TWTRTweetTableViewCell

        // Assign the delegate to control events on Tweets.
        cell.tweetView.delegate = self

        // Retrieve the Tweet model from loaded Tweets.
        let tweet = tweets[indexPath.row]

        // Configure the cell with the Tweet.
        cell.configureWithTweet(tweet)

        // Return the Tweet cell.
        return cell
    }

    // MARK: UITableViewDelegate
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let tweet = self.tweets[indexPath.row]
        self.prototypeCell?.configureWithTweet(tweet)
        if let height = self.prototypeCell?.calculatedHeightForWidth(self.view.bounds.width) {
            return height
        } else {
            return self.tableView.estimatedRowHeight
        }
    }
}

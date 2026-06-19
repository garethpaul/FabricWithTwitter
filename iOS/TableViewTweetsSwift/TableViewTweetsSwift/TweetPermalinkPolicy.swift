import Foundation

func isCanonicalTweetPermalinkHost(host: String?) -> Bool {
    if let host = host {
#if EXECUTABLE_POLICY_TESTS
        let candidateHost = host.lowercased()
#else
        let candidateHost = host.lowercaseString
#endif
        return candidateHost == "twitter.com" ||
            candidateHost == "www.twitter.com" ||
            candidateHost == "x.com" ||
            candidateHost == "www.x.com"
    }

    return false
}

func isCanonicalTweetPermalinkPath(path: String?) -> Bool {
    if let path = path {
#if EXECUTABLE_POLICY_TESTS
        let components = path.components(separatedBy: "/")
#else
        let components = path.componentsSeparatedByString("/")
#endif
        let hasTrailingSlash = components.count == 5 && components[4].isEmpty
        if components.count != 4 && !hasTrailingSlash {
            return false
        }
        if components[0] != "" || components[1].isEmpty || components[3].isEmpty {
            return false
        }
#if EXECUTABLE_POLICY_TESTS
        if components[2].lowercased() != "status" {
            return false
        }
#else
        if components[2].lowercaseString != "status" {
            return false
        }
#endif

#if EXECUTABLE_POLICY_TESTS
        var handleCharacters = CharacterSet.alphanumerics
        handleCharacters.insert(charactersIn: "_")
        let invalidHandleCharacters = handleCharacters.inverted
        let invalidStatusCharacters = CharacterSet.decimalDigits.inverted
        return components[1].rangeOfCharacter(from: invalidHandleCharacters) == nil &&
            components[3].rangeOfCharacter(from: invalidStatusCharacters) == nil
#else
        let handleCharacters = NSMutableCharacterSet.alphanumericCharacterSet()
        handleCharacters.addCharactersInString("_")
        return components[1].rangeOfCharacterFromSet(handleCharacters.invertedSet) == nil &&
            components[3].rangeOfCharacterFromSet(NSCharacterSet.decimalDigitCharacterSet().invertedSet) == nil
#endif
    }

    return false
}

func validatedTweetPermalink(url: NSURL?) -> NSURL? {
    if let candidate = url {
        if let scheme = candidate.scheme {
#if EXECUTABLE_POLICY_TESTS
            let normalizedScheme = scheme.lowercased()
#else
            let normalizedScheme = scheme.lowercaseString
#endif
            if normalizedScheme == "https" &&
                candidate.user == nil &&
                candidate.password == nil &&
                candidate.port == nil {
#if EXECUTABLE_POLICY_TESTS
                let hasCanonicalHost = isCanonicalTweetPermalinkHost(host: candidate.host)
#else
                let hasCanonicalHost = isCanonicalTweetPermalinkHost(candidate.host)
#endif
#if EXECUTABLE_POLICY_TESTS
                let hasCanonicalPath = isCanonicalTweetPermalinkPath(path: candidate.path)
#else
                let hasCanonicalPath = isCanonicalTweetPermalinkPath(candidate.path)
#endif
                if hasCanonicalHost && hasCanonicalPath {
                    return candidate
                }
            }
        }
    }

    return nil
}

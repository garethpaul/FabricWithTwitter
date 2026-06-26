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

func isASCIITweetHandle(value: String) -> Bool {
    var hasByte = false
    for byte in value.utf8 {
        hasByte = true
        let isDigit = byte >= 0x30 && byte <= 0x39
        let isUppercaseLetter = byte >= 0x41 && byte <= 0x5A
        let isLowercaseLetter = byte >= 0x61 && byte <= 0x7A
        if !isDigit && !isUppercaseLetter && !isLowercaseLetter && byte != 0x5F {
            return false
        }
    }
    return hasByte
}

func isASCIITweetStatusID(value: String) -> Bool {
    var hasByte = false
    for byte in value.utf8 {
        hasByte = true
        if byte < 0x30 || byte > 0x39 {
            return false
        }
    }
    return hasByte
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
        return isASCIITweetHandle(value: components[1]) &&
            isASCIITweetStatusID(value: components[3])
#else
        return isASCIITweetHandle(components[1]) &&
            isASCIITweetStatusID(components[3])
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

/// Reports violations as JUnit XML.
public struct JUnitReporter: Reporter {
    // MARK: - Reporter Conformance

    public static let identifier = "junit"
    public static let isRealtime = false

    public var description: String {
        return "Reports violations as JUnit XML."
    }

    public static func generateReport(_ violations: [StyleViolation]) -> String {
        return "<?xml version=\"1.0\" encoding=\"utf-8\"?>\n<testsuites><testsuite>\n" +
            violations.map({ violation -> String in
                let fileName = (violation.location.file ?? "<nopath>").escapedForXML()
                let severity = violation.severity.rawValue + ":\n"
                let message = severity + "Line:" + String(violation.location.line ?? 0) + " "
                let reason = violation.reason.escapedForXML()
                return [
                    "\t<testcase classname='Swift Lint' name='\(fileName)\'>\n",
                    "\t\t<failure message='\(reason)\'>" + message + "</failure>\n",
                    "\t</testcase>\n"
                ].joined()
            }).joined() + "</testsuite></testsuites>"
    }
}

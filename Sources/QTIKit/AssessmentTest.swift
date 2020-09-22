
public struct AssessmentTest: Identifiable, XMLDecodable {

    struct Part: Identifiable, XMLDecodable {

        let id: String
        let navigationMode: String
        let submissionMode: String
        let sections: [AssessmentSection]

        static func decode(from element: Element) throws -> AssessmentTest.Part {
            try Part(
                id: element.attr("identifier"),
                navigationMode: element.attr("navigationMode"),
                submissionMode: element.attr("submissionMode"),
                sections: element.select("assessmentSection").map(AssessmentSection.decode(from:))
            )
        }
    }

    public let id: String
    let title: String
    let parts: [Part]

    static func decode(from element: Element) throws -> AssessmentTest {

        let parts = try element.select("testPart").map(Part.decode(from: ))

        return try AssessmentTest(
            id: element.attr("identifier"),
            title: element.attr("title"),
            parts: parts
        )
    }
}

struct AssessmentSection: Identifiable, XMLDecodable {

    let id: String
    let isVisible: Bool
    let title: String

    let items: [AssessmentItem]

    static func decode(from element: Element) throws -> AssessmentSection {

        let id = try element.attr("identifier")
        let isVisible = try element.attr("visible") != "false"
        let title = try element.attr("title")

        let itemRefs = try element.select("assessmentItemRef")
        let itemElements = try element.select("assessmentItem")
        let items = try itemRefs
            .map { try AssessmentItem.Reference.decode(from: $0) }
            .map { try AssessmentItem.decode(from: $0) }
            + itemElements.map { try AssessmentItem.decode(from: $0) }

        return AssessmentSection(
            id: id,
            isVisible: isVisible,
            title: title,
            items: items
        )
    }
}

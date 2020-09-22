

public struct ItemBody: XMLDecodable {
    public let body: String
    public let choiceInteraction: ChoiceInteraction

    public static func decode(from element: Element) throws -> ItemBody {
        guard let choiceInteraction = try element.select("choiceInteraction").first() else { throw ParseError.missingTag("choiceInteraction") }

        let interaction = try ChoiceInteraction.decode(from: choiceInteraction)
        try choiceInteraction.remove()
        return try ItemBody(body: element.text(), choiceInteraction: interaction)
    }
}

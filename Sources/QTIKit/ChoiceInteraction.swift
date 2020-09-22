
public struct ChoiceInteraction: XMLDecodable {

    public struct SimpleChoice: XMLDecodable {
        public let id: String
        public let choice: String
        public let isFixed: Bool

        public static func decode(from element: Element) throws -> ChoiceInteraction.SimpleChoice {
            return try ChoiceInteraction.SimpleChoice(
                id: element.attr("identifier"),
                choice: element.text(),
                isFixed: element.attr("fixed") != "false"
            )
        }
    }

    public let responseIdentifier: String
    public let shouldShuffle: Bool
    public let maxChoices: Int
    public let choices: [SimpleChoice]

    public static func decode(from element: Element) throws -> ChoiceInteraction {
        let responseID = try element.attr("responseIdentifier")
        let maxChoices = Int(try element.attr("maxChoices")) ?? 1
        let shouldShuffle = try element.attr("shuffle") != "false"

        let choices = try element.select("simpleChoice").map { try SimpleChoice.decode(from: $0) }

        return ChoiceInteraction(
            responseIdentifier: responseID,
            shouldShuffle: shouldShuffle,
            maxChoices: maxChoices,
            choices: choices
        )
    }
}

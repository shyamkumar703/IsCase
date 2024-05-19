import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros

enum Test {
    case test1
    case test2
    
    func `is`(_ otherCase: Self) -> Bool {
        switch (self, otherCase) {
        case (.test1, .test1):
            return true
        case (.test2, .test2):
            return true
        default:
            return false
        }
    }
}

public struct IsCaseMacro: MemberMacro {
    public static func expansion(
        of node: AttributeSyntax,
        providingMembersOf declaration: some DeclGroupSyntax,
        in context: some MacroExpansionContext
    ) throws -> [DeclSyntax] {
        let caseNames = try getCaseNames(declaration)
        let companionEnum = try EnumDeclSyntax(.init(stringLiteral: "enum Companion")) {
            try MemberBlockItemListSyntax {
                for caseName in caseNames {
                    try EnumCaseDeclSyntax(.init(stringLiteral: "case \(caseName)"))
                }
            }
        }
        
        let funcComparison = try FunctionDeclSyntax(.init(
            stringLiteral: """
                        /// Check if an instance of your enum is a particular case
                        ///
                        /// For example,
                        /// ```
                        /// @IsCase
                        /// enum Test {
                        ///     case test1(String)
                        /// }
                        /// let firstValue = Test.test1("first")
                        /// firstValue.is(.test1) // returns true
                        /// ```
                        func `is`(_ otherCase: Companion) -> Bool
                        """
        )) {
            try SwitchExprSyntax("switch (self, otherCase)") {
                for caseName in caseNames {
                    SwitchCaseSyntax(
                        """
                        case (.\(raw: caseName), .\(raw: caseName)):
                            return true
                        """
                    )
                }
                SwitchCaseSyntax(
                    """
                    default:
                        return false
                    """
                )
            }
        }

        return [
            DeclSyntax(companionEnum),
            DeclSyntax(funcComparison),
        ]
    }
    
    static func getCaseNames(_ decl: some DeclGroupSyntax) throws -> [String] {
        guard let decl = decl.as(EnumDeclSyntax.self) else {
            throw IsCaseError.notAnEnum
        }
        
        var caseNames = [String]()
        
        for member in decl.memberBlock.members {
            guard let member = member.decl.as(EnumCaseDeclSyntax.self) else {
                continue
            }
            
            guard let name = member.elements.first?.name else {
                throw IsCaseError.unexpectedError
            }
            
            caseNames.append(name.text)
        }
        
        return caseNames
    }
    
    enum IsCaseError: Error {
        case notAnEnum
        case unexpectedError
    }
}

@main
struct IsCasePlugin: CompilerPlugin {
    let providingMacros: [Macro.Type] = [
        IsCaseMacro.self,
        AssertCaseMacro.self
    ]
}

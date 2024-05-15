//
//  AssertCaseMacro.swift
//  
//
//  Created by Shyam Kumar on 5/15/24.
//

import SwiftCompilerPlugin
import SwiftSyntax
import SwiftSyntaxBuilder
import SwiftSyntaxMacros


public struct AssertCaseMacro: ExpressionMacro {
    public static func expansion(
        of node: some SwiftSyntax.FreestandingMacroExpansionSyntax,
        in context: some SwiftSyntaxMacros.MacroExpansionContext
    ) throws -> SwiftSyntax.ExprSyntax {
        guard let firstArgument = node.argumentList.first,
              let secondArgument = node.argumentList.last else {
            throw AssertCaseError.notEnoughArguments
        }
        
        guard let firstArgumentString = String(bytes: firstArgument.expression.syntaxTextBytes, encoding: .utf8),
              let secondArgumentString = String(bytes: secondArgument.expression.syntaxTextBytes, encoding: .utf8) else {
            throw AssertCaseError.internalError
        }
        
        let expression = ExprSyntax(stringLiteral: "assert(\(firstArgumentString).is(\(secondArgumentString)))")
        return expression
    }
}

extension AssertCaseMacro {
    public enum AssertCaseError: Error {
        case notEnoughArguments
        case internalError
    }
}

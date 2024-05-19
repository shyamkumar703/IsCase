import SwiftSyntaxMacros
import SwiftSyntaxMacrosTestSupport
import XCTest

import IsCase
#if canImport(IsCaseMacros)
import IsCaseMacros

let testMacros: [String: Macro.Type] = [
    "IsCase": IsCaseMacro.self,
    "assertCase": AssertCaseMacro.self
]
#endif

@IsCase
enum Test: CaseComparable {
    case test1(String)
    case test2(Int)
}

final class IsCaseTests: XCTestCase {
    func testAssertCaseMacro() {
        assertMacroExpansion(
            "#assertCase(Test.test2(3), .test2)",
            expandedSource: "assert(Test.test2(3).is(.test2))",
            macros: testMacros
        )
    }
    
    func testMacro() throws {
        assertMacroExpansion(
            """
            @IsCase
            enum TestEnum {
                case test1(String)
                case test2(Int)
            }
            """,
            expandedSource:
            """
            enum TestEnum {
                case test1(String)
                case test2(Int)
            
                enum Companion {
                    case test1
                    case test2
                }
            
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
                func `is`(_ otherCase: Companion) -> Bool {
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
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithAttachedFunctions() throws {
        assertMacroExpansion(
            """
            @IsCase
            enum TestEnum {
                case test1(String)
                case test2(Int)
            
                func test() {
                    print("hello")
                }
            }
            """,
            expandedSource:
            """
            enum TestEnum {
                case test1(String)
                case test2(Int)
            
                func test() {
                    print("hello")
                }

                enum Companion {
                    case test1
                    case test2
                }
            
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
                func `is`(_ otherCase: Companion) -> Bool {
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
            """,
            macros: testMacros
        )
    }
    
    func testMacroWithAttachedFunctionAndVariable() throws {
        assertMacroExpansion(
            """
            @IsCase
            enum TestEnum {
                case test1(String)
                case test2(Int)
            
                var test3: Bool {
                    true
                }
            
                func test() {
                    print("hello")
                }
            }
            """,
            expandedSource:
            """
            enum TestEnum {
                case test1(String)
                case test2(Int)
            
                var test3: Bool {
                    true
                }

                func test() {
                    print("hello")
                }

                enum Companion {
                    case test1
                    case test2
                }
            
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
                func `is`(_ otherCase: Companion) -> Bool {
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
            """,
            macros: testMacros
        )
    }
}

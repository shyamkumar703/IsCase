// The Swift Programming Language
// https://docs.swift.org/swift-book

/// A macro that produces functions to allow enum case comparisons agnostic of associated values.
///
/// For example, we can make sure two values of the type `Coin` are heads, ignoring the associated `Int`
/// ```
///  @IsCase
///  enum Coin {
///     case heads(Int)
///     case tails(String)
/// }
///
/// let flip1 = Coin.heads(1)
/// let flip2 = Coin.heads(2)
/// flip1.is(flip2) // returns true
/// flip1 == flip2 // returns false
/// ```
@attached(member, names: arbitrary)
public macro IsCase() = #externalMacro(module: "IsCaseMacros", type: "IsCaseMacro")

/// A macro that asserts two enum cases are the same, agnostic of associated values
///
/// We can use this macro to create crashes in debug builds to guard against invalid states. For example,
/// ```
///  @IsCase
///  enum Coin {
///     case heads(Int)
///     case tails(String)
/// }
///
/// let flip1 = Coin.heads(1)
/// let flip2 = Coin.heads(2)
/// #assertCase(flip1, flip2) // assert succeeds
/// let flip3 = Coin.tails("tails!")
/// #assertCase(flip2, flip3) // assert fails
/// ```
@freestanding(expression)
public macro assertCase<T: CaseComparable>(_ value: T, _ otherValue: T.Companion) -> Void = #externalMacro(module: "IsCaseMacros", type: "AssertCaseMacro")

public protocol CaseComparable {
    associatedtype Companion
    func `is`(_ otherCase: Companion) -> Bool
}

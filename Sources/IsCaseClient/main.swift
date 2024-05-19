import IsCase

@IsCase
enum Test: CaseComparable {
    case test1(String)
    case test2(Int)
}

let case1 = Test.test1("test")

_ = case1.is(.test1) // this evaluates to true
_ = case1.is(.test2) // this evaluates to false
#assertCase(case1, .test1) // this assertion passes


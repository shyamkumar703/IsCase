import IsCase

@IsCase
enum Test: CaseComparable {
    case test1(String)
    case test2(Int)
}


let case1 = Test.test1("test")
let case2 = Test.test1("test2")
let case3 = Test.test2(3)

_ = case1.is(.test1) // this evaluates to true
_ = case1.is(case2) // this evalutes to true
_ = case1.is(case3) // this evaluates to false
#assertCase(case1, case2) // this assertion passes
#assertCase(case1, case3) // this assertion does not pass

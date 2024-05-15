import IsCase

@IsCase
enum Test: CaseComparable {
    case test1(String)
    case test2(Int)
}


let case1 = Test.test1("test")
let case2 = Test.test1("test2")
let case3 = Test.test2(3)

// this evaluates to true
print(case1.is(.test1))
// this evalutes to true as well
print(case1.is(case2))
print(case1.rawCase)

#assertCase(case1, case3)

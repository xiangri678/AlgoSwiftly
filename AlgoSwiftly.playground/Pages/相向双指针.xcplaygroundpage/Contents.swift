// 本文档正序，从前往后看
// 167. 两数之和 II - 输入有序数组
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var ans: [Int] = []
    var n = numbers.count
    var l = 0
    var r = n - 1
    while l < r {
        var tmpAns = numbers[l] + numbers[r]
        if tmpAns == target {
            return [l + 1, r + 1]
        } else if tmpAns > target {
            r -= 1
        } else {
            l += 1
        }
    }
    return ans
}
twoSum([2, 7, 11, 15], 9)

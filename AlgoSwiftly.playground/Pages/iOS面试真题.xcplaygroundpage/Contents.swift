//: [Previous](@previous)

import Foundation
import UIKit

// 单链表定义
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() {
        self.val = 0
        self.next = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

// 树节点定义
class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
}

// 493. 翻转对
func reversePair(_ nums: [Int]) -> Int {
    var nums=nums
    return mergeSort(&nums, 0, nums.count-1)
}
//print(reversePair([1, 3, 2, 3, 1])) // 输出: 2

// 归并排序
func mergeSort(_ nums: inout [Int], _ start: Int, _ end: Int) -> Int {
    if start >= end { return 0 }
    let mid = (start + end) / 2
    var count = mergeSort(&nums, start, mid) + mergeSort(&nums, mid + 1, end)

    var j = mid + 1
    for i in start...mid {
        while j <= end && nums[i] > 2 * nums[j] {
            j += 1
        }
        count += (j - mid - 1)
        print("i=\(i), j=\(j), start=\(start), mid=\(mid), end=\(end), count=\(count), nums=\(nums)")
    }
    nums.replaceSubrange(start...end, with: (nums[start...mid].sorted() + nums[mid+1...end].sorted()))

    return count
}

func mergeSort2(_ nums: inout [Int], _ start: Int, _ end: Int) -> Int {
    if start >= end { return 0 }
    let mid = (start + end) / 2
    var count = mergeSort(&nums, start, mid) + mergeSort(&nums, mid + 1, end)

    var j = mid + 1
    for i in start...mid {
        while j <= end && nums[i] > 2 * nums[j] {
            j += 1
        }
        count += (j - mid - 1)
    }

    let left = Array(nums[start...mid])
    let right = Array(nums[mid + 1...end])
    var k = start
    var i = 0
    j = 0

    // 排序
    while i < left.count && j < right.count {
        if left[i] <= right[j] {
            nums[k] = left[i]
            i += 1
        } else {
            nums[k] = right[j]
            j += 1
        }
        k += 1
    }

    while i < left.count {
        nums[k] = left[i]
        i += 1
        k += 1
    }

    while j < right.count {
        nums[k] = right[j]
        j += 1
        k += 1
    }

    return count
}

// 测试
//var nums = [1, 3, 2, 3, 1]
//print(reversePairs(nums))  // 输出: 2
//print(nums)  // 修改后的 nums：[1, 1, 2, 3, 3]

// 25. K 个一组翻转链表
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    let dummy = ListNode(0, head)
    var len = 0
    var nxt: ListNode? = nil
    var pre: ListNode? = nil
    var cur: ListNode? = dummy.next
    var p0: ListNode? = dummy
    while cur != nil {
        len += 1
        cur = cur?.next
    }
    cur = dummy.next
    while len >= k {
        len -= k
        for _ in 0..<k {
            nxt = cur?.next
            cur?.next = pre
            pre = cur
            cur = nxt
        }
        nxt = p0?.next
        p0?.next?.next = cur
        p0?.next = pre
        p0 = nxt
    }
    return dummy.next
}

// 92. 反转链表 II
func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
    guard let head = head else { return nil }
    var dummyNode = ListNode(-1, head)
    var p0: ListNode? = dummyNode
    var pre: ListNode?
    var cur: ListNode?
    var nxt: ListNode?
    for _ in 1..<left {// p0是反转区的前一个节点，记下来连接反转的段
        p0 = p0?.next
    }
    cur = p0?.next
    pre = p0
    for _ in 1...right - left + 1 {
        nxt = cur?.next
        cur?.next = pre
        pre = cur
        cur = nxt
    }
    p0?.next?.next = cur
    p0?.next = pre
    return dummyNode.next
}

// 206. 反转链表
func reverseList(_ head: ListNode?) -> ListNode? {
    var pre: ListNode? = nil
    var cur = head
    var nxt: ListNode? = nil
    while cur != nil {
        nxt = cur?.next
        cur?.next = pre
        pre = cur
        cur = nxt
    }
    return pre
}

// 寻找2个视图最近的父视图
@MainActor
func neareatFather(_ view1: UIView?, _ view2: UIView?) -> UIView? {
    var ancestors = Set<UIView>()
    var curView: UIView? = view1
    while curView != nil {
        if let pa = curView?.superview {
            ancestors.insert(pa)
            curView = pa
        }
    }

    curView = view2
    while let view = curView {
        if ancestors.contains(view) {
            return curView
        } else {
            curView = curView?.superview
        }
    }
    return nil
}

// 倒序数组
func reverseArray(_ nums: inout [Int]) {
    nums.reverse()
}
// 测试
//var array = [1, 2, 3, 4, 5]
//reverseArray(&array)
//print(array) // 输出: [5, 4, 3, 2, 1]


// 最大子串和：找到连续子数组的最大和
func maxSubArraySum(_ nums: [Int]) -> Int {
    var maxSum = nums[0]
    var curSum = nums[0]
    for i in 1..<nums.count {
        curSum = max(nums[i], curSum + nums[i])
        maxSum = max(curSum, maxSum)
    }
    return maxSum
}
//print(maxSubArraySum([-2, 1, -3, 4, -1, 2, 1, -5, 4])) // 输出: 6

// 最大非连续子串和
func maxNonContiguousSum(_ nums: [Int]) -> Int {
    var maxNegative = nums.max()!
    var sumPositive = nums.filter { $0 > 0 }.reduce(0, +)
    return sumPositive == 0 ? maxNegative : sumPositive
}
//print(maxNonContiguousSum([-2, 1, -3, 4, -1, 2, 1, -5, 4]))  // 输出: 12

// 最长不重复子串
func lengthOfLongestSubstring2(_ s: String) -> Int {
    if s.count < 2 { return 1 }
    var charDict = [Character: Int]()
    var chars = Array(s)
    var start = 0
    var maxLength = 0
    charDict[chars[0]] = 0
    for i in 1..<s.count {
        if let preIndex = charDict[chars[i]], preIndex >= start {
            start = preIndex + 1
        }
        charDict[chars[i]] = i
        maxLength = max(maxLength, i - start + 1)
    }
    return maxLength
}
//print(lengthOfLongestSubstring2("abcabcbb"))  // 输出: 3

// 查找最长连续子串
func longestConsecutiveSubstring(_ s: String) -> Int {
    guard !s.isEmpty else { return 0 }
    var maxLen = 1
    var curLen = 1
    var chars = Array(s)
    for i in 0..<chars.count - 1 {
        if chars[i] == chars[i + 1] {
            curLen += 1
        } else {
            maxLen = max(maxLen, curLen)
            curLen = 1
        }
    }
    return maxLen
}
//print(longestConsecutiveSubstring("aaabbcccddeee")) // 输出: 3

// 旋转矩阵
func rotateMatrix(_ matrix: inout [[Int]]) {
    let n0 = matrix[0].count
    let n = matrix.count
    for i in 0..<n {
        for j in i + 1..<n {
            (matrix[i][j], matrix[j][i]) = (matrix[j][i], matrix[i][j])
        }
    }
    for i in 0..<n {
        matrix[i].reverse()
    }
}
var matrix = [
    [1, 2, 3],
    [4, 5, 6],
    [7, 8, 9],
]
//rotateMatrix(&matrix)
//print(matrix)

// 两个有序数组，寻找第K个大的数
func findKthElement(_ arr1: [Int], _ arr2: [Int], _ k: Int) -> Int {
    let n1 = arr1.count
    let n2 = arr2.count
    if n1 > n2 {
        return findKthElement(arr2, arr1, k)
    }
    if n1 == 0 {
        return arr2[k - 1]
    }
    if k == 1 {
        return min(arr1[0], arr2[0])
    }
    let pivot = min(k / 2, n1)
    var arr1Last = arr1[pivot - 1]
    var arr2Last = arr2[k - pivot - 1]
    if arr1Last < arr2Last {
        return findKthElement(Array(arr1[pivot...]), arr2, k - pivot)
    } else {
        return findKthElement(arr1, Array(arr2[pivot...]), pivot)
    }
}
let nums1 = [0, 0, 0, 0, 0, 1, 3, 5]
let nums2 = [2, 4, 6]
let k = 4
//print(findKthElement(nums1, nums2, k))  // 输出 4

// 给定两个字符串形式的非负整数，计算它们的和，以字符串形式返回
func addStrings(_ str1: String, _ str2: String) -> String {
    var chars1 = Array(str1)
    var chars2 = Array(str2)
    var res: String = ""

    var pos1 = str1.count - 1
    var pos2 = str2.count - 1
    var carry = 0

    while pos1 >= 0 || pos2 >= 0 || carry != 0 {
        let digit1 = pos1 >= 0 ? Int(String(chars1[pos1]))! : 0
        let digit2 = pos2 >= 0 ? Int(String(chars2[pos2]))! : 0
        var tmpAns = digit1 + digit2 + carry
        res.append(String(tmpAns % 10))
        carry = tmpAns / 10
        pos1 -= 1
        pos2 -= 1
    }
    return String(res.reversed())
}
//addStrings("123", "996")

// 查找字符串中的回文子串个数
func countSubHuiwen(_ str: String) -> Int {
    var count = 0
    var chars = Array(str)
    for i in 0..<str.count {
        count += testChar(chars, i, i)
        count += testChar(chars, i, i + 1)
    }
    return count

    func testChar(_ str: [Character], _ left: Int, _ right: Int) -> Int {
        var count = 0
        var l = left
        var r = right
        while l >= 0 && r < str.count && str[l] == str[r] && l != r {
            count += 1
            l -= 1
            r += 1
        }
        return count
    }
}
//countSubHuiwen("abcddcefft")

// 翻转二叉树
func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else { return nil }
    let temp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(temp)
    return root
}

//  约瑟夫环问题，朴素递推法
func josephusRound_DiTui(_ num: Int, _ m: Int) -> Int {
    var round = Array(0..<num)
    var index = 0
    while round.count>1{
        index = (index+m-1)%round.count
        round.remove(at: index)
    }
    return round[0]
}
//josephusRound_DiTui(6, 4)

//  约瑟夫环问题，公式法
func josephusUsingFoormula(_ num: Int, _ m: Int) -> Int {
    var res = 0
    for i in 2...num {
        res = (res + m) % i
    }
    return res
}
//josephusUsingFoormula(6, 4)

// 103. 二叉树的锯齿形层序遍历
func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] } //  这样一来后续的nodeQueue是非可选类型的数组了
    var ans: [[Int]] = []
    var queue: ArraySlice = [root]
    var isEvenLevel = false
    while !queue.isEmpty {
        var curVals: [Int] = []
        for _ in 0..<queue.count {
            if let item = queue.popFirst() {
                curVals.append(item.val)
                if let left = item.left { queue.append(left) }
                if let right = item.right { queue.append(right) }
            }
        }
        ans.append(isEvenLevel ? curVals.reversed() : curVals)
        isEvenLevel.toggle()
    }
    return ans
}

// 二叉搜索树寻找第K大数
func kBig(_ root: TreeNode?, _ k: Int) -> Int {
    guard let root = root else { return -1 }
    var ans: [Int] = []
    midTranverse(root)

    func midTranverse(_ root: TreeNode) {
        if let left = root.left {
            midTranverse(left)
        }
        ans.append(root.val)
        if let right = root.right {
            midTranverse(right)
        }
    }
    return ans[k-1]
}
//kBig(root, 5) // 需提供根节点再运行

// 1. 两数之和
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var numMap = [Int: Int]()
    for (index, val) in nums.enumerated() {
        var complement = target - val
        if let complementIndex = numMap[complement] {
            return [complementIndex, index]
        }
        numMap[val] = index
    }
    return []
}
//twoSum([2, 6, 7, 9, 9], 10)

// 求k数，找到数组中满足：左侧元素都小于它，右侧都大于它的元素
let knums = [1, 3, 2, 4, 5, 6]
func findKNumbers(_ nums: [Int]) -> [Int] {
    let n = nums.count
    var leftMax = Array(repeating: Int.min, count: n)
    var rightMin = Array(repeating: Int.max, count: n)
    var ans: [Int] = []
    for i in 1..<n {
        leftMax[i] = max(leftMax[i - 1], nums[i])
    }
    for i in (0..<n - 1).reversed() {
        rightMin[i] = min(rightMin[i + 1], nums[i])
    }
    for i in 1..<n - 1 {
        if leftMax[i] <= nums[i] && rightMin[i] >= nums[i] {
            ans.append(nums[i])
        }
    }
    return ans
}
//findKNumbers(knums)

// 141. 环形链表
func hasCycle(_ head: ListNode?) -> Bool {
    var fast = head
    var slow = head
    while (fast != nil) && ((fast?.next) != nil) {
        slow = slow?.next
        fast = fast?.next?.next
        if fast === slow {
            return true
        }
    }
    return false
}

// 斐波那契，递归
func fibcache(_ n: Int) {
    var cache = [Int: Int]()

    func fibonacci(_ n: Int) -> Int {
        if let result = cache[n] {
            return result
        }
        if n < 2 {
            return n
        }
        let result = fibonacci(n - 1) + fibonacci(n - 2)
        cache[n] = result
        return result
    }
    fibonacci(n)
}

// 字符串反转
func reverseStr(_ str: String) -> String {
    return String(str.reversed())
}

// 字符串回文
func strhuiwen(_ str: String) -> Bool {
    var chars = Array(str)
    var n = str.count
    for i in 0..<n / 2 {
        if chars[i] != chars[n - i + 1] {
            return false
        }
    }
    return true
}

// 二分查找
func binarySearch(_ nums: [Int], _ target: Int) -> Int {
    var low = 0
    var high = nums.count - 1
    var mid: Int
    while low <= high {
        mid = (low + high) / 2
        if nums[mid] == target {
            return mid
        } else if nums[mid] < target {
            low = mid + 1
        } else {
            high = mid - 1
        }
    }
    return -1
}
//erfenchazhao([1, 3, 5, 7, 9], 5)

// 合并有序数组
func conbineArrs(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    var p1 = 0
    var p2 = 0
    var ans: [Int] = []
    while p1 < arr1.count && p2 < arr2.count {
        if arr1[p1] < arr2[p2] {
            ans.append(arr1[p1])
            p1 += 1
        } else {
            ans.append(arr2[p2])
            p2 += 1
        }
    }
    while p2 < arr2.count {
        ans.append(arr2[p2])
        p2 += 1
    }
    while p1 < arr1.count {
        ans.append(arr1[p1])
    }
    return ans
}

func combineArrs2(_ arr1: [Int], _ arr2: [Int]) -> [Int] {
    return (arr1 + arr2).sorted()
}

func combineArrs3(_ arr1: inout [Int], _ arr2: [Int]) -> [Int] {
    var i = arr1.count
    var j = arr2.count
    var k = i + j - 1
    arr1 += Array(repeating: 0, count: j)
    while j >= 0 {
        if i >= 0 && arr1[i] > arr2[j] {
            arr1[k] = arr1[i]
            i -= 1
        } else {
            arr1[k] = arr2[j]
            j -= 1
        }
        k -= 1
    }
    return arr1
}

// 快速排序
func qs<T: Comparable>(_ array: [T]) -> [T] {
    guard array.count > 1 else {
        return array
    }

    let pivot = array[array.count / 2]
    let left = array.filter { $0 < pivot }
    let right = array.filter { $0 > pivot }
    let middle = array.filter { $0 == pivot }
    return qs(left) + middle + qs(right)
}

// 冒泡排序
func bbs<T: Comparable>(_ array: [T]) -> [T] {
    var arr = array
    let count = arr.count
    for i in 0..<count {
        for j in 1..<count - i {
            if arr[j - 1] > arr[j] {
                arr.swapAt(j - 1, j)
            }
        }
    }
    return arr
}

// 41.缺失的第一个正整数，但不要求O(1)空间复杂度
// 小红书真题
func minPositive(_ nums: [Int]) -> Int {
    var n = nums.count
    var dict = Array(repeating: false, count: n + 1)
    dict[0] = true
    for i in 0..<n {
        if nums[i] < n && nums[i] > 0{
            dict[nums[i]] = true
        }
    }
    for (index, i) in dict.enumerated() {
        if i == false {
            return index
        }
    }
    return n + 1
}
//minPositive([3,4,-1,-1])

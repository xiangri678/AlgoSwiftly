import Foundation

// 自定义cache修饰器
class custonCache<Key: Hashable, Value> {
    private var storage: [Key: Value] = [:]
    func value(for key: Key, compute: () -> Value) -> Value {
        if let cached = storage[key] {
            return cached
        }
        let newValue = compute()
        storage[key] = newValue
        return newValue
    }
}

// 198. 打家劫舍
var money = [1, 2, 3, 1]
// V0:回溯法，会超时
func rob_recursion(_ nums: [Int]) -> Int {
    func dfs(_ i: Int) -> Int {
        if i < 0 { return 0 }  // 归
        return max(dfs(i - 1), dfs(i - 2) + nums[i])  // 递
    }
    return dfs(nums.count - 1)
}
//rob_recursion(money)

// V1:记忆化搜索，仍然是自顶向下算，但是用一个cache数组记录已求过的节点，取消重复计算。每个节点只算一次，故O(n)
func rob_cacheSearch(_ nums: [Int]) -> Int {
    var len = nums.count
    var cache = Array(repeating: -1, count: len)  // 数组的构造器的写法
    func dfs(_ i: Int) -> Int {
        if i < 0 {  // 归
            return 0
        }
        if cache[i] != -1 {  // 查缓存
            return cache[i]
        }
        var res = max(dfs(i - 2) + nums[i], dfs(i - 1))  // 递
        cache[i] = res  // 存缓存
        return res
    }
    return dfs(len - 1)
}
//rob_cacheSearch(money)

// V2:递推，因为已知哪些节点要递归到哪个节点，所以无需真的递归，而是可以直接自底向上计算
// 实操:把dfs改成数组、把递归改成循环
func rob_recurrence(_ nums: [Int]) -> Int {
    var n = nums.count
    var f = Array(repeating: 0, count: n + 2)  // 数组记录各轮的值
    for (i, x) in nums.enumerated() {
        f[i + 2] = max(f[i + 1], f[i] + x)
    }
    return f[n + 1]
}
//rob_recurrence(money)

// V3:递推，因为计算每个节点值的时候只需要知道它的上一个节点和上上一个节点的值，所以无需开个数组存以前所有值，用3个遍历即可解决问题！空间复杂度从O(n)降到O(1).
func rob_O1(_ nums: [Int]) -> Int {
    var ppre = 0  // 上上一个节点的值
    var pre = 0  // 上一个节点的值
    var new_f = 0  // 当前值
    for i in nums {  // 语法问题：i是nums[i]啊！如果写成0..<nums.count，for内部需要写nums[i]
        new_f = max(ppre + i, pre)
        ppre = pre
        pre = new_f
    }
    return pre
}
//rob_O1(money)

// 0-1背包
func zero_one_pack(capacity: Int, w: [Int], v: [Int]) -> Int {
    var n = w.count
    var cache: [[Int]] = Array(
        repeating: Array(repeating: -1, count: capacity), count: n)
    func dfs(_ i: Int, _ c: Int) -> Int {
        if i < 0 {
            return 0
        }
        if c < w[i] {
            if cache[i - 1][c] == -1 {
                cache[i - 1][c] = dfs(i - 1, c)
            }
            return cache[i - 1][c]
        }
        return max(dfs(i - 1, c), dfs(i - 1, c - w[i]) + v[i])
    }
    return dfs(n - 1, capacity)
}

// 494. 目标和 递归
func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
    var t = target + nums.reduce(0, +)  // 求结果的数学公式
    if t % 2 != 0 || t < 0 {  // 首先排除非法情况
        return 0
    }
    t /= 2
    func dfs(i: Int, c: Int) -> Int {
        if i < 0 {  // 归
            if c == 0 {
                return 1  // 说明这条路合法，方案数+1
            } else {
                return 0  // 这条路不合法，方案数不变
            }
        }
        if c < nums[i] {  // 递
            return dfs(i: i - 1, c: c)
        } else {
            return dfs(i: i - 1, c: c - nums[i]) + dfs(i: i - 1, c: c)
        }
    }
    return dfs(i: nums.count - 1, c: t)
}

// 464.V2 递推
func findTargetSumWays2(_ nums: [Int], _ target: Int) -> Int {
    var t = target + nums.reduce(0, +)
    if t % 2 != 0 || t < 0 {
        return 0
    }
    t /= 2
    var f: [[Int]] = Array(
        repeating: Array(repeating: 0, count: nums.count), count: t)
    for i in nums {
        for c in 0...target {
            if c < nums[i] {
                f[i + 1][c] = f[i][c]
            } else {
                f[i + 1][c] = f[i][c] + f[i][c - nums[i]]
            }
        }
    }
    return f[nums.count][t]
}
//findTargetSumWays([1], 1)

// 464. V3 递推，优化为只用2个数组的空间
func findTargetSumWays3(_ nums: [Int], _ target: Int) -> Int {
    var t = target + nums.reduce(0, +)
    var n = nums.count
    if t % 2 != 0 || t < 0 {
        return 0
    }
    t /= 2
    var f = Array(repeating: Array(repeating: 0, count: n), count: 2)
    for i in nums {
        for c in 0...target {
            if c < nums[i] {
                f[(i + 1) % 2][c] = f[i % 2][c]
            } else {
                f[(i + 1) % 2][c] = f[i % 2][c] + f[i % 2][c - nums[i]]
            }
        }
    }
    return f[n][target]
}
findTargetSumWays3([1, 1, 1, 1, 1], 3)

// 464. V4 递推，优化为只用1个数组的空间,倒退
func findTargetSumWays4(_ nums: [Int], _ target: Int) -> Int {
    var t = target + nums.reduce(0, +)
    var n = nums.count
    if t % 2 != 0 || t < 0 {
        return 0
    }
    t /= 2
    var f = Array(repeating: 0, count: 2)
    for num in nums {
        for c in (target...num - 1).reversed() {
            f[c] = f[c] + f[c - num]
        }
    }
    return f[target]
}
findTargetSumWays4([1, 1, 1, 1, 1], 3)

// 1143. 最长公共子序列V0
func longestCommonSubsequence(_ text1: String, _ text2: String) -> Int {
    var s = Array(text1)
    var t = Array(text2)
    func dfs(i: Int, j: Int) -> Int {
        if i < 0 || j < 0 {
            return 0
        }
        if s[i] == t[j] {
            return dfs(i: i - 1, j: j - 1) + 1
        } else {
            return max(dfs(i: i, j: j - 1), dfs(i: i - 1, j: j))
        }
    }
    return dfs(i: s.count - 1, j: t.count - 1)
}

// 1143.V1
func longestCommonSubsequence2(_ text1: String, _ text2: String) -> Int {
    var s = Array(text1)
    var t = Array(text2)
    var sLen = s.count
    var tLen = t.count
    var f = Array(
        repeating: Array(repeating: 0, count: tLen + 1), count: sLen + 1)  // 记住全为0的空二维数组的创建方法
    for i in 0..<sLen {
        for j in 0..<tLen {
            if s[i] == t[j] {
                f[i + 1][j + 1] = f[i][j] + 1
            } else {
                f[i + 1][j + 1] = max(f[i][j + 1], f[i + 1][j])
            }
        }
    }
    return f[sLen][tLen]
}

// 1143.V2

// 122. 买卖股票的最佳时机 II(无限次，无冷冻期)
var prices = [7, 1, 5, 3, 6, 4]
// V0 递归版
func maxProfit_recursion(_ prices: [Int]) -> Int {
    var n = prices.count
    func dfs(_ i: Int, _ hold: Bool) -> Int {
        if i < 0 {  // 归，最开始如果持有股票非法，所以返回 Int.min ，在后期max函数筛选时就自动去掉了
            return hold ? Int.min : 0
        }
        return hold
            ? max(dfs(i - 1, true), dfs(i - 1, false) - prices[i])
            : max(dfs(i - 1, false), dfs(i - 1, true) + prices[i])  // 递
    }
    return dfs(n - 1, false)  // 从后往前推
}
//maxProfit_recursion(prices)

// V1 递推版
func maxProfit_recurrence(_ prices: [Int]) -> Int {
    var n = prices.count
    var cache = Array(repeating: Array(repeating: 0, count: 2), count: n + 1)  // 用二维数组存储所有状态，这肯定比递归来的快、内存小
    cache[0][1] = Int.min  // 最开始如果持有股票非法，所以设为 Int.min ，在后期max函数筛选时就自动去掉了
    for (i, price) in prices.enumerated() {  // 从前往后遍历
        cache[i + 1][0] = max(cache[i][0], cache[i][1] + price)
        cache[i + 1][1] = max(cache[i][1], cache[i][0] - price)
    }
    return cache[n][0]
}
//maxProfit_recurrence(prices)

// V2 优化空间至O(1)
// 因为计算cache[i+1]只会用到cache[i]，所以优化为只使用2个变量
func maxProfit_O1(_ prices: [Int]) -> Int {
    var pre = Int.min  // cache[i+1]
    var ppre = 0  // cache[i]
    var cur = 0  // 临时变量，否则算的时候把值冲掉了算不了结果
    for price in prices {
        cur = max(ppre, pre + price)
        pre = max(pre, ppre - price)
        ppre = cur
    }
    return cur
}
//maxProfit_O1(prices)

// 309. 买卖股票的最佳时机含冷冻期
// LC方法名仍为 maxProfit
// V0 递归法：可通过208/210,最后2个超时
func maxProfit_froze_recursion(_ prices: [Int]) -> Int {
    var n = prices.count
    func dfs(_ i: Int, _ hold: Bool) -> Int {
        if i < 0 {
            return hold ? Int.min : 0
        }
        return hold
            ? max(dfs(i - 1, true), dfs(i - 2, false) - prices[i])
            : max(dfs(i - 1, false), dfs(i - 1, true) + prices[i])
    }
    return dfs(n - 1, false)
}
maxProfit_froze_recursion([
    70, 4, 83, 56, 94, 72, 78, 43, 2, 86, 65, 100, 94, 56, 41, 66, 3, 33, 10, 3,
    45, 94, 15, 12, 78, 60, 58, 0, 58, 15, 21, 7, 11, 41, 12, 96, 83, 77, 47,
    62, 27, 19, 40, 63, 30, 4, 77, 52, 17, 57, 21, 66, 63, 29, 51, 40, 37, 6,
    44, 42, 92, 16, 64, 33, 31, 51, 36, 0, 29, 95, 92, 35, 66, 91, 19, 21, 100,
    95, 40, 61, 15, 83, 31, 55, 59, 84, 21, 99, 45, 64, 90, 25, 40, 6, 41, 5,
    25, 52, 59, 61, 51, 37, 92, 90, 20, 20, 96, 66, 79, 28, 83, 60, 91, 30, 52,
    55, 1, 99, 8, 68, 14, 84, 59, 5, 34, 93, 25, 10, 93, 21, 35, 66, 88, 20, 97,
    25, 63, 80, 20, 86, 33, 53, 43, 86, 53, 55, 61, 77, 9, 2, 56, 78, 43, 19,
    68, 69, 49, 1, 6, 5, 82, 46, 24, 33, 85, 24, 56, 51, 45, 100, 94, 26, 15,
    33, 35, 59, 25, 65, 32, 26, 93, 73, 0, 40, 92, 56, 76, 18, 2, 45, 64, 66,
    64, 39, 77, 1, 55, 90, 10, 27, 85, 40, 95, 78, 39, 40, 62, 30, 12, 57, 84,
    95, 86, 57, 41, 52, 77, 17, 9, 15, 33, 17, 68, 63, 59, 40, 5, 63, 30, 86,
    57, 5, 55, 47, 0, 92, 95, 100, 25, 79, 84, 93, 83, 93, 18, 20, 32, 63, 65,
    56, 68, 7, 31, 100, 88, 93, 11, 43, 20, 13, 54, 34, 29, 90, 50, 24, 13, 44,
    89, 57, 65, 95, 58, 32, 67, 38, 2, 41, 4, 63, 56, 88, 39, 57, 10, 1, 97, 98,
    25, 45, 96, 35, 22, 0, 37, 74, 98, 14, 37, 77, 54, 40, 17, 9, 28, 83, 13,
    92, 3, 8, 60, 52, 64, 8, 87, 77, 96, 70, 61, 3, 96, 83, 56, 5, 99, 81, 94,
    3, 38, 91, 55, 83, 15, 30, 39, 54, 79, 55, 86, 85, 32, 27, 20, 74, 91, 99,
    100, 46, 69, 77, 34, 97, 0, 50, 51, 21, 12, 3, 84, 84, 48, 69, 94, 28, 64,
    36, 70, 34, 70, 11, 89, 58, 6, 90, 86, 4, 97, 63, 10, 37, 48, 68, 30, 29,
    53, 4, 91, 7, 56, 63, 22, 93, 69, 93, 1, 85, 11, 20, 41, 36, 66, 67, 57, 76,
    85, 37, 80, 99, 63, 23, 71, 11, 73, 41, 48, 54, 61, 49, 91, 97, 60, 38, 99,
    8, 17, 2, 5, 56, 3, 69, 90, 62, 75, 76, 55, 71, 83, 34, 2, 36, 56, 40, 15,
    62, 39, 78, 7, 37, 58, 22, 64, 59, 80, 16, 2, 34, 83, 43, 40, 39, 38, 35,
    89, 72, 56, 77, 78, 14, 45, 0, 57, 32, 82, 93, 96, 3, 51, 27, 36, 38, 1, 19,
    66, 98, 93, 91, 18, 95, 93, 39, 12, 40, 73, 100, 17, 72, 93, 25, 35, 45, 91,
    78, 13, 97, 56, 40, 69, 86, 69, 99, 4, 36, 36, 82, 35, 52, 12, 46, 74, 57,
    65, 91, 51, 41, 42, 17, 78, 49, 75, 9, 23, 65, 44, 47, 93, 84, 70, 19, 22,
    57, 27, 84, 57, 85, 2, 61, 17, 90, 34, 49, 74, 64, 46, 61, 0, 28, 57, 78,
    75, 31, 27, 24, 10, 93, 34, 19, 75, 53, 17, 26, 2, 41, 89, 79, 37, 14, 93,
    55, 74, 11, 77, 60, 61, 2, 68, 0, 15, 12, 47, 12, 48, 57, 73, 17, 18, 11,
    83, 38, 5, 36, 53, 94, 40, 48, 81, 53, 32, 53, 12, 21, 90, 100, 32, 29, 94,
    92, 83, 80, 36, 73, 59, 61, 43, 100, 36, 71, 89, 9, 24, 56, 7, 48, 34, 58,
    0, 43, 34, 18, 1, 29, 97, 70, 92, 88, 0, 48, 51, 53, 0, 50, 21, 91, 23, 34,
    49, 19, 17, 9, 23, 43, 87, 72, 39, 17, 17, 97, 14, 29, 4, 10, 84, 10, 33,
    100, 86, 43, 20, 22, 58, 90, 70, 48, 23, 75, 4, 66, 97, 95, 1, 80, 24, 43,
    97, 15, 38, 53, 55, 86, 63, 40, 7, 26, 60, 95, 12, 98, 15, 95, 71, 86, 46,
    33, 68, 32, 86, 89, 18, 88, 97, 32, 42, 5, 57, 13, 1, 23, 34, 37, 13, 65,
    13, 47, 55, 85, 37, 57, 14, 89, 94, 57, 13, 6, 98, 47, 52, 51, 19, 99, 42,
    1, 19, 74, 60, 8, 48, 28, 65, 6, 12, 57, 49, 27, 95, 1, 2, 10, 25, 49, 68,
    57, 32, 99, 24, 19, 25, 32, 89, 88, 73, 96, 57, 14, 65, 34, 8, 82, 9, 94,
    91, 19, 53, 61, 70, 54, 4, 66, 26, 8, 63, 62, 9, 20, 42, 17, 52, 97, 51, 53,
    19, 48, 76, 40, 80, 6, 1, 89, 52, 70, 38, 95, 62, 24, 88, 64, 42, 61, 6, 50,
    91, 87, 69, 13, 58, 43, 98, 19, 94, 65, 56, 72, 20, 72, 92, 85, 58, 46, 67,
    2, 23, 88, 58, 25, 88, 18, 92, 46, 15, 18, 37, 9, 90, 2, 38, 0, 16, 86, 44,
    69, 71, 70, 30, 38, 17, 69, 69, 80, 73, 79, 56, 17, 95, 12, 37, 43, 5, 5, 6,
    42, 16, 44, 22, 62, 37, 86, 8, 51, 73, 46, 44, 15, 98, 54, 22, 47, 28, 11,
    75, 52, 49, 38, 84, 55, 3, 69, 100, 54, 66, 6, 23, 98, 22, 99, 21, 74, 75,
    33, 67, 8, 80, 90, 23, 46, 93, 69, 85, 46, 87, 76, 93, 38, 77, 37, 72, 35,
    3, 82, 11, 67, 46, 53, 29, 60, 33, 12, 62, 23, 27, 72, 35, 63, 68, 14, 35,
    27, 98, 94, 65, 3, 13, 48, 83, 27, 84, 86, 49, 31, 63, 40, 12, 34, 79, 61,
    47, 29, 33, 52, 100, 85, 38, 24, 1, 16, 62, 89, 36, 74, 9, 49, 62, 89,
])

// TODO:这个写法不对，请参照打家劫舍的思路再想一下，因为中途需要跳过一天
func maxProfit_froze_recurrence(_ prices: [Int]) -> Int {
    var n = prices.count
    var cache = Array(repeating: Array(repeating: 0, count: n + 1), count: 2)
    cache[0][1] = Int.min
    for (i, price) in prices.enumerated() {
        cache[i + 1][0] = max(cache[i][0], cache[i][1] - prices[i])
        cache[i + 1][1] = max(cache[i][1], cache[i][0] + prices[i])
    }
    return cache[n][0]
}

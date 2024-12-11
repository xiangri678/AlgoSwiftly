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
var money = [1,2,3,1]
// V0:回溯法，会超时
func rob_HuiSu(_ nums: [Int]) -> Int {
    func dfs(_ i: Int) -> Int {
        if i < 0 { return 0 }  // 归
        return max(dfs(i - 1), dfs(i - 2) + nums[i])  // 递
    }
    return dfs(nums.count - 1)
}
rob_HuiSu(money)

// V1:记忆化搜索，仍然是自顶向下算，但是用一个cache数组记录已求过的节点，取消重复计算。每个节点只算一次，故O(n)
func rob_cacheSearch(_ nums: [Int]) -> Int {
    var len = nums.count
    var cache = Array(repeating: -1, count: len)  // 数组的构造器的写法
    func dfs(_ i: Int) -> Int {
        if i < 0 { // 归
            return 0
        }
        if cache[i] != -1 { // 查缓存
            return cache[i]
        }
        var res = max(dfs(i - 2) + nums[i], dfs(i - 1)) // 递
        cache[i] = res // 存缓存
        return res
    }
    return dfs(len - 1)
}
rob_cacheSearch(money)

// V2:递推，因为已知哪些节点要递归到哪个节点，所以无需真的递归，而是可以直接自底向上计算
// 实操:把dfs改成数组、把递归改成循环
func rob_DiTui(_ nums: [Int]) -> Int {
    var n = nums.count
    var f = Array(repeating: 0, count: n + 2) // 数组记录各轮的值
    for (i, x) in nums.enumerated() {
        f[i + 2] = max(f[i + 1], f[i] + x)
    }
    return f[n + 1]
}
rob_DiTui(money)

// V3:递推，因为计算每个节点值的时候只需要知道它的上一个节点和上上一个节点的值，所以无需开个数组存以前所有值，用3个遍历即可解决问题！空间复杂度从O(n)降到O(1).
func rob_O1(_ nums: [Int]) -> Int {
    var ppre = 0 // 上上一个节点的值
    var pre = 0 // 上一个节点的值
    var new_f = 0 // 当前值
    for i in nums { // 语法问题：i是nums[i]啊！如果写成0..<nums.count，for内部需要写nums[i]
        new_f = max(ppre + i, pre)
        ppre = pre
        pre = new_f
    }
    return pre
}
rob_O1(money)

// 0-1背包
func zero_one_pack(capacity: Int, w: [Int], v: [Int]) -> Int {
    var n = w.count
    var cache:[[Int]] = Array(repeating: Array(repeating: -1, count: capacity), count: n)
    func dfs(_ i: Int, _ c: Int) -> Int {
        if i < 0 {
            return 0
        }
        if c < w[i] {
            if cache[i-1][c] == -1 {
                cache[i-1][c] = dfs(i - 1, c)
            }
            return cache[i-1][c]
        }
        return max(dfs(i - 1, c), dfs(i - 1, c - w[i]) + v[i])
    }
    return dfs(n - 1, capacity)
}

// 494. 目标和 递归
func findTargetSumWays(_ nums: [Int], _ target: Int) -> Int {
    var t = target + nums.reduce(0, +) // 求结果的数学公式
    if t % 2 != 0 || t < 0 { // 首先排除非法情况
        return 0
    }
    t /= 2
    func dfs(i: Int, c: Int) -> Int {
        if i < 0 { // 归
            if c == 0 {
                return 1  // 说明这条路合法，方案数+1
            } else {
                return 0  // 这条路不合法，方案数不变
            }
        }
        if c < nums[i] { // 递
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

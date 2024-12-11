// 52. N 皇后 II
func totalNQueens(_ n: Int) -> Int {
    var ans = 0
    var onPath = Array(repeating: false, count: n)
    var diag1 = Array(repeating: false, count: 2 * n - 1)
    var diag2 = Array(repeating: false, count: 2 * n - 1)

    func dfs(_ r: Int) {
        if r == n {
            ans += 1
            return
        }
        for c in 0..<n {
            if !onPath[c] && !diag1[r + c] && !diag2[r - c + n - 1] {
                onPath[c] = true
                diag1[r + c] = true
                diag2[r - c + n - 1] = true
                dfs(r + 1)
                onPath[c] = false
                diag1[r + c] = false
                diag2[r - c + n - 1] = false
            }
        }
    }
    dfs(0)
    return ans
}
totalNQueens(4)

// 51. N 皇后
func solveNQueens(_ n: Int) -> [[String]] {
    var ans: [[String]] = []
    var cols = Array(repeating: -1, count: n)  // 记录i列放在第几行
    func valid(_ r: Int, _ c: Int) -> Bool {  // 这个函数确保不能同对角线
        for R in 0..<r {
            var C = cols[R]
            if r + c == R + C || r - c == R - C {
                return false
            }
        }
        return true
    }
    func dfs(_ r: Int, _ s: Set<Int>) {
        if r == n {  // 归，输出结果
            var curAns: [String] = []
            for i in 0..<n {
                var row =
                    String(repeating: ".", count: cols[i])  // 字符串构造器的写法，并且字符串可以直接 +
                    + "Q"
                    + String(repeating: ".", count: n - cols[i] - 1)
                curAns.append(row)
            }
            ans.append(curAns)
            return
        }
        for c in s {  // 递，遍历集合s中的列
            if valid(r, c) {
                cols[r] = c
                var s = s
                s.remove(c)  // 每次递归调用前去掉已选的列，所以不会同列
                dfs(r + 1, s)  // 每次递归调用r+1,所以不会同行
                cols[r] = -1  // 恢复现场
                s.insert(c)
            }
        }
    }
    dfs(0, Set(0..<n))
    return ans
}
print(solveNQueens(4))

// 46. 全排列：法2
func permute2(_ nums: [Int]) -> [[Int]] {
    var n = nums.count
    var ans: [[Int]] = []
    var path: [Int] = []
    var onPath = Array(repeating: false, count: n)  // 记录是否已选
    func dfs(_ i: Int) {
        if i == n {  // 归
            ans.append(path)
            return
        }
        for j in 0..<n {  // 递，全排列所以每个数字都试一下
            if !onPath[j] {  // 不在路径上，加入路径试一下
                path.append(nums[j])
                onPath[j] = true
                dfs(i + 1)
                onPath[j] = false
                path.popLast()
            }
        }
    }
    dfs(0)
    return ans
}
//print(permute2([1, 2, 3]))

// 46. 全排列：法1
func permute(_ nums: [Int]) -> [[Int]] {
    var ans: [[Int]] = []
    var s = Set(nums)  // 记录未选节点
    var path: [Int] = []

    func dfs(_ i: Int, _ s: Set<Int>) {
        var s = s
        if i == nums.count {  // 归
            ans.append(path)
            return
        }
        for x in s {  // 递-第i个位置依次摆放所有元素，即不同顺序都要走一次
            path.append(x)
            s.remove(x)
            dfs(i + 1, s)
            s.insert(x)  // 恢复现场
            path.popLast()
        }
    }
    dfs(0, s)
    return ans
}
//print(permute([1, 2, 3]))

// 22. 括号生成 O(n*C(2n,n)),Catalan
func generateParenthesis(_ n: Int) -> [String] {
    var ans: [String] = []
    var path = ""
    var open = 0  // 左括号的个数
    var m = 2 * n  // 左右括号的总数
    func dfs(_ i: Int, _ open: Int) {
        if i == m {
            ans.append(path)
            return
        }
        if open < n {
            path.append("(")
            dfs(i + 1, open + 1)
            path.popLast()
        }
        if i - open < open {
            path.append(")")
            dfs(i + 1, open)
            path.popLast()
        }
    }
    dfs(0, 0)
    return ans
}
//generateParenthesis(3)

// 216. 组合总和 III, k个数，目标和n
func combinationSum3(_ k: Int, _ n: Int) -> [[Int]] {
    var ans: [[Int]] = []
    var path: [Int] = []

    func dfs(_ i: Int, _ target: Int) {
        var d = k - path.count  // 目前的空位数
        if target < 0 || target > (i * 2 - d + 1) * d / 2 { return }  // 和超过目标值了、现有最大结果也达不到目标值，剪枝
        if path.count == k {  // 归-target 大或小均已剪枝，走到这儿的都是刚好==target的
            ans.append(path)
            return
        }
        for j in (d...i).reversed() {  // 递-加上这个数，然后再向前递归
            //        for j in stride(from: i, through: d, by: -1) {  // 这句和上一行的效果等价
            path.append(j)
            print("path \(path)  i \(i)  d \(d)")
            dfs(j - 1, target - j)
            path.popLast()
        }
    }
    dfs(9, n)  // 从大到小遍历，传入的i是当前要选还没选的数
    return ans
}
//print(combinationSum3(3, 7))

// 77. 组合
func combine(_ n: Int, _ k: Int) -> [[Int]] {
    var ans: [[Int]] = []
    var path: [Int] = []
    func dfs(_ i: Int) {
        var d = k - path.count  // 剩余长度
        if i < d {  // 剩余数字个数不足以选够k个，剪枝
            return
        }
        if path.count == k {  // 归
            ans.append(path)
            return
        }
        for j in (d...i).reversed() {  // 递
            path.append(j)
            dfs(j - 1)
            path.popLast()
        }
    }
    dfs(n)  //从后往前选
    return ans
}
//print(combine(4, 2))

// 131. 分割回文串
func partition(_ s: String) -> [[String]] {
    let len = s.count
    var ans: [[String]] = []
    var path: [String] = []
    func dfs(i: Int) {
        if i == len {  // 归
            ans.append(path)
            return
        }
        for j in i..<len {  // 递
            var startIndex = s.index(s.startIndex, offsetBy: i)
            var endIndex = s.index(s.startIndex, offsetBy: j + 1)
            var temStr: String = String(s[startIndex..<endIndex])
            if temStr == String(temStr.reversed()) {  // 如果这个子串满足回文，再往后走
                path.append(temStr)
                dfs(i: j + 1)
                path.popLast()
            }
        }
    }
    dfs(i: 0)
    return ans
}

// 78. 子集
// 法2:输出角度考虑，每轮必增一个元素
//let nums = [1, 2, 3]
func subsets_2(_ nums: [Int]) -> [[Int]] {
    var ans: [[Int]] = []
    var numCount = nums.count
    var path: [Int] = []
    func dfs(i: Int) {
        // 递归走到的任意长度都可以作为答案，所以每轮都应该append
        ans.append(path)

        // 归-边界条件：i == n，表示已经走完[0, n-1]的n轮，应该停止了。
        // 下面循环写了i~n-1，所以到n-1能够自动停止而不越界，不用写特殊判断和return
        // if i == numCount { return }

        // 递-选or不选
        // 不考虑顺序，所以只考虑i后续的元素，否则重复，如[1,2]、[2,1]
        for j in i..<numCount {
            path.append(nums[j])
            dfs(i: j + 1)
            path.popLast()
        }
    }
    dfs(i: 0)
    return ans
}

// 78. 子集
// 法1:输入角度考虑
func subsets(_ nums: [Int]) -> [[Int]] {
    var ans: [[Int]] = []
    var numCount = nums.count
    var path: [Int] = []
    func dfs(i: Int) {
        // 边界条件：i == n，表示已经走完[0, n-1]的n轮，应该停止了
        if i == numCount {
            ans.append(path)
            return
        }
        // 递的2个case，依次做：
        // case1:不选i号，直接跳到i + 1号
        dfs(i: i + 1)
        // case2:选i号，再走i + 1号
        path.append(nums[i])
        dfs(i: i + 1)
        // 弹出刚才所选，恢复现场
        path.popLast()
    }
    dfs(i: 0)
    return ans
}

// 17. 电话号码的字母组合 Tn = O(n*4^n) 长度n，最多4个字母
let MAPPING = [
    "", "", "abc", "def", "ghi", "jkl", "mno", "pqrs", "tuv", "wxyz",
]  // 数字位置和数组下标相同
func letterCombinations(_ digits: String) -> [String] {
    // 获取长度
    var len = digits.count
    if len == 0 { return [] }

    var numbers = Array(digits)
    var ans: [String] = []  // 存储最终所有串
    var path = Array(repeating: "", count: len)  // 记录本轮获得的串
    func dfs(i: Int) {
        // 边界条件
        if i == len {
            var str = ""
            for c in path {
                str.append(c)
            }
            ans.append(str)
            return
        }
        // 非边界条件
        if let index = numbers[i].wholeNumberValue {
            var chars = Array(MAPPING[index])
            for c in chars {
                path[i] = String(c)
                dfs(i: i + 1)
            }
        }
    }
    dfs(i: 0)  //递归入口，从头开始枚举
    return ans
}

//letterCombinations("23")

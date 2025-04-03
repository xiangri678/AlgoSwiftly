// 739. 每日温度
// 法 1：逆序遍历
func dailyTemperatures_reverse_ordered(_ temperatures: [Int]) -> [Int] {
    let len = temperatures.count
    var ans = Array(repeating: 0, count: len)  // 记录每一天的下一个更高温日还有几天
    var stack = [Int]()  // 单调栈，记录满足温度递减的日期的序号（不记录温度）
    for i in (0..<len).reversed() {
        var t = temperatures[i]
        while !stack.isEmpty && t >= temperatures[stack.last!] {
            stack.removeLast()
        }
        if !stack.isEmpty {
            ans[i] = stack.last! - i
        }
        stack.append(i)
        print(stack)
    }
    return ans
}
// 法 2：顺序遍历
func dailyTemperatures_ordered(_ temperatures: [Int]) -> [Int] {
    let len = temperatures.count
    var ans = Array(repeating: 0, count: len)
    var stack = [Int]()
    for (i, t) in temperatures.enumerated() {
        while !stack.isEmpty && t > temperatures[stack.last!] {
            let j = stack.removeLast()
            ans[j] = i - j  // 找到了更大的下家，因此出栈并且记录答案
        }
        stack.append(i)  // 没有找到更大的下家，因此暂时入栈
    }
    return ans
}
// print(dailyTemperatures_ordered([1, 4, 3, 5, 5, 2, 3, 6]))

// 42. 接雨水
func trap(_ height: [Int]) -> Int {
     var ans = 0
    var stack = [Int]()
    for (i, h) in height.enumerated() {
        while !stack.isEmpty && h >= height[stack.last!] {
            let bottom_h = height[stack.removeLast()] // 刚刚弹出的元素，即本次的水桶底
            if stack.isEmpty {
                break // 因为 2 个山峰中间才能接水，当前只找到一个山峰的话暂时无法接水，继续寻找新高
            }
            let left = stack.last! // 当前栈的最后一个元素，即本次的水桶左边
            let dh = min(height[left], h) - bottom_h // 本次的水桶高度
            let dw = i - left - 1 // 本次的水桶宽度
            print("dh: \(dh), dw: \(dw)")
            ans += dh * dw // 本次新增的容积
        }
        stack.append(i)
        print(stack)
    }
    return ans
}
// print(trap([5,2,1,0,4,1,1,6]))

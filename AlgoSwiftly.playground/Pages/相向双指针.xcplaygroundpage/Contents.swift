//
//  相向双指针
//  本文档正序，从前往后看
//
//  Created by xiangri678 on 12/10/24.
//

// 167. 两数之和 II - 输入有序数组
func twoSum(_ numbers: [Int], _ target: Int) -> [Int] {
    var ans: [Int] = []
    var n = numbers.count
    var l = 0
    var r = n - 1
    while l < r {
        var tmpAns = numbers[l] + numbers[r]
        // l、r双指针，和小了左边的右移；和大了右边的左移
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
//twoSum([2, 7, 11, 15], 9)

// 15. 三数之和 TO(n^2), SO(n)
func threeSum(_ nums: [Int]) -> [[Int]] {
    var nums = nums.sorted()
    var ans: [[Int]] = []
    var n = nums.count
    for i in 0..<n - 2 {  // 遍历i，j、k作为左右指针，和两数之和一样的思路
        var x = nums[i]
        if i > 0 && x == nums[i - 1] { continue }  // i的值相同，跳过
        if x + nums[i + 1] + nums[i + 2] > 0 { break }  // 当前最小的三数之和大于目标值，后续找不到更小的了，全部剪枝
        if x + nums[n - 2] + nums[n - 1] < 0 { continue }  // 本轮的最大结果小于目标值0,本轮剪枝
        var j = i + 1
        var k = n - 1
        while j < k {
            var tmpAns = nums[i] + nums[j] + nums[k]
            if tmpAns == 0 {
                ans.append([nums[i], nums[j], nums[k]])
                j += 1
                // 跳过重复的j、k
                while j < k && nums[j] == nums[j - 1] { j += 1 }
                k -= 1
                while j < k && nums[k] == nums[k + 1] { k -= 1 }
            } else if tmpAns > 0 {
                k -= 1
            } else {
                j += 1
            }
        }
    }
    return ans
}
//print(threeSum([-1, 0, 1, 2, -1, -4]))

// 11. 盛最多水的容器
func maxArea(_ height: [Int]) -> Int {
    var ans = 0
    var l = 0
    var r = height.count - 1
    while l < r {  // 没相遇，所以还有面积
        var area = (r - l) * min(height[l], height[r])
        ans = max(ans, area)
        if height[l] < height[r] {  // 较短的线肯定没用，扔掉
            l += 1
        } else {
            r -= 1
        }
    }
    return ans
}
//maxArea([1,8,6,2,5,4,8,3,7])

// 42. 接雨水
// 视为每一列有一条左线，一条右线,转化为上一道题
// V1
func trap(_ height: [Int]) -> Int {
    var ans = 0
    var n = height.count
    var preMax = Array(repeating: height[0], count: n)  // 因为后续的for循环中直接使用了preMax[i]等，所以若不初始化会越界！
    var sufMax = Array(repeating: height[n - 1], count: n)  //
    for i in 1..<n {  // 从左到右遍历，获取每列的左高度
        preMax[i] = max(preMax[i - 1], height[i])
    }
    for i in (0..<n - 1).reversed() {  // 从右到左遍历，获取每列的右高度
        sufMax[i] = max(sufMax[i + 1], height[i])
    }
    for (h, (pre, suf)) in zip(height, zip(preMax, sufMax)) {  // 计算每一列的储水量，加起来
        ans += min(pre, suf) - h
    }
    return ans
}
//trap([0, 1, 0, 2, 1, 0, 1, 3, 2, 1, 2, 1])

// 接雨水，空间优化至O(1)
func trap_O1(_ height: [Int]) -> Int {
    var ans = 0
    var n = height.count
    var l = 0
    var r = n - 1
    var preMax = height[0]
    var sufMax = height[n - 1]
    while l <= r {
        preMax = max(preMax, height[l])
        sufMax = max(sufMax, height[r])
        if preMax < sufMax { // 左线短，那么最多只能接左线这么多，右线多长都没用；所以直接算出左侧这段的长度
            ans += preMax - height[l]
            l += 1
        } else { // 反之，右线短，算出右侧这段的长度
            ans += sufMax - height[r]
            r -= 1
        }
    }
    return ans
}
//trap_O1([0,1,0,2,1,0,1,3,2,1,2,1])

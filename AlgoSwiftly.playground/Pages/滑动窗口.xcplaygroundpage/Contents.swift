// 3. 无重复字符的最长子串
func lengthOfLongestSubstring(_ s: String) -> Int {
    var left = 0
    var maxLen = 0
    var cnt = [Character: Int]()
    for (rightIndex, rightChar) in s.enumerated() {
        cnt[rightChar, default: 0] += 1
        while cnt[rightChar]! > 1 {
            cnt[s[s.index(s.startIndex, offsetBy: left)]]! -= 1
            left += 1
        }
        maxLen = max(maxLen, rightIndex - left + 1)
    }
    return maxLen
}

// 713. 乘积小于 K 的子数组
func numSubarrayProductLessThanK(_ nums: [Int], _ k: Int) -> Int {
    var ans = 0
    var left = 0
    var product = 1
    if k <= 1 {
        return 0
    }
    for (rightIndex, rightValue) in nums.enumerated() {
        product *= rightValue
        while product >= k {
            product /= nums[left]
            left += 1
        }
        ans += rightIndex - left + 1
    }
    return ans
}

// 209. 长度最小的子数组
func minSubArrayLen(_ target: Int, _ nums: [Int]) -> Int {
    var minLen = nums.count + 1
    var left = 0
    var sum = 0
    for (index, value) in nums.enumerated() {
        sum += value
        while sum >= target {
            minLen = min(minLen, index - left + 1)
            sum -= nums[left]
            left += 1
        }
    }
    return (minLen <= nums.count ? minLen : 0)
}

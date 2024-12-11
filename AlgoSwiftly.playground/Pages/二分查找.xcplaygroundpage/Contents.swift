// 33. 搜索旋转排序数组
func search(_ nums: [Int], _ target: Int) -> Int {
    var left = -1
    var right = nums.count
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if isBlue(nums, mid, target) {
            right = mid
        } else {
            left = mid
        }
    }
    if (right == nums.count) || (nums[right] != target) {
        return -1
    }
    return right
}

// nums[i]>=target都应该染成蓝色，因为返回的是right
func isBlue(_ nums: [Int], _ i: Int, _ target: Int) -> Bool {
    var lastElement = nums[nums.count - 1]
    if nums[i] > lastElement {
        return target > lastElement && nums[i] >= target
    } else {
        return target > lastElement || nums[i] >= target
    }
}

// 153. 寻找旋转排序数组中的最小值
func findMin(_ nums: [Int]) -> Int {
    var len = nums.count
    var left = -1
    var right = len - 1
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if nums[mid] < nums[len - 1] {
            right = mid
        } else {
            left = mid
        }
    }
    return nums[right]
}

// 162. 寻找峰值
func findPeakElement(_ nums: [Int]) -> Int {
    var left = -1
    var right = nums.count - 1
    var mid: Int
    while left + 1 < right {
        mid = (left + right) / 2
        if nums[mid] > nums[mid + 1] {
            right = mid
        } else {
            left = mid
        }
    }
    return right
}

// 34. 在排序数组中查找元素的第一个和最后一个位置
func searchRange(_ nums: [Int], _ target: Int) -> [Int] {
    var startPos = lowerBound(nums, target)
    if startPos == nums.count || nums[startPos] != target {
        return [-1, -1]
    }
    var endPos = lowerBound(nums, target + 1) - 1
    return [startPos, endPos]
}

// 开区间写法
func lowerBound(_ nums: [Int], _ target: Int) -> Int {
    var left = -1
    var right = nums.count
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if nums[mid] < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return right
}

// TODO:闭区间写法
func lowerBound2(_ nums: [Int], _ target: Int) -> Int {
    var left = 0
    var right = nums.count - 1
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if nums[mid] < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return right
}

// TODO:左开右闭区间写法
func lowerBound3(_ nums: [Int], _ target: Int) -> Int {
    var left = -1
    var right = nums.count
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if nums[mid] < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return right
}

// TODO:左闭右开区间写法
func lowerBound4(_ nums: [Int], _ target: Int) -> Int {
    var left = -1
    var right = nums.count
    var mid: Int
    while left + 1 < right {
        mid = left + (right - left) / 2
        if nums[mid] < target {
            left += 1
        } else {
            right -= 1
        }
    }
    return right
}

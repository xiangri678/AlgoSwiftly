//: [Previous](@previous)

import Foundation
import UIKit

var greeting = "Hello, playground"

// 两数之和练习
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var numDict = [Int: Int]()
    for (index, val) in nums.enumerated() {
        var complement = target - val
        if let complementIndex = numDict[complement] {
            return [complementIndex, index]
        }
        numDict[val] = index
    }
    return []
}

class LinkListNode2 {
    var val: Int
    var next: LinkListNode2?

    init(val: Int, next: LinkListNode2?) {
        self.val = val
        self.next = next
    }

    init(val: Int) {
        self.val = val
        self.next = nil
    }
}

func josephRound(_ num: Int, _ m: Int) -> Int {
    var round = Array(0..<num)
    var index = 0
    while round.count > 1 {
        index = (index + m - 1) % round.count
        round.remove(at: index)
    }
    return round[0]
}
//josephRound(6, 4)

func josephusUsingFoormula(_ num: Int, _ m: Int) -> Int {
    var res = 0
    for i in 2...num {
        res = (res + m) % i
    }
    return res
}
//josephusUsingFoormula(6, 4)

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

func erfenchazhao(_ nums: [Int], _ target: Int) -> Int {
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

func combine2(_ n: Int, _ k: Int) -> [[Int]] {
    var ans: [[Int]] = []
    var path: [Int] = []

    func dfs(_ i: Int) {
        var d = k - path.count
        if i < d { return }
        if path.count == k {
            ans.append(path)
            return
        }

        for j in (d...i).reversed() {
            path.append(j)
            dfs(j - 1)
            path.popLast()
        }
    }
    dfs(n)

    return ans
}

//: [Next](@next)

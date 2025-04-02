import Foundation

func longestNotRepeat(_ s: String) -> Int {
    var maxCnt = 0
    var leftPos = 0
    var existedChars = [Character: Int]()
    for (indexI, charI) in s.enumerated() {
        existedChars[charI, default: 0] += 1
        while existedChars[charI]! > 1 {
            existedChars[s[s.index(s.startIndex, offsetBy: leftPos)]]! -= 1
            leftPos += 1
        }
        maxCnt = max(maxCnt, indexI - leftPos + 1)
    }
    return maxCnt
}
//print(longestNotRepeat("abcde"))

class ListNode {
    var val: Int
    var nxt: ListNode?

    init(val: Int, nxt: ListNode? = nil) {
        self.val = val
        self.nxt = nxt
    }

    init(val: Int) {
        self.val = val
        self.nxt = nil
    }

    init() {
        self.val = 0
        self.nxt = nil
    }
}

func reverseList(_ head: ListNode?) -> ListNode? {
    var pre = head
    var cur = head
    var nxt: ListNode?
    while cur != nil {
        nxt = cur?.nxt
        cur?.nxt = pre
        pre = cur
        cur = nxt
    }
    return pre
}

// 215. 数组中的第K个最大元素
func func_findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var nums = nums
    nums.sort { $0 > $1 }

    return nums[k - 1]
}


func heap_findKthLargest(_ nums: [Int], _ k: Int) -> Int {
    var heapSize = nums.count
    var nums = nums
    buildMaxHeap(&nums, heapSize: heapSize)
    for i in stride(from: nums.count - 1, through: nums.count - k + 1, by: -1) {
        swap(&nums, i: 0, j: heapSize - 1)
        heapSize -= 1
        maxHeapify(&nums, 0, heapSize: heapSize)
        print("maxHeapify: \(i), \(nums)")
    }
    return nums[0]
}

func buildMaxHeap(_ nums: inout [Int], heapSize: Int) {
    for i in stride(from: heapSize / 2 - 1, through: 0, by: -1) {
        maxHeapify(&nums, i, heapSize: heapSize)
        print("buildMaxHeap: \(i), \(nums)")
    }
}

func maxHeapify(_ nums: inout [Int], _ i: Int, heapSize: Int) {
    var l = 2 * i + 1
    var r = 2 * i + 2
    var largest = i
    if l < heapSize && nums[l] > nums[largest] {
        largest = l
    }
    if r < heapSize && nums[r] > nums[largest] {
        largest = r
    }
    if largest != i {
        swap(&nums, i: i, j: largest)
        maxHeapify(&nums, largest, heapSize: heapSize)
    }
}

func swap(_ nums: inout [Int], i: Int, j: Int) {
    var temp = nums[i]
    nums[i] = nums[j]
    nums[j] = temp
}

//print(func_findKthLargest([3,2,1,5,6,4], 2))
//print(heap_findKthLargest([3,2,1,5,6,4], 2))


// 146. LRU 缓存
/**
 * Your LRUCache object will be instantiated and called as such:
 * let obj = LRUCache(capacity)
 * let ret_1: Int = obj.get(key)
 * obj.put(key, value)
 */
// 各节点既存在字典里（方便查找，字典是哈希），节点内的指针又同时形成了双向链表（方便插删）
// 各节点既存在字典里（方便查找，字典是哈希），节点内的指针又同时形成了双向链表（方便插删）
class CacheNode {
    var key: Int
    var value: Int
    var pre: CacheNode?
    var nxt: CacheNode?
    
    init(key: Int, value: Int, pre: CacheNode?, nxt: CacheNode?) {
        self.key = key
        self.value = value
        self.pre = pre
        self.nxt = nxt
    }
}
class LRUCache {
    var capacity = 0
    var cacheDummy = CacheNode(key: -1, value: -1, pre: nil, nxt: nil)
    var keyToNode = [Int: CacheNode]()
    
    init(_ capacity: Int) {
        self.capacity = capacity
        cacheDummy.nxt = cacheDummy
        cacheDummy.pre = cacheDummy
    }
    
     func get(_ key: Int) -> Int {
        if let node = keyToNode[key] {
            remove_node(node: node)
            put_to_front(node: node)
            return node.value
        } else {
            return -1
        }
    }
    
    func put(_ key: Int, _ value: Int) {
        if let node = keyToNode[key] {
            node.value = value
            remove_node(node: node)
            put_to_front(node: node)
        } else {
            var node = CacheNode(key: key, value: value, pre: cacheDummy, nxt: cacheDummy.nxt)
            keyToNode[key] = node
            put_to_front(node: node)
            if keyToNode.count > capacity {
                var removeKey = cacheDummy.pre!.key
                remove_node(node: cacheDummy.pre!)
                keyToNode.removeValue(forKey: removeKey)
            }
        }
    }
    
    func put_to_front(node: CacheNode){
        node.nxt = cacheDummy.nxt
        node.pre = cacheDummy
        cacheDummy.nxt?.pre = node
        cacheDummy.nxt = node
    }
    
    func remove_node(node: CacheNode){
        node.pre?.nxt = node.nxt
        node.nxt?.pre = node.pre
    }
}

// 25. K 个一组翻转链表
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    var dummy = ListNode(val: -1, nxt: head)
    var p0: ListNode? = dummy
    var cur = head
    var pre: ListNode?
    var nxt: ListNode?
    var len = 0
    while cur != nil {
        len += 1
        cur = cur?.nxt
    }
    cur = head
    while len >= k {
        len -= k
        for _ in 0..<k {
            nxt = cur?.nxt
            cur?.nxt = pre
            pre = cur
            cur = nxt
        }
        nxt = p0?.nxt
        p0?.nxt?.nxt = cur
        p0?.nxt = pre
        p0 = pre
    }
    return dummy.nxt
}

// 160. 相交链表
func !=(lhs: ListNode?, rhs: ListNode?) -> Bool {
    if lhs == nil && rhs == nil {
        return true
    }
    if lhs == nil || rhs == nil {
        return false
    }
    return lhs?.val != rhs?.val || lhs?.nxt != rhs?.nxt
}
func getInterSectionNode(_ headA: ListNode?, _ headB: ListNode?) -> ListNode? {
    var p = headA
    var q = headB
    while p?.val != q?.val || p?.nxt != q?.nxt {
        p = p?.nxt == nil ? headB : p?.nxt
        q = q?.nxt == nil ? headA : q?.nxt
    }
    return p
}

// 54. 螺旋矩阵
let direction = [[0,1], [1,0], [0, -1], [-1, 0]]
func spiralOrder(_ matrix: [[Int]]) -> [Int] {
    var dx = 0 // 当前 x 坐标
    var dy = -1 // 当前 y 坐标
    var curDirection = 0 // 当前方向
    var m = matrix.count // 初始行数，交替存放当前边的行/列数
    var n = matrix[0].count // 初始列数，交替存放下一步边的行/列数
    var ans: [Int] = [] // 存结果
    var sum = n * m // 元素总数
    while ans.count < sum {
        for _ in 0..<n {
            dx += direction[curDirection][0]
            dy += direction[curDirection][1]
            ans.append(matrix[dx][dy])
            print("dx \(dx) dy \(dy) curDirection \(curDirection)")
        }
        curDirection = (curDirection + 1) % 4 // 计算下一轮的方向
        (n, m) = (m - 1, n) // 先计算右侧元组的 2 个值，再赋给左边元组内的 2 个元素
    }
    return ans
}

//print(spiralOrder([[1,2,3],[4,5,6],[7,8,9]]))

// 53. 最大子数组和
func maxSubArray(_ nums: [Int]) -> Int {
    var l = 0
    var r = 0
    var maxSum = 0
    var curSum = 0
    while r < nums.count {
        r += 1
        curSum += nums[r]
        if maxSum > curSum {
            l += 1
        } else {
            r += 1
        }
    }
    return maxSum
}

// 1. 两数之和
func twoSum(_ nums: [Int], _ target: Int) -> [Int] {
    var hashMap = [Int: Int]() // value:position
    for (index, j) in nums.enumerated() {
        var t = target - j
        if let i = hashMap[index] {
            return [i, index]
        } else {
            hashMap[j] = index
        }
    }
    return [0, 0]
}
print(twoSum([3,4,2], 6))

class TreeNode {
    var val: Int
    var left: TreeNode?
    var right: TreeNode?
    init(val: Int, left: TreeNode? = nil, right: TreeNode? = nil) {
        self.val = val
        self.left = left
        self.right = right
    }
    init(val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
}
func zigzagOrderLevel(_ root: TreeNode?) -> [[Int]] {
    var isEvenLevel = false
    var queue: [TreeNode?] = [root]
    var ans: [[Int]] = []
    while !queue.isEmpty {
        var curLevelVals: [Int] = []
        var curLevelCount = queue.count
        for _ in 0..<curLevelCount {
            var cur = queue.removeFirst()
            curLevelVals.append(cur!.val)
            if let l = cur?.left {
                queue.append(l)
            }
            if let r = cur?.right {
                queue.append(r)
            }
        }
        if isEvenLevel {
            ans.append(curLevelVals)
        } else {
            ans.append(curLevelVals.reversed())
        }
    }
    return ans
}

// 232. 用栈实现队列
/**
 * Your MyQueue object will be instantiated and called as such:
 * let obj = MyQueue()
 * obj.push(x)
 * let ret_2: Int = obj.pop()
 * let ret_3: Int = obj.peek()
 * let ret_4: Bool = obj.empty()
 */
class MyQueue {
    var stack: [Int] = []
    var assistStack: [Int] = []
    var count: Int {
        return stack.count
    }
    
    init() {
    }
    
    func push(_ x: Int) {
        stack.append(x)
    }
    
    func pop() -> Int {
        var cnt = stack.count
        for _ in 1..<cnt {
            var tem = stack.removeLast()
            assistStack.append(tem)
        }
        var ans = stack.removeLast()
        for _ in 1..<cnt {
            var tmp = assistStack.removeLast()
            stack.append(tmp)
        }
        return ans
    }
    
    func peek() -> Int {
        var cnt = stack.count
        for _ in 1..<cnt {
            var tem = stack.removeLast()
            assistStack.append(tem)
        }
        var ans = stack[0]
        for _ in 1..<cnt {
            var tmp = assistStack.removeLast()
            stack.append(tmp)
        }
        return ans
    }
    
    func empty() -> Bool {
        return stack.isEmpty
    }
}



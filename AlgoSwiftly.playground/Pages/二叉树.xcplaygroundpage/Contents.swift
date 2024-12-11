// 二叉树节点定义
public class TreeNode {
    public var val: Int
    public var left: TreeNode?
    public var right: TreeNode?
    public init() {
        self.val = 0
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.left = nil
        self.right = nil
    }
    public init(_ val: Int, _ left: TreeNode?, _ right: TreeNode?) {
        self.val = val
        self.left = left
        self.right = right
    }
}

let root = TreeNode(10)
root.left = TreeNode(5)
root.right = TreeNode(15)
root.left?.left = TreeNode(3)
root.left?.right = TreeNode(7)

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
    return ans[k - 1]
}
kBig(root, 5)

// 513. 找树左下角的值
func findBottomLeftValue(_ root: TreeNode?) -> Int {
    guard let root = root else { return -1 }
    var queue: ArraySlice = [root]
    var cur: Int = -1
    while !queue.isEmpty {
        if let item = queue.popFirst() {
            if let right = item.right { queue.append(right) }
            if let left = item.left { queue.append(left) }
            cur = item.val
        }
    }
    return cur
}

// 103. 二叉树的锯齿形层序遍历
func zigzagLevelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] }  //  这样一来后续的nodeQueue是非可选类型的数组了
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

// 102. 二叉树的层序遍历 双端队列实现，用ArraySlice模拟
// 因为真的双端队列Deque要导入外部库，力扣可能不行
// 力扣用ArraySlice效率反而更低，我猜测原因是数据量小
func levelOrder_deque(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] }
    var ans: [[Int]] = []
    var queue: ArraySlice = [root]
    while !queue.isEmpty {
        var vals: [Int] = []
        var curNum = queue.count
        for _ in 0..<curNum {
            if let item = queue.popFirst() {
                vals.append(item.val)
                if let left = item.left { queue.append(left) }
                if let right = item.right { queue.append(right) }
            }
        }
        ans.append(vals)
    }
    return ans
}

// 102. 二叉树的层序遍历
func levelOrder(_ root: TreeNode?) -> [[Int]] {
    guard let root = root else { return [] }
    var ans: [[Int]] = []
    var thisLevelNodes = [root]
    while !thisLevelNodes.isEmpty {
        var thisLevelVals: [Int] = []  // 如果用append，那么必须先初始化
        var nextLevelNodes: [TreeNode] = []
        for item in thisLevelNodes {
            thisLevelVals.append(item.val)
            if let left = item.left {
                nextLevelNodes.append(left)
            }
            if let right = item.right {
                nextLevelNodes.append(right)
            }
        }
        ans.append(thisLevelVals)
        thisLevelNodes = nextLevelNodes
    }
    return ans
}

// 235. 二叉搜索树的最近公共祖先
func lowestCommonAncestor(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?)
    -> TreeNode?
{
    guard let root = root, let p = p, let q = q else { return nil }
    if root.val < p.val && root.val < q.val {
        return lowestCommonAncestor(root.right, p, q)
    } else if root.val > p.val && root.val > q.val {
        return lowestCommonAncestor(root.left, p, q)
    }
    return root
}

// 236. 二叉树的最近公共祖先(函数重名了，临时加了个_2)
func lowestCommonAncestor_2(_ root: TreeNode?, _ p: TreeNode?, _ q: TreeNode?)
    -> TreeNode?
{
    // 找到p、q值的位置啦 or 走到空也没找到，那么返回的就是nil
    if root == nil || root?.val == p?.val || root?.val == q?.val {
        return root
    }
    // 递归找p、q的位置，不能老忘加.left和.right 啊，大哥
    var left = lowestCommonAncestor_2(root?.left, p, q)
    var right = lowestCommonAncestor_2(root?.right, p, q)
    // 如果左右返回的都不为空，那么意味着一个在左边找到了、另一个在右边找到了
    if left != nil && right != nil {
        return root
        // 如果一边返回了nil，说明p、q都不在那一边，那么就去另一边递归找
    } else if left != nil {
        return left
    } else {
        return right
    }
}

// 为236题扩展,力扣不让我扩展。定义不能写在func内，要写在文件域；但是文件域不被接受
extension TreeNode: Equatable {
    public static func == (_ p: TreeNode, _ q: TreeNode) -> Bool {
        if p.val == q.val {
            return true
        } else {
            return false
        }
    }
}

func invertTree(_ root: TreeNode?) -> TreeNode? {
    guard let root = root else { return nil }
    let temp = root.left
    root.left = invertTree(root.right)
    root.right = invertTree(temp)
    return root
}

@MainActor func findFather(_ view1: UIView?, _ view2: UIView?) -> UIView? {
    var set1 = Set<UIView>()
    var cur = view1
    while let view = cur {
        set1.insert(view)
        cur = cur?.superview
    }

    cur = view2
    while let view = cur {
        if set1.contains(view) {
            return view
        }
        cur = view.superview
    }
    return nil
}

// 98. 验证二叉搜索树
//func isValidBST(_ root: TreeNode?) -> Bool { // 这是初始定义，下一行自己添加了默认值参数
// 法1 先序遍历
func isValidBST_first(
    _ root: TreeNode?, left: Int = Int.min, right: Int = Int.max
) -> Bool {
    guard let root = root else { return true }  // 空节点是合法的 BST。 通过该语句可以验证root有效、编译器认可，后续语句无需再解包；如果自行用if语句编写，编译器仍会认为值可能不存在，后续语句要求解包等等
    var val = root.val
    // 当前节点的值必须在 (left, right) 范围内、递归检查左子树和右子树
    return val > left && val < right
        && isValidBST_first(root.left, left: left, right: val)
        && isValidBST_first(root.right, left: val, right: right)
}

// 法2 中序遍历
func isValidBST_mid(
    _ root: TreeNode?, left: Int = Int.min, right: Int = Int.max
) -> Bool {
    guard let root = root else { return true }
    if !isValidBST_mid(root.left, left: left, right: root.val) { return false }
    if !(root.val > left && root.val < right) { return false }
    return isValidBST_mid(root.right, left: root.val, right: right)
}

// 法3 中序遍历
class Solution {
    // 这段代码包装进class就对了,否则报错中
    var pre: Int = Int.min
    func isValidBST_mid_2(_ root: TreeNode?) -> Bool {
        guard let root = root else { return true }
        if !isValidBST_mid_2(root) { return false }
        if root.val <= pre { return false }
        pre = root.val
        return isValidBST_mid_2(root.right)
    }
}

// 法4 后序遍历
func isValidBST_last(_ root: TreeNode?) -> Bool {
    func iterate(_ root: TreeNode?) -> (Int, Int) {
        guard let root = root else { return (Int.max, Int.min) }
        var l_min: Int
        var l_max: Int
        var r_min: Int
        var r_max: Int
        var cur: Int
        (l_min, l_max) = iterate(root.left)
        (r_min, r_max) = iterate(root.right)
        cur = root.val
        if cur <= l_max || cur >= r_min {
            return (Int.min, Int.max)
        }
        return (min(l_min, cur), max(r_max, cur))
    }
    return iterate(root).0 != Int.max && iterate(root).0 != Int.min
}

// 199. 二叉树的右视图
func rightSideView(_ root: TreeNode?) -> [Int] {
    var view = [Int]()
    func rightFirstTraverse(_ currentHeight: Int, _ root: TreeNode?) {
        if root == nil {
            return
        }
        if currentHeight == view.count {
            view.append(root!.val)
        }
        rightFirstTraverse(currentHeight + 1, root?.right)
        rightFirstTraverse(currentHeight + 1, root?.left)
    }
    rightFirstTraverse(0, root)
    return view
}

// 110. 平衡二叉树
func isBalanced(_ root: TreeNode?) -> Bool {
    return getHeight2(root) == -1 ? false : true
}
// 两个 getHeight 方法时间复杂度都是0ms，方法2内存占用多0.4MB，基本不相伯仲
func getHeight(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    var leftHeight = getHeight(root?.left)
    var rightHeight = getHeight(root?.right)
    if leftHeight == -1 || rightHeight == -1
        || abs(leftHeight - rightHeight) > 1
    {
        return -1
    } else {
        return max(leftHeight, rightHeight) + 1
    }
}

func getHeight2(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    var leftHeight = getHeight2(root?.left)
    if leftHeight == -1 {  // 单独进行一次判断
        return -1
    }
    var rightHeight = getHeight2(root?.right)
    if rightHeight == -1 || abs(leftHeight - rightHeight) > 1 {
        return -1
    } else {
        return max(leftHeight, rightHeight) + 1
    }
}

// 101. 对称二叉树
func isSymmetric(_ root: TreeNode?) -> Bool {
    return isSameTree_Symmetric(root?.left, root?.right)
}

func isSameTree_Symmetric(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if p == nil || q == nil {
        if p == nil && q == nil {
            return true
        } else {
            return false
        }
    }
    return p?.val == q?.val && isSameTree_Symmetric(p?.left, q?.right)
        && isSameTree_Symmetric(p?.right, q?.left)
}

// 100. 相同的树
func isSameTree(_ p: TreeNode?, _ q: TreeNode?) -> Bool {
    if p == nil || q == nil {
        if p == nil && q == nil {
            return true
        } else {
            return false
        }
    }
    return p?.val == q?.val && isSameTree(p?.left, q?.left)
        && isSameTree(p?.right, q?.right)
}

// 104. 二叉树的最大深度
func maxDepth_2(_ root: TreeNode?) -> Int {
    var maxDepth = 0
    func goDeeperWithCnt(_ root: TreeNode?, _ cnt: Int) {
        if root == nil {
            return
        }
        maxDepth = max(maxDepth, cnt + 1)
        goDeeperWithCnt(root?.left, cnt + 1)
        goDeeperWithCnt(root?.right, cnt + 1)
    }
    goDeeperWithCnt(root, 0)
    return maxDepth
}

// 104. 二叉树的最大深度
func maxDepth_1(_ root: TreeNode?) -> Int {
    if root == nil {
        return 0
    }
    // 思考递归问题时，不要陷入细节。宏观考虑：最大深度=(左深度、右深度最大值)+1
    return max(maxDepth_1(root?.left), maxDepth_1(root?.right)) + 1
}

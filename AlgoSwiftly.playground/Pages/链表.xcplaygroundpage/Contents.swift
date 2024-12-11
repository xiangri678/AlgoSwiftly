// 单链表定义
public class ListNode {
    public var val: Int
    public var next: ListNode?
    public init() {
        self.val = 0
        self.next = nil
    }
    public init(_ val: Int) {
        self.val = val
        self.next = nil
    }
    public init(_ val: Int, _ next: ListNode?) {
        self.val = val
        self.next = next
    }
}

// 链表初始化
func initList() -> ListNode? {
    var one = ListNode(1)
    var two = ListNode(2)
    var three = ListNode(3)
    var four = ListNode(4)
    var five = ListNode(5)
    var six = ListNode(6)
    one.next = two
    two.next = three
    three.next = four
    four.next = five
    five.next = six
    return one
}

// 打印链表
func printLinkList(head: ListNode?) {
    //    guard var cur = head else {print("Empty Link list");return}
    //    while cur != nil {
    //        print(cur.val, terminator: " -> ")
    //        cur=cur?.next
    //    }
    var cur = head
    while let node = cur {
        print(node.val, terminator: " -> ")
        cur = node.next
    }
    print()
}

// 运行程序的包装
func run() {
    var list = initList()
    reorderList(list)
    printLinkList(head: list)
}

//run()

// 82. 删除排序链表中的重复元素 II
func deleteDuplicatesII(_ head: ListNode?) -> ListNode? {
    let dummy = ListNode(-1, head)
    var cur: ListNode? = dummy
    while cur?.next != nil && cur?.next?.next != nil {
        var val = cur?.next?.val
        if val == cur?.next?.next?.val {
            while cur?.next != nil && cur?.next?.val == val {
                cur?.next = cur?.next?.next
            }
        } else {
            cur = cur?.next
        }
    }
    return dummy.next
}

// 83. 删除排序链表中的重复元素
func deleteDuplicates(_ head: ListNode?) -> ListNode? {
    if head == nil {
        return head
    }
    var cur: ListNode? = head
    if cur?.val == cur?.next?.val {
        cur?.next = cur?.next?.next
    } else {
        cur = cur?.next
    }
    return head
}

// 19. 删除链表的倒数第 N 个结点
func removeNthFromEnd(_ head: ListNode?, _ n: Int) -> ListNode? {
    var dummy = ListNode(-1, head)
    var fast: ListNode? = dummy
    var slow: ListNode? = dummy
    for _ in 0..<n {
        fast = fast?.next
    }
    while fast?.next != nil {
        slow = slow?.next
        fast = fast?.next
    }
    slow?.next = slow?.next?.next
    return head
}

// 237. 删除链表中的节点
func deleteNode(_ node: ListNode?) {
    guard let node = node, let nextNode = node.next else { return }  // 因为是可选类型，所以需要先解包。解包成功后，后续不再需要可选
    node.val = nextNode.val
    node.next = nextNode.next
}

// 143. 重排链表
func reorderList(_ head: ListNode?) {
    // 找中点
    var slow = head
    var fast = head
    while fast != nil && fast?.next != nil {
        slow = slow?.next
        fast = fast?.next?.next
    }

    // 反转后半段链表
    //    let dummy = ListNode(-1, slow)
    var cur: ListNode? = slow
    var pre: ListNode? = nil  // 赋值为nil，不报错，很好。这样就不需要用dummy了，后续合并的时候就不用担心多一个节点了
    var nxt: ListNode? = cur?.next
    while cur != nil {
        nxt = cur?.next
        cur?.next = pre
        pre = cur
        cur = nxt
    }

    // 交错合并2段链表
    var head1 = head
    var head2 = pre
    var nxt1: ListNode?
    var nxt2: ListNode?
    //    while head2?.val != -1 && head2?.next?.val != -1 { // 如果用了dummy，就会出现多一个节点，所以这样把dummy排除出去
    while head2?.next != nil {
        nxt1 = head1?.next
        nxt2 = head2?.next
        head1?.next = head2
        head2?.next = nxt1
        head1 = nxt1
        head2 = nxt2
    }

    //    var head3: ListNode? = head
    //    while head3?.next?.val != -1 {
    //        head3 = head3?.next
    //    }
    //    head3?.next = nil
}

// 141. 环形链表
func hasCycle(_ head: ListNode?) -> Bool {
    var fast = head
    var slow = head
    while (fast != nil) && ((fast?.next) != nil) {
        slow = slow?.next
        fast = fast?.next?.next
        if fast === slow {
            return true
        }
    }
    return false
}

// 876. 链表的中间结点
func middleNode(_ head: ListNode?) -> ListNode? {
    var fast = head
    var slow = head
    while fast != nil && fast?.next != nil {
        fast = fast?.next?.next
        slow = slow?.next
    }
    return slow
}

// 25. K 个一组翻转链表
func reverseKGroup(_ head: ListNode?, _ k: Int) -> ListNode? {
    let dummy = ListNode(0, head)
    var len = 0
    var nxt: ListNode? = nil
    var pre: ListNode? = nil
    var cur: ListNode? = dummy.next
    var p0: ListNode? = dummy
    while cur != nil {
        len += 1
        cur = cur?.next
    }
    cur = dummy.next
    while len >= k {
        len -= k
        for _ in 0..<k {
            nxt = cur?.next
            cur?.next = pre
            pre = cur
            cur = nxt
        }
        nxt = p0?.next
        p0?.next?.next = cur
        p0?.next = pre
        p0 = nxt
    }
    return dummy.next
}

// 92. 反转链表 II
func reverseBetween(_ head: ListNode?, _ left: Int, _ right: Int) -> ListNode? {
    guard let head = head else { return nil }
    var dummyNode = ListNode(-1, head)
    var p0: ListNode? = dummyNode
    var pre: ListNode?
    var cur: ListNode?
    var nxt: ListNode?
    for _ in 1..<left {  // p0是反转区的前一个节点，记下来连接反转的段
        p0 = p0?.next
    }
    cur = p0?.next
    pre = p0
    for _ in 1...right - left + 1 {
        nxt = cur?.next
        cur?.next = pre
        pre = cur
        cur = nxt
    }
    p0?.next?.next = cur
    p0?.next = pre
    return dummyNode.next
}

// 206. 反转链表
func reverseList(_ head: ListNode?) -> ListNode? {
    var pre: ListNode? = nil
    var cur = head
    var nxt: ListNode? = nil
    while cur != nil {
        nxt = cur?.next
        cur?.next = pre
        pre = cur
        cur = nxt
    }
    return pre
}

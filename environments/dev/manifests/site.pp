node 'node1.kubernetes.local', 'node2.kubernetes.local' {
  include worker
}

node 'control2' {
  include control
}

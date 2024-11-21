class worker::packages {

  Package { ensure => 'installed' }

  $enhancers = [ 'kubectl', 'containerd', 'kubernetes-cni','ipvsadm', 'ipset' ]

  package { $enhancers: }


}

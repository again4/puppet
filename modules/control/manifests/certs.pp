class control::certs{
 file { "/etc/etcd/etcd-server.key":
    ensure => file,
    source => "puppet:///modules/certs/etcd-server.key",
    owner  => root,
    group  => root,
    mode   => '0600', 
  }

   file { "/etc/etcd/etcd-server.crt":
    ensure => file,
    source => "puppet:///modules/certs/etcd-server.crt",
    owner  => root,
    group  => root,
    mode   => '0600', 
  }

   file { "/var/lib/kubernetes/pki/ca.crt":
    ensure => file,
    source => "puppet:///modules/certs/ca.crt",
    owner  => root,
    group  => root,
    mode   => '0600',
  }

    file { '/etc/etcd/ca.crt':
    ensure => 'link',
    target => '/var/lib/kubernetes/pki/ca.crt',
    owner  => 'root',
    group  => 'root',
    mode   => '0644',
  }

 
  $hostname = fact('hostname')
  $primary_interface = fact('networking.primary')
  $primary_ip = fact("networking.interfaces.${primary_interface}.ip")

  file { '/etc/systemd/system/etcd.service':
    ensure  => file,
    content => template('etcd/etcd.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }


  file { '/var/lib/kubernetes/pki/kube-apiserver.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-apiserver.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/kube-apiserver.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-apiserver.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/service-account.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/service-account.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/service-account.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/service-account.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/apiserver-kubelet-client.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/apiserver-kubelet-client.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/apiserver-kubelet-client.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/apiserver-kubelet-client.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/etcd-server.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/etcd-server.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/etcd-server.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/etcd-server.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/kube-scheduler.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-scheduler.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/kube-scheduler.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-scheduler.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/kube-controller-manager.crt':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-controller-manager.crt',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { '/var/lib/kubernetes/pki/kube-controller-manager.key':
  ensure  => 'file',
  source  => 'puppet:///modules/certs/kube-controller-manager.key',
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

 file { '/var/lib/kubernetes/kube-controller-manager.kubeconfig':
  ensure => 'file',
  source => 'puppet:///modules/certs/kube-controller-manager.kubeconfig',
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}

file { '/var/lib/kubernetes/kube-scheduler.kubeconfig':
  ensure => 'file',
  source => 'puppet:///modules/certs/kube-scheduler.kubeconfig',
  owner  => 'root',
  group  => 'root',
  mode   => '0600',
}

file { '/var/lib/kubernetes/encryption-config.yaml':
  ensure => 'file',
  source => 'puppet:///modules/certs/encryption-config.yaml',
  owner  => 'root',
  group  => 'root',
  mode   => '0644',
}  
  $pod_cidr      = '10.244.0.0/16'
  $service_cidr  = '10.96.0.0/16'
  $loadbalancer  = '10.255.205.211'

file { '/etc/systemd/system/kube-controller-manager.service':
    ensure  => 'file',
    content => template('certs/kube-controller-manager.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }

file {'/etc/systemd/system/kube-scheduler.service':
     ensure => 'file',
     source => 'puppet:///modules/certs/kube-scheduler.service',
     owner  => 'root',
     group  => 'root',
     mode   => '0644',
}


file { '/etc/systemd/system/kube-apiserver.service':
    ensure  => 'file',
    content => template('certs/kube-apiserver.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }



file { '/root/admin.crt':
    ensure  => 'file',
    source  => 'puppet:///modules/certs/admin.crt',
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

file {'/root/admin.key':
     ensure => 'file',
     source => 'puppet:///modules/certs/admin.key',
     owner  => 'root',
     group  => 'root',
     mode   => '0600',
}


file { '/root/.kube/config':
    ensure  => 'file',
    source  => 'puppet:///modules/certs/config',
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }



}





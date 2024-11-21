class worker::certs {
  $hostname = $facts['fqdn']  # Отримуємо ім'я хоста


  file { '/etc/containerd/config.toml':
    ensure => file,
    source => 'puppet:///modules/containerd/config.toml',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }

   file { '/etc/systemd/system/kube-proxy.service':
    ensure => file,
    source => 'puppet:///modules/certs/kube-proxy.service',
    mode   => '0644',
    owner  => 'root',
    group  => 'root',
  }


   file { '/var/lib/kubernetes/pki/ca.crt':
    ensure => file,
    source => 'puppet:///modules/certs/ca.crt',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }

   file { '/var/lib/kubernetes/pki/kube-proxy.crt':
    ensure => file,
    source => 'puppet:///modules/certs/kube-proxy.crt',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }

   file { '/var/lib/kubernetes/pki/kube-proxy.key':
    ensure => file,
    source => 'puppet:///modules/certs/kube-proxy.key',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }
  
  file { '/var/lib/kube-proxy/kube-proxy.kubeconfig':
    ensure => file,
    source => 'puppet:///modules/certs/kube-proxy.kubeconfig',
    mode   => '0600',
    owner  => 'root',
    group  => 'root',
  }




  $pod_cidr = '10.244.0.0/16'
  $primary_interface = fact('networking.primary')
  $primary_ip = fact("networking.interfaces.${primary_interface}.ip")
  $host = $facts['networking']['hostname']
  $cluster_dns = '10.96.0.10'

file { '/var/lib/kube-proxy/kube-proxy-config.yaml':
    ensure  => 'file',
    content => template('certs/kube-proxy-config.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

  
file { '/var/lib/kubelet/kubelet-config.yaml':
    ensure  => 'file',
    content => template('certs/kubelet-config.yaml.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0600',
  }

   
  
file { '/etc/systemd/system/kubelet.service':
    ensure  => 'file',
    content => template('certs/kubelet.service.erb'),
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
  }




# Создаем файл с сертификатами и ключами
file { "/var/lib/kubernetes/pki/${host}.crt":
  ensure  => 'file',
  source  => "puppet:///modules/certs/${host}.crt",
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

file { "/var/lib/kubernetes/pki/${host}.key":
  ensure  => 'file',
  source  => "puppet:///modules/certs/${host}.key",
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

# Переносим kubeconfig в /var/lib/kubelet/
file { "/var/lib/kubelet/kubelet.kubeconfig":
  ensure  => 'file',
  source  => "puppet:///modules/certs/${host}.kubeconfig",
  owner   => 'root',
  group   => 'root',
  mode    => '0600',
}

}


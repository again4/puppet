class control::binaries {
  $etcd_version = 'v3.5.9'
  $kube_version = 'v1.31.2'
  $arch = $facts['os']['architecture']
  
  notice("Detected architecture: ${arch}")
  # Determine etcd URL based on architecture
#  if $arch == 'x86_64' {
#    $etcd_url = "${etcd_version}/etcd-${etcd_version}-linux-amd64.tar.gz"
#    $etcd = "etcd-${etcd_version}-linux-amd64"
#    $architecture = "amd64"
#  } elsif $arch == 'aarch64' {
#    $etcd_url = "${etcd_version}/etcd-${etcd_version}-linux-arm64.tar.gz"
#    $etcd = "etcd-${etcd_version}-linux-arm64"
#    $architecture = "arm64"
#  } else {
#    fail("Unsupported architecture: ${arch}")
#  }

  archive { 'kubectl':
    ensure => present,
    url    => "https://dl.k8s.io/release/${kube_version}/bin/linux/${arch}/kubectl",
    path   => '/usr/local/bin/kubectl',
    extract => false,
  }
  file { '/usr/local/bin/kubectl':
    ensure  => file,
    mode    => '0755',
    require => Archive['kubectl'],
  }


  archive { 'etcd':
    ensure       => present,
    source       => "https://github.com/coreos/etcd/releases/download/${etcd_version}/etcd-${etcd_version}-linux-${arch}.tar.gz",
    provider     => 'wget',
    extract      => true,
    extract_path => '/tmp',
    extract_command => 'tar xfz %s --strip-components=1 -C /usr/local/bin/',
    cleanup      => true,
    path         => "/tmp/etcd",
  }

  $kube_binaries = ['kube-apiserver', 'kube-controller-manager', 'kube-scheduler']

  $kube_binaries.each |$binary| {
    archive { $binary:
      ensure  => present,
      source  => "https://dl.k8s.io/release/${kube_version}/bin/linux/${arch}/${binary}",
      provider => 'wget',
      path     => "/usr/local/bin/${binary}",
    }
    file { "/usr/local/bin/${binary}":
      ensure => file,
      mode   => '0755',
      require => Archive[$binary],
    }
  }
}


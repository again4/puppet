class worker::binaries {

  # Set Kubernetes version as a variable
  $kube_latest = 'v1.31'
  $kube_version = 'v1.31.2'
  $arch = 'amd64'

  # Ensure the keyrings directory exists
  file { '/etc/apt/keyrings':
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  file {'/etc/apt/keyrings/kubernetes-apt-keyring.gpg':
    ensure  => absent,
  }

  # Download the Kubernetes key
  exec { 'download_kubernetes_key':
    command => "/usr/bin/curl -fsSL https://pkgs.k8s.io/core:/stable:/${kube_latest}/deb/Release.key | /usr/bin/gpg --dearmor --yes -o /etc/apt/keyrings/kubernetes-apt-keyring.gpg",
    require => File['/etc/apt/keyrings'],
    notify  => Exec['apt_update'], # Notify apt update if key is downloaded
  }

  # Add Kubernetes repository to the apt sources list
  file { '/etc/apt/sources.list.d/kubernetes.list':
    ensure  => 'file',
    content => "deb [signed-by=/etc/apt/keyrings/kubernetes-apt-keyring.gpg] https://pkgs.k8s.io/core:/stable:/${kube_latest}/deb/ /",
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    require => Exec['download_kubernetes_key'],
  }

  # Update apt cache after the sources list is updated
  exec { 'apt_update':
    command     => '/usr/bin/apt-get update',
    refreshonly => true,
    subscribe   => File['/etc/apt/sources.list.d/kubernetes.list'],
  }

  $kube_binaries = ['kubelet', 'kube-proxy']

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


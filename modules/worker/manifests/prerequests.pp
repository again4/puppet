class worker::prerequests (
  Boolean $disable_swap                             = $worker::disable_swap,
  Boolean $manage_kernel_modules                    = $worker::manage_kernel_modules,
  Boolean $manage_sysctl_settings                   = $worker::manage_sysctl_settings,
) {


  Package { ensure => 'installed' }

  $enhancers = [ 'apt-transport-https', 'ca-certificates', 'curl' ]

  package { $enhancers: }
  
  if $disable_swap {
    exec { 'disable swap':
      path    => ['/usr/sbin/', '/usr/bin', '/bin', '/sbin'],
      command => 'swapoff -a',
    }
    file_line { 'remove swap in /etc/fstab':
      ensure            => absent,
      path              => '/etc/fstab',
      match             => '\sswap\s',
      match_for_absence => true,
      multiple          => true,
    }
  }

  # Manage kernel modules and sysctl settings
  if $manage_kernel_modules and $manage_sysctl_settings {
    kmod::load { 'overlay': }
    kmod::load { 'br_netfilter':
      before => Sysctl['net.bridge.bridge-nf-call-iptables'],
    }
    sysctl { 'net.bridge.bridge-nf-call-iptables':
      ensure => present,
      value  => '1',
      before => Sysctl['net.ipv4.ip_forward'],
    }
    sysctl { 'net.ipv4.ip_forward':
      ensure => present,
      value  => '1',
    }
  } elsif $manage_kernel_modules {
    kmod::load { 'overlay': }
    kmod::load { 'br_netfilter': }
  } elsif $manage_sysctl_settings {
    sysctl { 'net.bridge.bridge-nf-call-iptables':
      ensure => present,
      value  => '1',
      before => Sysctl['net.ipv4.ip_forward'],
    }
    sysctl { 'net.ipv4.ip_forward':
      ensure => present,
      value  => '1',
    }
  }

  # Create directories
  $directories = ['/var/lib/kubelet',
    '/var/lib/kube-proxy', '/var/lib/kubernetes', '/var/lib/kubernetes/pki'
  ]

  # Iterate over the directories to create them
  $directories.each |$dir| {
    file { $dir:
      ensure => 'directory',
      mode   => '0755',
      owner  => 'root',
      group  => 'root',
    }
  }
}


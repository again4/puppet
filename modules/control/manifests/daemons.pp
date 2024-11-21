class control::daemons {

  exec { 'systemctl daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
    refreshonly => true, # Выполняется только при изменении зависимых ресурсов
  }

  # Управление сервисом kube-apiserver
  service { 'kube-apiserver':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }

  # Управление сервисом kube-controller-manager
  service { 'kube-controller-manager':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }

  # Управление сервисом kube-scheduler
  service { 'kube-scheduler':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }

  # Управление сервисом etcd
  service { 'etcd':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }
}


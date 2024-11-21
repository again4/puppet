class worker::daemons {

  exec { 'systemctl daemon-reload':
    command     => '/bin/systemctl daemon-reload',
    path        => ['/bin', '/usr/bin', '/sbin', '/usr/sbin'],
    refreshonly => true, # Выполняется только при изменении зависимых ресурсов
  }

  # Управление сервисом kube-apiserver
  service { 'containerd':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }

  service { 'kubelet':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }

  service { 'kube-proxy':
    ensure    => 'running',
    enable    => true,
    subscribe => Exec['systemctl daemon-reload'],  # Обновление после выполнения daemon-reload
    provider  => 'systemd',
  }


}

class control::prerequests(

  # Оголошення змінних
){
  Package { ensure => 'installed' }

  $enhancers = [ 'apt-transport-https', 'ca-certificates', 'curl', 'gnupg' ]

  package { $enhancers: }

  


    file { ['/var/lib/kubernetes',
           '/var/lib/kubernetes/pki',
           '/etc/etcd']:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

   file {'/var/lib/etcd':
      ensure  => 'directory',
      owner   => 'root',
      group   => 'root',
      mode    => '0600'
}

    

}

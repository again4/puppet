class worker (
  Boolean $disable_swap          = true,
  Boolean $manage_kernel_modules = true,
  Boolean $manage_sysctl_settings = true,
) {
  include worker::prerequests
  include worker::binaries
  include worker::packages
  include worker::certs
  include worker::daemons

  contain worker::prerequests
  contain worker::binaries
  contain worker::packages
  contain worker::certs
  contain worker::daemons

  # Define order of classes
  Class['worker::prerequests']
    -> Class['worker::binaries']
    -> Class['worker::packages']
    -> Class['worker::certs']
    -> Class['worker::daemons']
}


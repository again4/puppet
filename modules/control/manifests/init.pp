class control{

  include control::prerequests
  include control::binaries
  include control::certs
  include control::daemons
  contain control::prerequests
  contain control::binaries
  contain control::certs
  contain control::daemons

  Class['control::prerequests']
  -> Class['control::binaries']
  -> Class['control::certs']
  -> Class['control::daemons']

}

#
#
#
class rsnapshot::install (
  String $package_name   = $::rsnapshot::package_name,
  String $package_ensure = $::rsnapshot::package_ensure,
) {
  package { $package_name:
    ensure => $package_ensure,
  }
}

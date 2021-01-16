#
#
#
class rsnapshot::reports (
  String $rsnapshot_wrapper_path = $::rsnapshot::rsnapshot_wrapper_path,
) {
  file { $rsnapshot_wrapper_path:
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/rsnapshot/rsnapshot_wrapper.sh',
  }

  # Perl script which parses the output.
  file { '/usr/local/bin/rsnapreport.pl':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/rsnapshot/rsnapreport.pl',
  }
}

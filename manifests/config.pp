#
#
#
class rsnapshot::config (
  String $config_file         = $::rsnapshot::config_file,
  String $rsnapshot_directory = $::rsnapshot::rsnapshot_directory,
  String $ssh_args            = $::rsnapshot::ssh_args,
  String $rsnapshot_keyfile   = $::rsnapshot::rsnapshot_keyfile,
  String $known_hosts_file    = $::rsnapshot::known_hosts_file,
  Hash   $intervals           = $::rsnapshot::intervals,
) {
  concat { $config_file:
    ensure => present,
  }

  $_full_ssh_args = "${ssh_args} -i ${rsnapshot_directory}/${rsnapshot_keyfile} -o UserKnownHostsFile=${known_hosts_file}"

  $_header_config = {
    'rsnapshot_directory' => $rsnapshot_directory,
    'full_ssh_args'       => $_full_ssh_args,
  }

  concat::fragment { 'Header':
    target  => $config_file,
    content => epp('rsnapshot/rsnapshot.conf.epp', $_header_config),
    order   => '00',
  }

  concat::fragment { 'Intervals':
    target  => $config_file,
    content => epp('rsnapshot/intervals.conf.epp', { 'intervals' => $intervals, }),
    order   => '10',
  }

  concat::fragment { 'Backup points header':
    target  => $config_file,
    content => epp('rsnapshot/backup_points.conf.epp'),
    order   => '48',
  }

  exec { 'Create ssh key':
    command => "/usr/bin/ssh-keygen -f ${rsnapshot_keyfile} -N '' -q",
    cwd     => $rsnapshot_directory,
    creates => "${rsnapshot_directory}/${rsnapshot_keyfile}",
  }

  file { '/usr/bin/rsync-no-vanished':
    ensure => present,
    mode   => '0755',
    owner  => 'root',
    source => 'puppet:///modules/rsnapshot/rsync-no-vanished',
  }

  file { '/usr/local/bin/rsnapshot_ssh.sh':
    ensure  => present,
    mode    => '0755',
    owner   => 'root',
    content => "#!/bin/sh\n# Managed by Puppet\nssh ${_full_ssh_args} \"$@\"",
  }
}

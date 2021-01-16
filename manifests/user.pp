#
#
#
class rsnapshot::user (
  Enum['present', 'absent'] $ensure                 = present,
  Hash                      $authorized_keys        = {},
  String                    $user_name              = 'rsnapshot',
  String                    $public_key_type        = 'ssh-rsa',
  Stdlib::AbsolutePath      $user_home              = '/opt/rsnapshot',
  Boolean                   $system_user            = true,
  String                    $user_comment           = 'Rsnapshot User',
  Optional[String]          $tag                    = undef,
) {
  user { $user_name:
    ensure         => $ensure,
    home           => $user_home,
    system         => $system_user,
    comment        => $user_comment,
    password       => '*',
    managehome     => true,
    purge_ssh_keys => true,
  }

  $_authorized_keys_defaults = {
    ensure => $ensure,
    user   => $user_home,
    type   => $public_key_type,
  }
  create_resources('ssh_authorized_key', $authorized_keys, $_authorized_keys_defaults)

  if $tag {
    @@sshkey { $facts['networking']['fqdn']:
      ensure       => $ensure,
      host_aliases => [ $facts['networking']['hostname'] ],
      type         => 'rsa',
      key          => $facts['ssh']['rsa']['key'],
      tag          => $tag,
    }
  }

  if $ensure == present {
    ensure_packages( ['rsync'], { ensure => present } )
    file { "${user_home}/rsync-wrapper.sh":
      ensure  => present,
      mode    => '0755',
      owner   => $user_name,
      source  => 'puppet:///modules/rsnapshot/rsync_wrapper.sh',
      require => User[$user_name],
    }
    sudo::confg{ 'rsnapthost-sync-wrapper':
      content => "Defaults:${user_name} !requiretty\n${user_name} ALL=(ALL) NOPASSWD:/usr/bin/rsync\n",
    }
  }
}

#
#
#
define rsnapshot::backup_script (
  String $command      = undef,
  String $target_dir   = undef,
  String $concat_order = '51',
  String $config_file  = $::rsnapshot::config_file,
) {
  concat::fragment { "Backup_script - ${title}":
    target  => $config_file,
    content => "backup_script\t${command}\t${target_dir}\n",
    order   => $concat_order,
  }
}

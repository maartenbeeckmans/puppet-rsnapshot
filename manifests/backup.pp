#
#
#
define rsnapshot::backup (
  String        $source,
  String        $target_dir,
  Array[String] $extra_opts             = [],
  String        $config_file            = $::rsnapshot::config_file,
) {
  if ($source =~ /^rsnapshot@/) {
    $_rsync_long_opts = '+rsync_long_args=--rsync-path=/opt/rsnapshot/rsync-wrapper.sh'
  }
  $_extra_opts_str = join(flatten([$_rsync_long_opts, $extra_opts]), '\t')
  concat::fragment { "Backups - ${title}":
    target  => $config_file,
    content => "backup\t${source}\t${target_dir}\t{_extra_opts_str}\n",
    order   => '50',
  }
}

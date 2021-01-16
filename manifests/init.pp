#
#
#
class rsnapshot (
  String                    $package_name,
  String                    $package_ensure,
  String                    $config_file,
  String                    $rsnapshot_directory,
  String                    $ssh_args,
  String                    $rsnapshot_keyfile,
  String                    $known_hosts_file,
  Hash                      $intervals,
  Hash                      $timers,
  String                    $rsnapshot_wrapper_path,
  String                    $reports_path,
  String                    $service_ensure,
  Boolean                   $service_enable,
  Enum['present', 'absent'] $user_ensure,
  Hash                      $user_authorized_keys,
  String                    $user_user_name,
  String                    $user_public_key_type,
  Stdlib::AbsolutePath      $user_user_home,
  Boolean                   $user_system_user,
  String                    $user_user_comment,
  Optional[String]          $user_tag                    = undef,
) {
  contain rsnapshot::install
  contain rsnapshot::config
  contain rsnapshot::reports
  contain rsnapshot::service

  Class['rsnapshot::install']
  -> Class['rsnapshot::config']
  -> Class['rsnapshot::reports']
  -> Class['rsnapshot::service']
}

#
#
#
class rsnapshot::service (
  Hash    $timers                 = $::rsnapshot::timers,
  String  $rsnapshot_wrapper_path = $::rsnapshot::rsnapshot_wrapper_path,
  String  $reports_path           = $::rsnapshot::reports_path,
  String  $service_ensure         = $::rsnapshot::service_ensure,
  Boolean $service_enable         = $::rsnapshot::service_enable,
) {
  # Service File
  $_service_config = {
    'rsnapshot_wrapper_path' => $rsnapshot_wrapper_path,
    'reports_path'           => $reports_path,
  }
  ::systemd::unit_file{ 'rsnapshot@.service':
    content => epp('rsnapshot/service.epp', $_service_config),
  }

  # Timer file(s)
  $timers.each |String $name, Hash $options| {
    $_timer_config = {
      'name'        => $name,
      'on_calendar' => $options['on_calendar'],
    }
    systemd::unit_file{"rsnapshot@${name}.timer":
      content => epp('rsnapshot/timer.epp', $_timer_config),
      notify  => Service["rsnapshot@${name}.timer"],
    }
    service { "rsnapshot@${name}.timer":
      ensure => $service_ensure,
      enable => $service_enable,
    }
  }
}

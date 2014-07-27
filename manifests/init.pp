class sendmail (
    $configmc = '/root/etc/mail/sendmail.mc',
    $aliases  = '/root/etc/mail/aliases',
) {

    $execpath    = '/bin:/sbin:/usr/bin:/usr/sbin'

    file { 'sendmail_mc' {
        path   => "/etc/mail/${fqdn}.mc",
        ensure => file,
        owner  => 'root',
        group  => 'wheel',
        source => $configmc,
        notify => Exec['mail_make']
    }

    file { 'mail_aliases': {
        path   => "/etc/mail/aliases",
        ensure => file,
        owner  => 'root',
        group  => 'wheel',
        source => $aliases,
        notify => Exec['mail_make']
    }

    exec { 'mail_make': {
        command => "make",
        creates => "/etc/mail/${fqdn}.cf",
        user    => 'root',
        group   => 'wheel',
        cwd     => "/etc/mail",
        path    => $execpath,
        require => File['sendmail_mc'],
        notify  => Service['sendmail']
    }

    service { 'sendmail':
        ensure => running,
        enable => true
    }


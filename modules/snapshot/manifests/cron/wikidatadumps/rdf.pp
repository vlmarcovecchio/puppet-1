class snapshot::cron::wikidatadumps::rdf(
    $user      = undef,
    $filesonly = false,
) {
    $scriptpath = '/usr/local/bin/dumpwikidatardf.sh'
    file { $scriptpath:
        mode    => '0755',
        owner   => 'root',
        group   => 'root',
        source  => 'puppet:///modules/snapshot/cron/dumpwikidatardf.sh',
        require => Class['snapshot::cron::wikidatadumps::common'],
    }

    if !$filesonly {
        cron { 'wikidatardf-dumps':
            ensure      => 'present',
            command     => "${scriptpath} all ttl; ${scriptpath} truthy nt",
            environment => 'MAILTO=ops-dumps@wikimedia.org',
            user        => $user,
            minute      => '0',
            hour        => '23',
            weekday     => '1',
            require     => File[$scriptpath],
        }
    }
}


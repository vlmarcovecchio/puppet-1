# == class: dnsrecursor::labsaliaser
#
# Provision a script and cron job to setup private IP space answers for dns
# lookups that resolve to public ips and add other misc records.
class dnsrecursor::labsaliaser(
    $username,
    $password,
    $nova_api_url,
    $extra_records,
    $alias_file,
    $observer_project_name,
) {

    $config = {
        'username'              => $username,
        'password'              => $password,
        'output_path'           => $alias_file,
        'nova_api_url'          => $nova_api_url,
        'extra_records'         => $extra_records,
        'observer_project_name' => $observer_project_name,
    }

    file { '/etc/labs-dns-alias.yaml':
        ensure  => present,
        owner   => 'root',
        group   => 'root',
        mode    => '0440',
        content => ordered_yaml($config),
    }

    file { '/usr/local/bin/labs-ip-alias-dump.py':
        ensure => present,
        owner  => 'root',
        group  => 'root',
        mode   => '0550',
        source => 'puppet:///modules/dnsrecursor/labs-ip-alias-dump.py',
    }

    cron { 'labs-ip-alias-dump':
        ensure  => 'present',
        user    => 'root',
        command => 'if ! `/usr/local/bin/labs-ip-alias-dump.py --check-changes-only`; then /usr/local/bin/labs-ip-alias-dump.py; /usr/bin/rec_control reload-lua-script; fi',
        minute  => 30,
        require => File[
            '/usr/local/bin/labs-ip-alias-dump.py',
            '/etc/labs-dns-alias.yaml'
        ],
    }
}

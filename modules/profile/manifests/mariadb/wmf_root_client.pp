# hosts with client utilities to conect to remote servers
# This role provides remote access to mysql server
# **DO NOT ADD** to non-dedicated hosts**
class profile::mariadb::wmf_root_client {

    # prevent accidental addition on a db server or a non-dedicated client
    if !($::fqdn in ['neodymium.eqiad.wmnet', 'sarin.codfw.wmnet']) {
        fail('role::mariadb::wmf_root_client should only be used on root-owned, \
             dedicated servers.')
    }

    class { 'mariadb::packages_client': }
    include passwords::misc::scripts

    class { 'mariadb::config':
        config   => 'profile/mariadb/mysqld_config/root_client.my.cnf.erb',
        socket   => '/run/mysqld/client.sock', # use a non default one
        ssl      => 'puppet-cert',
        ssl_ca   => '/etc/ssl/certs/Puppet_Internal_CA.pem',
        ssl_cert => '/etc/mysql/ssl/cert.pem',
        ssl_key  => '/etc/mysql/ssl/server.key',
        datadir  => false,
    }

    $password = $passwords::misc::scripts::mysql_root_pass
    $labsdb_password = $passwords::misc::scripts::mysql_labsdb_root_pass
    file { '/root/.my.cnf':
        owner   => 'root',
        group   => 'root',
        mode    => '0400',
        content => template('mariadb/root.my.cnf.erb'),
    }

}

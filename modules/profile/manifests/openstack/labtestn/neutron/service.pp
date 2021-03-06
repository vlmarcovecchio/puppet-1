class profile::openstack::labtestn::neutron::service(
    $version = hiera('profile::openstack::labtestn::version'),
    ) {

    require ::profile::openstack::labtestn::clientlib
    require ::profile::openstack::labtestn::neutron::common
    class {'::profile::openstack::base::neutron::service':
        version => $version,
    }
    contain '::profile::openstack::base::neutron::service'
}

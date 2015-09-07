class role::labs::k8s::master {
    $master_host = hiera('k8s_master', $::fqdn)
    $etcd_servers = hiera('etcd_servers')

    class { 'k8s::apiserver':
        master_host => $master_host,
        etcd_servers => $etcd_servers,

    }

    class { 'k8s::scheduler':
        master_host => $master_host,
    }

    class { 'k8s::controller':
        master_host => $master_host,
    }
}

class role::labs::k8s::worker {
    include k8s::docker

    $master_host = hiera('k8s_master', $::fqdn)

    class { 'k8s::proxy':
        master_host => $master_host,
    }

    class { 'k8s::kubelet':
        master_host => $master_host,
    }
}

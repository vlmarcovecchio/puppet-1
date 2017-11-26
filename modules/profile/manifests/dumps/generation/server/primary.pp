class profile::dumps::generation::server::primary {
    class { '::dumpsuser': }
    class { '::dumps::deprecated::user': }

    class { '::dumps::generation::server::dirs':
        user             => $dumpsuser::user,
        group            => $dumpsuser::group,
        deprecated_user  => 'datasets',
        deprecated_group => 'datasets',
    }

    class { '::dumps::generation::server::rsyncer':
        xmldumpsdir    => '/data/xmldatadumps',
        xmlremotedirs  => 'dumpsdata1002.eqiad.wmnet::data/xmldatadumps/public/,dataset1001.wikimedia.org::data/xmldatadumps/public/,labstore1006.wikimedia.org::data/xmldatadumps/public/',
        miscdumpsdir   => '/data/otherdumps',
        miscremotedirs => 'dumpsdata1002.eqiad.wmnet::data/otherdumps/,dataset1001.wikimedia.org::data/xmldatadumps/public/other/,labstore1006.wikimedia.org::data/xmldatadumps/public/other/',
    }
}

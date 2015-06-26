# installs required packages for a planet-venus server
class planet::packages {

    # the main package
    # prefer to update this manually
    package { 'planet-venus':
        ensure => 'present',
    }

    # XSLT 1.0 command line processor
    package { 'xsltproc':
        ensure => 'present',
    }

}

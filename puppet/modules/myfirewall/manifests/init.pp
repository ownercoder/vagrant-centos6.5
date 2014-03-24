class myfirewall {
    $ipv4_file = $operatingsystem ? {
        /(RedHat|CentOS)/ => '/etc/sysconfig/iptables',
    }
 
    exec { "purge default firewall":
        command => "/sbin/iptables -F && /sbin/iptables-save > $ipv4_file && /sbin/service iptables restart",
        onlyif  => "/usr/bin/test `/bin/grep \"Firewall configuration written by\" $ipv4_file | /usr/bin/wc -l` -gt 0",
        user    => 'root',
    }
 
    /* Make the firewall persistent */
    exec { "persist-firewall":
        command     => "/bin/echo \"# This file is managed by puppet. Do not modify manually.\" > $ipv4_file && /sbin/iptables-save >> $ipv4_file", 
        refreshonly => true,
        user        => 'root',
    }
 
    /* purge anything not managed by puppet */
    resources { 'firewall':
        purge => true,
    }
 
    firewall { "001 accept all icmp requests":
        proto => 'icmp',
        action  => 'accept',
    }
 
    firewall { '002 INPUT allow loopback':
        iniface => 'lo',
        chain   => 'INPUT',
        action    => 'accept',
    }
 
    firewall { '000 INPUT allow related and established':
        state => ['RELATED', 'ESTABLISHED'],
        action  => 'accept',
        proto => 'all',
    }
 
    firewall { '100 allow ssh':
        state => ['NEW'],
        dport => '22',
        proto => 'tcp',
        action  => 'accept',
    }

    firewall { '101 allow http':
        state => ['NEW'],
        dport => '80',
        proto => 'tcp',
        action  => 'accept',
    }
 
    firewall { "998 deny all other requests":
        action   => 'reject',
        proto  => 'all',
        reject => 'icmp-host-prohibited',
    }
 
    firewall { "999 deny all other requests":
        chain  => 'FORWARD',
        action   => 'reject',
        proto  => 'all',
        reject => 'icmp-host-prohibited',
    }
}
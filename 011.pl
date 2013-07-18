























     use Hypertable::ThriftClient;
     my $ht = Hypertable::ThriftClient->new($master, $port);
     my $ns = $ht->namespace_open($namespace);
     #...
     my $users_mutator = $ht->mutator_open($ns, 'users', $ignore_unknown_cfs, 10);
     #...

     my $keys = Hypertable::ThriftGen::Key->new({ row => $row, column_family => $cf, column_qualifier => $cq });
     my $cell = Hypertable::ThriftGen::Cell->new({key => $keys, value => $val});
     $ht->mutator_set_cell($mutator, $cell);
     $ht->mutator_flush($mutator);
     $ht->mutator_close($users_mutator);



























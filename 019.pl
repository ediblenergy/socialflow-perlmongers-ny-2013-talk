











     #!/usr/bin/env perl
     use strictures 1;
     use CPAN::Mini::Inject;
     use 5.10.0;
     my $mcpani = CPAN::Mini::Inject->new;
     my $file = $ARGV[0] or die "$@ $!";
     my $cfg = $mcpani->config_class->new;
     for (
         [ 'local',      '/home/mcpani/mirror' ],
         [ 'repository', '/home/mcpani/SocialFlowCPAN/dists' ],
         [ 'dirmode',    '0755' ]
       )
     {
         $cfg->set( $_->[0], $_->[1] );
     }
     $mcpani->config($cfg);
     $mcpani->readlist;

     $mcpani->add(
         authorid => "SOCIALFLOW",
         file     => $file
     );

     my @added = $mcpani->added_modules;
     foreach my $added (@added) {
         print "\nAdding File: $added->{file}\n";
         print "Author ID: $added->{authorid}\n";
         my $modules = $added->{modules};
         foreach my $mod ( sort keys %$modules ) {
             print "Module: $mod\n";
             print "Version: $modules->{$mod}\n";
         }
         print "To repository: $mcpani->{config}{repository}\n\n";
     }
     $mcpani->writelist;
















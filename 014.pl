






















     my $id = 0;
     my $bloom = Algorithm::Dablooms->new({
         capacity => 20_000,
         error_rate => 0.05,
         filename => $bloom_file,
     });

     #...

     $bloom->add("Sam Kaufman", ++$id);

     #later

     $bloom->contains( $entity );


























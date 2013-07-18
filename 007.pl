




     my $id = 0;
     my $bloom = Algorithm::Dablooms->new({
         capacity => 20_000,
         error_rate => 0.05,
         filename => $bloom_file,
     });

     #...

     $bloom->add("Grand Duchess Anastasia Nikolaevna of Russia", ++$id);

     #later

     $bloom->contains( "Grand Duchess Anastasia Nikolaevna of Russia" ); #its true!









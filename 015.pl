     package SocialFlow::Schema::ResultBase;
     use strictures 1;
     #use Devel::SimpleTrace;
     use DBIx::Class::Candy ();
     use Import::Into;
     use SocialFlow::Schema::Util ();
     #use boolean ();
     use Carp ();
     use Safe::Isa;
     use Data::Dumper::Concise;
     use List::Util qw(first);


     sub _schema_specific_components {
         my $class = shift;
         ## This should be implemented by the child if any additional
         # components must be loaded by all result classes
         return ();
     }

     sub _default_result_namespace {
         my $class = shift;
         ## Override if you want, reasonable default
         return sub () { $class->_schema_class . '::Result' };
     }

     sub _schema_class {
         die "_schema_class must be implemented by child class";
     }

     sub _candy_components {
         my($class,$params) = @_;
         my @imports = qw[
           TimeStamp
           +SocialFlow::Schema::Util
           Helper::Row::RelationshipDWIM
           Helper::Row::ProxyResultSetMethod
           ];
         push (@imports, $class->_schema_specific_components);
         if( $params->{extra_components} ) {
             push( @imports, @{ delete $params->{extra_components} } );
         }
         return \@imports;
     }

     sub import {
         my ( $class, $params ) = @_;
         my $target = caller;
         strictures->import::into($target,1);
         indirect->import::into($target);
         DBIx::Class::Candy->import::into( $target,
             -components => $class->_candy_components($params), );
         #boolean->import::into($target);
         Carp->import::into($target);
         Data::Dumper::Concise->import::into($target);
         Safe::Isa->import::into($target);
         {
             #For https://metacpan.org/module/DBIx::Class::Helper::Row::RelationshipDWIM
             no strict 'refs';
             no warnings 'once';
             *{"$target\::default_result_namespace"} = $class->_default_result_namespace;
         }
     }


                                           Company CPAN

     * Dependencies are mixed with regular cpan deps:
         ex: SocialFlow::Performance = 1.2

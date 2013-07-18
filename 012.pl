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

             *{"$target\::sqlt_deploy_hook"} =
               _sqlt_deploy_hook( $class->_schema_class )
               unless *{"$target\::sqlt_deploy_hook"};
         }
     }


     # Installed into the source at import time
     sub _sqlt_deploy_hook {
         my $schema_class = shift;
         return sub() {
             my ( $source, $sqlt_table ) = @_;

             # check for renamed constraints
             for my $rel ( $source->relationships ) {

                 my $rel_info = $source->relationship_info($rel);

                 next unless $rel_info->{attrs}{constraint_name};

                 unless ( ref $source ) {
                     $source = $schema_class->source($source);
                 }

                 # Work out the old constraint name
                 my $relsource = $source->related_source($rel);
                 my $idx;
                 my %other_columns_idx =
                   map { 'foreign.' . $_ => ++$idx } $relsource->columns;
                 my @cond =
                   sort { $other_columns_idx{$a} cmp $other_columns_idx{$b} }
                   keys( %{ $rel_info->{cond} } );
                 my @keys = map { $rel_info->{cond}->{$_} =~ /^\w+\.(\w+)$/ } @cond;

                 my $old_name = join( '_', $source->name, 'fk', @keys );

                 my ($c) = first {
                     $_->type eq SQL::Translator::Schema::Constants::FOREIGN_KEY()
                       && $_->name eq $old_name;
                 }
                 $sqlt_table->get_constraints;

                 $c->name( $rel_info->{attrs}{constraint_name} );
             }
         };
     }

     1;

     =head1 NAME
     Parent class that schema specific ::ResultBase classes are children of. Sets up DBIx candy and imports other useful modules into dbix result classes

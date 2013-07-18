     package SocialFlow::Schema::Util;
     use strictures 1;
     # ABSTRACT: Shared Schema column constants and utils

     use DBIx::Class::Candy::Exports;
     use JSON::XS;

     my $json = JSON::XS->new;
     sub json { $json }

     use constant {
         text      => 'text',
         citext    => $ENV{CITEXT} || 'citext',
         serial    => ( $ENV{SERIAL} ) || 'serial',
         integer   => 'integer',
         bigint    => 'bigint',
         smallint  => 'smallint',
         inet      => 'inet',
         float     => 'float',
         timestamp => 'timestamp',
         date      => 'date',
         enum      => 'enum',
         bool  => 'boolean',    #namespace collision with boolean.pm
         true  => 1,
         false => 0,
     };

     sub _type_column {
         my($class,$type,$col,$params) = @_;
         $params ||= {};
         $class->add_column( $col => { data_type => $type, %$params } )
     }

     sub integer_column {
         shift->_type_column(integer,@_);
     }

     sub bigint_column {
         shift->_type_column(bigint,@_);
     }

     sub text_column {
         shift->_type_column(text,@_);
     }

     sub citext_column {
         shift->_type_column(citext,@_);
     }

     sub date_column {
         shift->_type_column(date,@_);
     }

     sub timestamp_column {
         shift->_type_column(timestamp,@_);
     }

     sub boolean_column {
         shift->_type_column(bool,@_);
     }

     sub bool_column {
         shift->boolean_column(@_);
     }

     sub float_column {
         shift->_type_column(float,@_);
     }

     sub create_date_column {
         shift->add_columns(
             create_date => { data_type => timestamp, set_on_create => 1, @_ } );
     }

     sub is_active_column {
         my($class,$default) = @_;
         $default //= 1;
         shift->add_columns(
             is_active => { data_type => bool, default_value => $default }
         );
     }

     sub update_date_column {
         shift->add_columns(
             update_date => {
                 data_type     => timestamp,
                 set_on_create => 1,
                 set_on_update => 1,
                 @_
             } );
     }


     export_methods(
         [
             qw(
               integer_column
               bigint_column
               text_column
               citext_column
               date_column
               timestamp_column
               float_column
               boolean_column
               create_date_column
               update_date_column
               is_active_column

               text
               citext
               timestamp
               date
               bool
               serial
               integer
               bigint
               smallint
               inet
               float
               enum


               true
               false
               )
         ]
     );
     1;

     =head1 NAME

     SocialFlow::Schema::Util - Shared functionality across all sf schemata

     =head1 SYNOPSIS

         use DBIx::Class::Candy
             -components => [qw(
                 +SocialFlow::Schema::Util
             )];

     =head1 DESCRIPTION

     =head1 AUTHOR

     skaufman@socialflow.com

     =head1 COPYRIGHT

     Copyright (c) %s the %s L</AUTHOR> and L</CONTRIBUTORS>
     as listed above.

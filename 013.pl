     use strict;
     use warnings;

     package SocialFlow::Web::Schema::Result::Client;
     use SocialFlow::Billing::ProductType qw[ :all ];
     use parent 'SocialFlow::Web::Schema::Result';
     __PACKAGE__->load_components(qw/TimeStamp +SocialFlow::Web::Schema::Component::Roles/);
     __PACKAGE__->table('client');
     __PACKAGE__->add_columns(
         client_id        => { data_type => 'serial', },
         client_source_id => { data_type => 'integer'  },
         company          => { data_type => 'citext', accessor => '_company' },    # case insensitive
         website_url      => { data_type => 'text', },
         access_tier      => { data_type => 'smallint', default_value => 0 },    # standard / business / enterprise (use sub tier - below)
         active           => { data_type => 'smallint' },    # active, deleted, ?
         opted_in         => { data_type => 'boolean', default_value => 'false' },
         create_date      => { data_type => 'timestamp', set_on_create => 1 },
         max_social_accts => { data_type => 'integer',  default_value => 0 },
         default_time_zone => { data_type => 'text', default_value => 'UTC' },
     );

     # recurrence
     # 0 - Monthly
     # 1 = Yearly

     __PACKAGE__->set_primary_key("client_id");
     __PACKAGE__->belongs_to(
         client_source => 'SocialFlow::Web::Schema::Result::ClientSource',
         'client_source_id'
     );
     __PACKAGE__->has_many(
         client_appusers => 'SocialFlow::Web::Schema::Result::ClientAppuser',
         'client_id'
     );
     __PACKAGE__->many_to_many(
         appusers => 'client_appusers',
         'appuser'
     );
     __PACKAGE__->has_many(
         client_appuser_roles =>
             'SocialFlow::Web::Schema::Result::ClientAppuserRole',
         'client_id'
     );

     #......
     1;

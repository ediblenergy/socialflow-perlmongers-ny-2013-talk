     package SocialFlow::Web::Schema::Result::Client;
     use SocialFlow::Web::Schema::ResultBase {
         extra_components => [
             qw[
               +SocialFlow::Web::Schema::Component::Roles
               ] ] };

     table('client');

     primary_column client_id => { data_type => serial };

     integer_column 'client_source_id';

     column company => { data_type => citext, accessor => '_company' };

     text_column 'website_url';

     column access_tier => { data_type => smallint, default_value => 0 };

     # Rename the accessor since this is not a boolean as the column name would suggest.
     column active => { data_type => smallint, accessor => '_active' };

     boolean_column opted_in => { default_value => 0 };

     timestamp_column create_date => { set_on_create => true };

     integer_column max_social_accts => { default_value => 0 };

     text_column default_time_zone => { default_value => 'UTC' };

     # recurrence
     # 0 - Monthly
     # 1 = Yearly

     belongs_to(
         client_source => '::ClientSource',
         'client_source_id'
     );
     has_many(
         client_appusers => '::ClientAppuser',
         'client_id'
     );
     many_to_many(
         appusers => 'client_appusers',
         'appuser'
     );
     has_many(
         client_appuser_roles =>
             '::ClientAppuserRole',
         'client_id'
     );

     #......

     1;

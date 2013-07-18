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

     has_many(
         client_services => '::ClientService',
         'client_id'
     );

     has_many(
         appuser_client_services =>
             '::AppuserClientService',
         'client_id'
     );
     has_many(
         content_queues => '::ContentQueue',
         'client_id'
         );

     has_many(
         email_transactions =>
             '::EmailTransaction',
         'client_id'
     );
     might_have(
         lead => '::SalesforceClientLead',
         'client_id'
         );

     has_many(
         credit_cards => '::ClientCreditCard',
         'client_id'
     );

     might_have(
         billing_address => '::BillingAddress',
         'client_id'
         );

     has_many(
         receipts => '::Receipt',
         'client_id'
         );

     has_many(
         opportunities => '::SalesforceOpportunity',
         'client_id'
         );

     has_many(
         api_consumers =>
             '::APIConsumer',
             'client_id'
         );

     has_many(
         feed_sources => '::FeedSource', 'client_id'
     );

     has_many(
         braintree_orders => '::BraintreeOrder',
         'client_id',
         );

     has_many(
         groups => "::ClientGroup", 'client_id'
     );

     has_many(
         client_service_groups => '::ClientServiceGroup', 'client_id'
     );

     has_many(
         client_group_appusers => '::ClientGroupAppuser', 'client_id'
     );
     has_many(
         client_config_parameters =>
             '::ClientConfigParameter',
         'client_id'
     );
     many_to_many(
         config_parameters => 'client_config_parameters', 'config_parameter'
     );

     has_many(
         content_sources => '::ContentSource',
         'client_id'
     );

     might_have(
         bitly_credential_client => '::BitlyCredentialClient',
         'client_id'
         );

     has_many(
         bitly_credentials => '::BitlyCredential',
         'client_id'
     );

     might_have(
         googl_credential_client => '::GooglCredentialClient',
         'client_id'
         );

     has_many(
         googl_credentials => '::GooglCredential',
         'client_id'
     );
     might_have(
         trial_period => '::ClientTrialPeriod',
         'client_id'
     );

     has_many(
         promo_codes => '::ClientPromoCode',
         'client_id'
     );

     has_many(
         report_links => '::ReportLink',
         'client_id'
     );

     might_have(
         tribal_client => '::TribalClient',
         'client_id'
     );

     has_many(
         tribal_client_services => '::TribalClientService',
         'client_id'
     );

     might_have(
         tribal_credential_client => '::TribalCredentialClient',
         'client_id'
     );

     has_many(
         tribal_credentials => '::TribalCredential',
         'client_id'
     );

     has_many(
         client_socialflow_products =>
         '::ClientSocialFlowProduct',
         'client_id'
     );

     has_many(
         client_performance_reports =>
         '::ClientPerformanceReport',
         'client_id'
     );

     has_many(
         attention_accounts => '::Attention::Account', 'client_id'
     );

     has_many(
         subscriptions => '::BTSubscription',
         'client_id'
     );

     has_many tracker_groups => '::TrackerGroup', 'client_id';

     has_many rulesets => '::TrackerClientRuleSet', 'client_id';

     might_have attention_client_budget => '::Attention::ClientBudget', 'client_id';

     has_many attention_account_budgets => '::Attention::AccountBudget', 'client_id';

     has_many
       attention_ad_campaign_set_budgets => '::Attention::AdCampaignSetBudget',
       'client_id';

     has_many
       attention_ad_campaign_budgets => '::Attention::AdCampaignBudget',
       'client_id';

     has_many
       attention_client_transactions => '::Attention::ClientTransaction',
       'client_id';

     has_many command_centers => '::CommandCenter', 'client_id';

     has_many client_labels => '::ClientLabel', 'client_id';

     has_many client_socialflow_sites => '::ClientSocialFlowSite', 'client_id';

     has_many socialflow_site => '::SocialFlowSite', 'site_id';

     many_to_many socialflow_sites => 'client_socialflow_sites', 'socialflow_site';

     sub Active {
         return +{
             0 => 'lead',
             1 => 'active',
             2 => 'canceled',
             3 => 'suspended',
             4 => 'opt-in expired',
         };
     }

     sub ActiveValues() {
         state $lookup = { reverse %{Active()} };
         $lookup;
     }

     sub status {
         my $self = shift;
         return Active->{$self->_active};
     }

     sub is_active {
         my ($self) = @_;
         $self->_active == ActiveValues->{'active'};
     }

     sub set_status {
         my ($self, $desired) = @_;

         my $codes = ActiveValues();

         exists $codes->{$desired} or croak "Unknown client status $desired";

         $self->_active($codes->{$desired});
     }

     sub social_accounts_left {
         my ($self) = @_;

         # 0 means unlimited. The easiest way to express this in perl is +Infinity.
         # Is this the best value to return? Makes sense for comparisons, but maybe
         # not if its displayed directly.
         return "Inf" if $self->max_social_accts == 0;

         my $total_accounts = $self->client_services->active_publishing_accounts->valid;
         my $limit = $self->max_social_accts;
         return $limit - $total_accounts;
     }

     sub tier {
         my $self = shift;

         if ( my $arg = shift ) {
             my %map = ( standard => 0, business => 1, enterprise => 2 );
             $self->access_tier( $map{ lc $arg } );
         }

         my $index = $self->access_tier;
         my @arr = (qw/standard business enterprise/);
         return $arr[$index];
     }

     sub superadmin_appuser {
         my $self = shift;
         my $admin_appuser_role =
             $self->client_appuser_roles->search( { role_id => $self->SuperAdmin() },
             { rows => 1 } )->first;
         return unless $admin_appuser_role;
         return $admin_appuser_role->appuser;
     }

     sub billing_contact_appuser {
         my $self = shift;
         my $role =
             $self->client_appuser_roles->search( { 'name' => 'billing contact' },
             { 'prefetch' => 'role', 'rows' => 1 } )->single;
         return unless $role;
         return $role->appuser;

     }

     # since company names are optional, wrap the accessor and return
     # the name of the superadmin user if needed
     sub company {
         my $self = shift;

         return $self->_company( @_ ) if @_;

         my $comp = $self->_company;
         return $comp if defined $comp && $comp =~ m{\w};

         my $user = $self->superadmin_appuser;
         return '' unless $user;

         return $user->full_name;
     }

     sub default_card {
         my $self = shift;
         return unless $self->credit_cards;
         return $self->credit_cards->search({ is_default => 'true', is_active => 'true' })->single;
     }

     sub add_appuser {
         my ( $self, $appuser_hash ) = @_;
         my $schema  = $self->result_source->schema;
         my $guard   = $schema->txn_scope_guard;
         my $appuser = $self->add_to_appusers($appuser_hash);
         for ( $self->SuperAdmin(), $self->LeadContact(), $self->BillingContact() ) {
             my $rs = $self->client_appuser_roles;
             $rs->count( { role_id => $_ } )
                 or $rs->create( { appuser_id => $appuser->id, role_id => $_ } );
         }
         $self->client_config_parameters->create( {
                 config_parameter_id =>
                     $schema->config_param_by_name->{"Client::receipt_recipients"}
                     ->{config_parameter_id},
                 value => $appuser->email
             } );

         $guard->commit;
         return $appuser;
     }

     sub get_client_shortener {
         my $self = shift;
         return unless $self->tribal_credential_client;
         return $self->tribal_credential_client;
     }

     sub get_bitly_creds {
         my $self = shift;
         return unless $self->bitly_credential_client;
         return $self->bitly_credential_client;
     }

     sub get_googl_creds {
         my $self = shift;
         return unless $self->googl_credential_client;
         return $self->googl_credential_client;
     }

     1;

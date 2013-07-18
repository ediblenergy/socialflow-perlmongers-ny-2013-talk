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

     __PACKAGE__->has_many(
         client_services => 'SocialFlow::Web::Schema::Result::ClientService',
         'client_id'
     );

     __PACKAGE__->has_many(
         appuser_client_services =>
             'SocialFlow::Web::Schema::Result::AppuserClientService',
         'client_id'
     );
     __PACKAGE__->has_many(
         content_queues => 'SocialFlow::Web::Schema::Result::ContentQueue',
         'client_id'
         );

     __PACKAGE__->has_many(
         email_transactions =>
             'SocialFlow::Web::Schema::Result::EmailTransaction',
         'client_id'
     );
     __PACKAGE__->might_have(
         lead => 'SocialFlow::Web::Schema::Result::SalesforceClientLead',
         'client_id'
         );

     __PACKAGE__->has_many(
         credit_cards => 'SocialFlow::Web::Schema::Result::ClientCreditCard',
         'client_id'
     );

     __PACKAGE__->might_have(
         billing_address => 'SocialFlow::Web::Schema::Result::BillingAddress',
         'client_id'
         );

     __PACKAGE__->has_many(
         receipts => 'SocialFlow::Web::Schema::Result::Receipt',
         'client_id'
         );

     __PACKAGE__->has_many(
         braintree_receipts => 'SocialFlow::Web::Schema::Result::BraintreeReceipt',
         'client_id'
         );

     __PACKAGE__->has_many(
         opportunities => 'SocialFlow::Web::Schema::Result::SalesforceOpportunity',
         'client_id'
         );

     __PACKAGE__->has_many(
         api_consumers =>
             'SocialFlow::Web::Schema::Result::APIConsumer',
             'client_id'
         );

     __PACKAGE__->has_many(
         feed_sources => 'SocialFlow::Web::Schema::Result::FeedSource', 'client_id'
     );

     __PACKAGE__->has_many(
         google_transactions => 'SocialFlow::Web::Schema::Result::GoogleCheckoutTransaction',
         'client_id'
         );

     __PACKAGE__->has_many(
         braintree_transactions => 'SocialFlow::Web::Schema::Result::BraintreeTransaction',
         'client_id'
         );

     __PACKAGE__->has_many(
         google_checkout_orders => 'SocialFlow::Web::Schema::Result::GoogleCheckoutOrder',
         'client_id'
         );

     __PACKAGE__->has_many(
         braintree_orders => 'SocialFlow::Web::Schema::Result::BraintreeOrder',
         'client_id',
         );

     __PACKAGE__->has_many(
         groups => "SocialFlow::Web::Schema::Result::ClientGroup", 'client_id'
     );

     __PACKAGE__->has_many(
         client_service_groups => 'SocialFlow::Web::Schema::Result::ClientServiceGroup', 'client_id'
     );

     __PACKAGE__->has_many(
         client_group_appusers => 'SocialFlow::Web::Schema::Result::ClientGroupAppuser', 'client_id'
     );
     __PACKAGE__->has_many(
         client_config_parameters =>
             'SocialFlow::Web::Schema::Result::ClientConfigParameter',
         'client_id'
     );
     __PACKAGE__->many_to_many(
         config_parameters => 'client_config_parameters', 'config_parameter'
     );

     __PACKAGE__->has_many(
         content_sources => 'SocialFlow::Web::Schema::Result::ContentSource',
         'client_id'
     );

     __PACKAGE__->might_have(
         bitly_credential_client => 'SocialFlow::Web::Schema::Result::BitlyCredentialClient',
         'client_id'
         );

     __PACKAGE__->has_many(
         bitly_credentials => 'SocialFlow::Web::Schema::Result::BitlyCredential',
         'client_id'
     );

     __PACKAGE__->might_have(
         googl_credential_client => 'SocialFlow::Web::Schema::Result::GooglCredentialClient',
         'client_id'
         );

     __PACKAGE__->has_many(
         googl_credentials => 'SocialFlow::Web::Schema::Result::GooglCredential',
         'client_id'
     );
     __PACKAGE__->might_have(
         trial_period => 'SocialFlow::Web::Schema::Result::ClientTrialPeriod',
         'client_id'
     );

     __PACKAGE__->has_many(
         promo_codes => 'SocialFlow::Web::Schema::Result::ClientPromoCode',
         'client_id'
     );

     __PACKAGE__->has_many(
         report_links => 'SocialFlow::Web::Schema::Result::ReportLink',
         'client_id'
     );

     __PACKAGE__->might_have(
         tribal_client => 'SocialFlow::Web::Schema::Result::TribalClient',
         'client_id'
     );

     __PACKAGE__->has_many(
         tribal_client_services => 'SocialFlow::Web::Schema::Result::TribalClientService',
         'client_id'
     );

     __PACKAGE__->has_many(
         client_socialflow_products =>
         'SocialFlow::Web::Schema::Result::ClientSocialFlowProduct',
         'client_id'
     );

     __PACKAGE__->has_many(
         client_performance_reports =>
         'SocialFlow::Web::Schema::Result::ClientPerformanceReport',
         'client_id'
     );

     __PACKAGE__->has_many(
         attention_accounts => 'SocialFlow::Web::Schema::Result::AttentionAccount', 'client_id'
     );

     __PACKAGE__->has_many(
         billing_subscriptions => 'SocialFlow::Web::Schema::Result::BillingSubscription',
         'client_id'
     );
     sub Active {
         return +{
             0 => 'lead',
             1 => 'active',
             2 => 'canceled',
             3 => 'suspended',
             4 => 'opt-in expired',
         };
     }

     sub status {
         my $self = shift;
         return Active->{$self->active};
     }

     =method monthly_order

     Can only have 1 monthly order at any given time.

     =cut
     sub monthly_order {
         my ($self) = @_;

         # look for braintree orders
         my @orders = $self->braintree_orders->search(
             { is_monthly =>'true',
               status => { -not_in  => ['canceled', 'not_yet_invoiced'] } });
         foreach (@orders) {
             next if ($_->socialflow_product->is_trial);
             return $_;
         }

         # if none found look for google checkout orders
         my $order = $self->google_checkout_orders->search(
             { 'is_monthly' =>'true',
               status => { -not_in  => ['canceled'] } })->single;
         return $order;
     }

     # deprecated
     sub monthly_bt_accounts {
         my ($self) = @_;
         my $total = 0;
         my @orders = $self->braintree_orders->search(
             { is_monthly =>'true',
               status => { -not_in  => ['canceled', 'not_yet_invoiced'] } });

         foreach my $order (@orders) {
             next if ($order->socialflow_product->is_trial);
             $total += $order->number_accounts;
         }

         return $total;
     }

     # deprecated
     sub yearly_bt_accounts {
         my ($self) = @_;
         my $total = 0;
         my @orders = $self->braintree_orders->search(
             { is_monthly => 'false',
               status => { -not_in  => ['canceled', 'not_yet_invoiced'] } });
         foreach my $order (@orders) {
             $total += $order->number_accounts;
         }

         return $total;
     }

     sub num_monthly_accounts {
         my ($self) = @_;
         my $total = 0;
         my @orders = $self->braintree_orders->search(
             { is_monthly =>'true',
               status => { -not_in  => ['canceled', 'not_yet_invoiced'] } });
         foreach my $order (@orders) {
             $total += $order->number_accounts;
         }
         @orders = $self->google_checkout_orders->search(
             { 'is_monthly' =>'true',
               status => { -not_in  => ['canceled'] } });

         foreach my $order (@orders) {
             next if ($order->socialflow_product->is_trial);
             $total += $order->num_accounts;
         }

         return $total;
     }

     sub num_yearly_accounts {
         my $self = shift;

         my $total = 0;
         my @orders = $self->braintree_orders->search(
             { is_monthly => 'false',
               status => { -not_in  => ['canceled', 'not_yet_invoiced'] } });
         foreach my $order (@orders) {
             $total += $order->number_accounts;
         }
         @orders = $self->google_checkout_orders->search(
             { 'is_monthly' => 'false',
               status => { -not_in  => ['canceled'] } });
         foreach my $order (@orders) {
             $total += $order->num_accounts;
         }

         return $total;
     }


     sub add_promo {
         my ($self, $promo) = @_;
         my $found = $self->promo_codes->find({ promo_code_id => $promo->promo_code_id });
         if (!$found) {
             $self->add_to_promo_codes({ promo_code_id => $promo->promo_code_id });
         }
     }

     sub mark_promo_used {
         my ($self, $promo) = @_;
         $promo->update({ num_used => $promo->num_used + 1});
     }

     sub most_recent_promo {
         my $self = shift;
         return $self->promo_codes->search(
             {},
             { order_by => { -desc => 'create_date' } })->first;
     }

     sub start_trial {
         my $self        = shift;
         warn "STARTING TRIAL\n";
         my $today       = DateTime->today;
         my $trial_start = $today->clone->add( days => 1 );    #tomorrow at midnight
         my $trial_end = $trial_start->clone->add( months => 1 );
         warn "END DATE: " . $trial_end->datetime;
         my $ret = $self->create_related( "trial_period",
             { start_date => $trial_start, end_date => $trial_end } );
         $self->discard_changes;
         $ret;
     }

     sub trial_has_ended {
         my $self         = shift;
         my $trial_period = $self->trial_period;
         return 0 unless $trial_period;
         my $now = DateTime->now->epoch;
         return $trial_period->end_date->epoch < $now;
     }

     sub is_in_trial {
         my $self         = shift;
         my $trial_period = $self->trial_period;
         return 0 unless $trial_period;
         my $now = DateTime->now->epoch;
         if (   $now > $trial_period->start_date->clone->subtract( days => 1 )->epoch
             && $now < $trial_period->end_date->epoch )
         {
             return 1;
         }
         return 0;
     }

     sub end_trial {
         my $self         = shift;
         my $trial_period = $self->trial_period;
         return unless $trial_period;
         return unless $trial_period->end_date;
         my $now = DateTime->now->epoch;
         if ($trial_period->end_date->epoch > $now) {
             $trial_period->update({end_date => DateTime->today});
         }
     }

     sub num_orders {
         my $self = shift;
         my @bt_orders = $self->braintree_orders->search({ status => { -not_in  => ['canceled', 'not_yet_invoiced'] }});
         my @gc_orders = $self->google_checkout_orders->search({ status => {-not_in => ['canceled', 'not_yet_invoiced'] }});
         my $num = @bt_orders + @gc_orders;
         return $num;
     }

     # deprecated
     # find out the max # of social account this client can have
     sub account_limit {
         my $self = shift;

         if ($self->access_tier < 2) {
             return $self->access_tier + 1 if !$self->opted_in;

             my $limit = 0;
             my @bt_orders = $self->braintree_orders->search({ status => { -not_in  => ['canceled', 'not_yet_invoiced'] }});
             foreach my $order (@bt_orders) {
                 $limit += $order->number_accounts;
             }

             # TODO: fix this
             my @gc_orders = $self->google_checkout_orders->search({ status => {-not_in => ['canceled', 'not_yet_invoiced'] }});
             $limit += scalar(@gc_orders);
             return $limit;

         } else { #enterprise
             return $self->max_social_accts;
         }
     }

     sub accounts_left {
         my ($self) = @_;
         my $total_accounts = $self->client_services->active_publishing_accounts->valid;
         my $limit = $self->account_limit;
         warn "Changes reflected";
         my $left = $limit - $total_accounts;
         warn "Total [$total_accounts] Limit[$limit] Left[$left]";
         return $left;
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

     # can only have one at a time.
     # all monthly orders should have the same anniversary
     sub monthly_billing_anniversary {
         my $self = shift;
         my @bt_orders = $self->braintree_orders->search({ is_monthly => 1 });
         if (@bt_orders && @bt_orders > 0) {
             return $bt_orders[0]->anniversary_date->day;
         } else {
             my @gc_orders = $self->google_checkout_orders->search({ is_monthly => 1 });
             if (@gc_orders && @gc_orders > 0) {
                 return $gc_orders[0]->anniversary_date->day;
             }
         }

         return undef;
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
     1;

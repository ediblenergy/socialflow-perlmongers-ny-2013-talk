     use strictures 1;
     use JSON::XS;
     use SocialFlow::Reporting::Schema;
     use aliased 'SocialFlow::Web::Config::Cached' => 'SFConfig';
     use aliased 'SocialFlow::Reporting::Daemon::Timeline::Item::Facebook' =>
       'TimelineItem';
     use ZMQ;
     use ZMQ::Constants qw[ZMQ_PUB ZMQ_SUB ZMQ_SUBSCRIBE];
     use Data::Dumper::Concise;
     my $cfg = SFConfig->config;
     my $schema = SocialFlow::Reporting::Schema->connect($cfg->{reporting}{db});

     my $ctx = ZMQ::Context->new(5);
     my $subscriber = $ctx->socket( ZMQ_SUB );
     $subscriber->connect("tcp://facebook-1:5500");
     $subscriber->setsockopt(ZMQ_SUBSCRIBE, "");
     while ( my $msg = $subscriber->recv ) {
         my $obj = decode_json( $msg->data );
         unless( $obj->{created_time} && ( $obj->{message} || $obj->{description} ) ) {
             next;
         }
         my $ti = TimelineItem->new( %$obj, sf_reporting => $schema );
         $ti->run;
     }




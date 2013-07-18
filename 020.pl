     use strictures 1;

     package Dist::Zilla::Plugin::SocialFlow::Release;
     use Moose;
     use Path::Class ();
     use File::Copy  ();
     use Git::Wrapper;
     use Net::OpenSSH;
     use File::HomeDir::PathClass;

     with 'Dist::Zilla::Role::Releaser';

     # ABSTRACT: Releases modules into the SocialFlow minicpan mirror

     has ssh => (
       is      => "ro",
       isa     => "Net::OpenSSH",
       lazy    => 1,
       default => sub { Net::OpenSSH->new('mcpani@devdb') }
     );

     has config => (
       is      => "ro",
       isa     => "Path::Class::File",
       lazy    => 1,
       default => sub {
         File::HomeDir::PathClass->home->file('.sfcpanrc');
       }
     );

     has mcpan_repo => (
       is => 'ro',
       isa => 'Path::Class::Dir',
       lazy_build => 1
     );

     has git => (
       is      => "ro",
       isa     => "Git::Wrapper",
       lazy    => 1,
       default => sub { Git::Wrapper->new( shift->mcpan_repo ) }
     );

     sub _build_mcpan_repo {
       my ($self) = @_;
     my $s = $self->config->stat  ? $self->config->slurp : undef;
       return defined($s)
         && length($s)
         ? Path::Class::dir($s)
         : File::HomeDir::PathClass->home->subdir('SocialFlowCPAN');
     }

     sub release {
       my ( $self, $tarball ) = @_;
       $self->git->pull({rebase => 1});
       $self->copy_to_mcpan_repo($_), $self->git->add("dists/$_") for $tarball;
       $self->git->fetch;
       $self->git->commit( { message => "[RELEASE] $tarball" } );
       $self->git->push(qw[origin HEAD]);
     #  $self->git->push('--tags');
     #  $self->ssh_add_dist($tarball);
     }

     sub copy_to_mcpan_repo {
       my ( $self, $tarball ) = @_;
       my $target = $self->mcpan_repo->subdir('dists');
       File::Copy::copy( $tarball, $target->stringify )
         or die "Couldn't release $tarball: $!";
     }

     sub ssh_add_dist {
       my ( $self, $tarball ) = @_;
       $self->ssh->system("add_dist $tarball");
     }
     H

     1;

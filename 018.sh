     #!/bin/sh

     set -e

     # Dumbass minicpan replacement - Matt S Trout 2005/6. Perl license.

     # Pick one from http://cpan.org/SITES.html#RSYNC
     #rsync://mirrors.ibiblio.org/CPAN/
     REMOTEHOST=${REMOTEHOST-'mirror.cogentco.com'}
     REMOTEPREFIX=${REMOTEPREFIX-'CPAN'}

     # Can override mirror dir by putting it as first argument on command line
     LOCAL=${1-/home/mcpani/mirror}

     cd $LOCAL

     mkdir -p work authors/id modules

     rsync $REMOTEHOST::"$REMOTEPREFIX/modules/03modlist.data.gz $REMOTEPREFIX/modules/02packages.details.txt.gz" modules/
     rsync $REMOTEHOST::"$REMOTEPREFIX/authors/01mailrc.txt.gz" authors/

     zcat modules/02packages.details.txt.gz \
         | egrep '\.(tar\.gz|tgz|zip)$' \
         | egrep -v '/((perl-|parrot-|ponie-)[0-9]|perl5\.004)' \
         | awk '{print $3}' \
         | sort -u >work/targets.dists

     cat work/targets.dists \
         | cut -d'/' -f1-3 \
         | sort -u \
         | perl -pe 's!$!/CHECKSUMS!;' >work/targets.checksums

     cat work/targets.dists \
         | perl -pe 's!/[^/]+$!\n!;' >work/targets.dirs

     cd $LOCAL/authors/id

     cat $LOCAL/work/targets.dirs | xargs -n100 mkdir -p

     cat $LOCAL/work/targets.checksums | xargs -n100 touch

     cat $LOCAL/work/targets.dists | xargs -n100 touch

     cd $LOCAL

     rsync -vr --size-only --existing $REMOTEHOST::"$REMOTEPREFIX/authors/" authors/

     find authors/id -name '*.*' | perl -pe 's!^authors/id/!!;' | sort -u >work/tree.all

     sort -u work/targets.* | comm -13 - work/tree.all | perl -pe 's!^!authors/id/!;' | xargs --no-run-if-empty rm -v

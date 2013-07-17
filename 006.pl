


















    sub solve_for_business_request {
        my($self,$request) = @_;
        return $self->search_metacpan_for($request)
            || die "beats me";
    }























use Mac::FSEvents;
use IO::Select;
# or use Mac::FSEvents qw(:flags);

my $fs = Mac::FSEvents->new( {
	path    => '/Users/Eax/Perl/MatteShare/',       # required, the path to watch
	latency => 2.0,       # optional, time to delay before returning events
	since   => 451349510, # optional, return events from this eventId
	flags   => NONE,      # optional, set stream creation flags
} );

my $fh = $fs->watch;

# Select on this filehandle, or use an event loop:
my $sel = IO::Select->new($fh);
while ( $sel->can_read ) {
	my @events = $fs->read_events;
	for my $event ( @events ) {
		printf "Directory %s changed\n", $event->path;
	}
}

# or use blocking polling:
# stop watching
$fs->stop;

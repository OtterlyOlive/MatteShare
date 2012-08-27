use main;
use Linux::Inotify2;

# Create the notify object.
my $inotify = new Linux::Inotify2 or die "Unable to create the inotify object: $!";

# Create the watch.
$inotify->watch($config{'repo_dir'}, IN_ALL_EVENTS)
	or die "Did not create watch. Died instead";

# Event loop.
while () {
	$action = "none";
	my @events = $inotify->read;
	unless (@events > 0) {
		print "Read error: $!";
		last;
	}	

	if($events[0]->IN_CREATE){
		$action = "created";
	} elsif($events[0]->IN_MODIFY){
		$action = "edited";
	} elsif($events[0]->IN_MOVED_FROM){
		$action = "moved_from";
	} elsif($events[0]->IN_MOVED_TO){
		$action = "moved_to";
	} elsif($events[0]->IN_DELETE){
		$action = "deleted";
	}

	if ($action ne "none") {
		change_made($events[0]->fullname, $action);

			open FILE, ">config.cnf" or die $!; # Overwrite the file.

			while ( my ($setting, $value) = each(%config) ) {

				if ($setting eq "last_updated") {
					$value = `date`;
					chomp($value);
				}

				print FILE "$setting=$value\n";
			}

			close (FILE);
	}
}
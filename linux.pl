use main;
use Linux::Inotify2;

# Read the config file.

my $inotify = new Linux::Inotify2 or die "Unable to create the inotify object: $!";

# Create the watch.

$inotify->watch($config{'repo_dir'}, IN_ALL_EVENTS)
	or die "Did not create watch. Died instead";

while () {
	my @events = $inotify->read;
	unless (@events > 0) {
		print "Read error: $!";
		last;
	}

	foreach(@events){
		print $_->fullname."\n";
	}

	if($events[0]->IN_CREATE){
	#	change_made($events[0]->fullname, 'create');
		print $events[0]->fullname." has been created.\n";
	} elsif($events[0]->IN_MODIFY){
		print $events[0]->fullname." has been modified.\n";
	#	change_made($events[0]->fullname, 'modify');
	} elsif($events[0]->IN_OPEN){
		print $events[0]->fullname." has been opened.\n";
	} elsif($events[0]->IN_ACCESS){
		print $events[0]->fullname." has been accessed?.\n";
	} elsif($events[0]->IN_DELETE){
		print $events[0]->fullname." has been deleted!\n";
	} else {
		print "Changes on: ".$events[0]->fullname."\n";
	}

	print "Amount of changes: ".scalar(@events)."\n";
	print "===========================================================\n";

	#if($events[0]->IN_MODIFY){
	#	print $events[0]->fullname." has been modified.\n";	
	#}
}

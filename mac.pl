use main;
use Data::Dumper;

# Wuh! Application loop.
while(1) {
	$i = 0;
	my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

	$find_created = 'cd '.$config{'repo_dir'}.' && find . -newerBt "'.$config{'last_updated'}.'"';
	@created_files = `$find_created`;
	@files_to_commit;

	# Only split if there's more than one file!
	if(scalar($created_files)){
		@created_files = split(/\n/, $created_files);
		$length = scalar(@created_files);
	} else {
		$length = 0;
	}

	foreach (@created_files) {
		$result = index($_, '.git');

		if($result == -1) {
			# Loop through all already committed files, and check if this one has already been added.
			
			if ($_ ne ".") {
				# Push value to commit list.
				chomp($_);
				$files_to_commit[$length][0] = $_;
				$files_to_commit[$length][1] = 'created';
				$length++;
			}		
		}
	}


	# Find the modified files.
	$find_modified = 'cd '.$config{'repo_dir'}.' && find . -newerct "'.$config{'last_updated'}.'"';
	$modified_files = `$find_modified`;
	@modified_files = split(/\n/, $modified_files);
	$length = 0; # Amount of files added to $files_to_commit so far.

	# Get the length of created files, if 1, set to 1.
	if(scalar(@files_to_commit)){
		$length = scalar(@files_to_commit);
	} else {
		$length = 0;
	}

	foreach (@modified_files) {
		$result = index($_, '.git');
		if($result == -1) {

			if ($_ ne ".") {
				$exists = 0;

				for ($i = 0; $i < scalar(@files_to_commit); $i++ ) {
					if ($files_to_commit[$i][0] eq $_) {
						$exists = 1;
					}
				}

				if ($exists == 0) {
					# Push value to commit list.
					chomp($_);
					$files_to_commit[$length][0] = $_;
					$files_to_commit[$length][1] = 'edited';
					$length++;
				}
			}	
		}
	}

	for ($i = 0; $i < scalar(@files_to_commit); $i++) {
		$x = $files_to_commit[$i][0];
		$y = $files_to_commit[$i][1];
		# Add & commit file, when done, push, update config file.
		$x =~ s/.\///; # Replace ./ with nothing.
		change_made($x, $y);
	}

	open FILE, ">config.cnf" or die $!; # Overwrite the file.
	while ( my ($setting, $value) = each(%config) ) {

		if ($setting eq "last_updated") {
			$value = `date "+%Y-%m-%d %H:%M:%S"`;
			chomp($value);
		}

		print FILE "$setting=$value\n";
	}
	close (FILE);


	print "Done!";
	sleep($config{'sleep_time'});
}
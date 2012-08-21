use main;
$i = 0;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

# Read the config file - V
# Take all files made after last edit.
# Check if they're edited or created
# Make list of all the files.
# Run the commit function. (Also rename it)

$find_modified = 'cd '.$config{'repo_dir'}.' && find . -newerct "'.$config{'last_updated'}.'"';
$modified_files = `$find_modified`;
@modified_files = split(/\n/, $modified_files);
@files_to_commit;

foreach (@modified_files) {

	$result = index($_, '.git');
	if($result == -1) {
		
		if ($_ ne ".") {
			# Push value to commit list. (Do we commit one file at a time or all of them? Logically, I'd speak for one at at time, to make it easier to revert without loosing data.)
			push(@files_to_commit, $_);
		}		
		
	}

}

$find_created = 'cd '.$config{'repo_dir'}.' && find . -newerBt "'.$config{'last_updated'}.'"';
@created_files = `$find_created`;

foreach (@modified_files) {

	$result = index($_, '.git');
	if($result == -1) {
		# Loop through all already committed files, and check if this one has already been added.
		
		if ($_ ne ".") {
			$exists = 0;

			for ($i = 0; $i < scalar(@files_to_commit); $i++ ) {
				if ($files_to_commit[$i] eq $_) {
					$exists = 1;
				}
			}

			if ($exists == 0) {
				# Push value to commit list. (Do we commit one file at a time or all of them? Logically, I'd speak for one at at time, to make it easier to revert without loosing data.)
				push(@files_to_commit, $_);
			}
		}
			
				
	}

}

#for ($i = 0; $i < scalar(@created_files); $i++) {

#}

foreach (@files_to_commit) {
	# Add & commit file, when done, push, update config file.
	$_ =~ s/.\///; # Replace ./ with nothing.
	$add_command = "git add ".$_." && git commit -m"; 
	print $_."\n";
	# Problem. I need to handle created and edited files.
	# Solution ideas: multidimensional array with: [0] = file, [1] = comment.
	# That's acceptable.
}
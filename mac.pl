use main;
use Data::Dumper;
$i = 0;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

# Read the config file - V
# Take all files made after last edit.
# Check if they're edited or created
# Make list of all the files.
# Run the commit function. (Also rename it)

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
			# Push value to commit list. (Do we commit one file at a time or all of them? Logically, I'd speak for one at at time, to make it easier to revert without loosing data.)
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
	$add_command = "$i - git add ".$x." && git commit -m 'File: ".$x." has been ".$y."' && git push";
	$log = ´$add_command´;

	# REMEMBER TO UPDATE CONFIG FILE!!!
}

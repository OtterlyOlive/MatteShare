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

print scalar(@modified_files)."\n";

for($i = 0; $i < scalar($modified_files); $i++){
	$result = index($modified_files[$i], '.git');
	print $result."\n";
}

$find_created = 'cd '.$config{'repo_dir'}.' && find . -newerBt "'.$config{'last_updated'}.'"';
@created_files = `$find_created`;

print scalar(@created_files)."\n";

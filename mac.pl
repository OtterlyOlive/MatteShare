use main;
$i = 0;

my ($sec,$min,$hour,$mday,$mon,$year,$wday,$yday,$isdst) = localtime(time);

# Read the config file - V
# Take all files made after last edit.
# Check if they're edited or created
# Make list of all the files.
# Run the commit function. (Also rename it)

$command = 'cd '.$config{'repo_dir'}.' && find . -newerct "'.$config{'last_updated'}.'"';
$files = `$command`;
print $files;

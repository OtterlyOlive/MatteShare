# Hi and welcome to whateverthisis.
package main;

open FILE, "config.cnf" or die $!;

print FILE;
die "end";

%config = ();

while(<FILE>) {
	@temp = split(/=/, $_);
	chomp($temp[0]);
	chomp($temp[1]);
	$config{ $temp[0] } = $temp[1];
}

#print "Last updated: ".$config{'last_updated'};
#print "Repo dir is: ".$config{'repo_dir'};
#print "Date command is: ".$config{'command'};

# Change this name
sub change_made {
	$file = $_[0];
	$action = $_[1];

	if($action eq 'create'){
		$message = " has been modified.";
	} elsif($action eq 'delete'){
		$message = " has been deleted.";
	} elsif($action eq 'modify'){
		$message = " has been modified.";
	} elsif($action eq 'moved_to'){
		$message = " has been moved to this directory.";
	} elsif($action eq 'moved_from'){
		$message = " has been moved from this directory.";
	}

	$message = $file.$message;

	$cmd = "cd ".$config{'repo_dir'}." && git add . && git commit -m '".$message."'";
	$cr = `$cmd`;
}

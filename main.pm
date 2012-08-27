# Hi and welcome to whateverthisis.
package main;

open FILE, "config.cnf" or die $!;

# print FILE;
# die "end";

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

	if($action eq 'created'){
		$message = " has been created.";
	} elsif($action eq 'deleted'){
		$message = " has been deleted.";
	} elsif($action eq 'edited'){
		$message = " has been modified.";
	} elsif($action eq 'moved_to'){
		$message = " has been moved to this folder from another.";
	} elsif($action eq 'moved_from'){
		$message = " has been moved from this folder to another.";
	}

	$message = $file.$message;

	$add_command = "cd ".$config{'repo_dir'}." && git add ".$file." && git commit -m 'File: ".$message."'"; #  && git push
	$log = `$add_command`;
}

return true;

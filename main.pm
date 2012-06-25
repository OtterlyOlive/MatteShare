# Hi and welcome to whateverthisis.
package main;

open FILE, "config" or die $!;

%config = ();

while(<FILE>) {
	@temp = split(/=/, $_);
	$config{ $temp[0] } = $temp[1];
}

#print "Last updated: ".$config{'last_updated'};
#print "Repo dir is: ".$config{'repo_dir'};
#print "Date command is: ".$config{'command'};

# Variables:
$git_remote_repo = "";
$local_folder = "/Users/Eax/Perl/MatteShare";

# Change this name
sub updated {
	print "Called.";
#	system("cd ".$local_folder." && git add . && git commit -m ");
	print "Done";
}

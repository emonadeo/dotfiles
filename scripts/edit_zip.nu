# Given a zip archive, pick a file using `tv` and edit it using `$EDITOR`.
# Requires `7zip`
def main [path: string] {
	# Select file
	let selected = ^unzip -l $path
		| lines | slice 3.. | str trim | where $it != ""
		| split column --collapse-empty " " length date time name
		| get name
		| to text
		| ^tv;

	if $selected == "" {
		return;
	}

	let temp_dir = (mktemp -d -t "edit-zip.XXXXX");
	try {
		# Decompress selected file
		print $"7zz x ($path) -o($temp_dir) ($selected)";
		^7zz x $path -o($temp_dir) $selected ;

		cd $temp_dir;

		# Edit file
		^$env.EDITOR $selected;

		# Re-compress and update zip archive
		^7zz u $path $selected;
#
		cd -;
	} catch {
		|err| return $err.msg;
	} finally {
		rm -rf $temp_dir;
	}
}

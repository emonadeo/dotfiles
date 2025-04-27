ls **/*.nix
| each { |file|
	^nixfmt $file.name
	$file.name
}

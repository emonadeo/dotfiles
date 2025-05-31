# List all `.desktop` files inside of XDG_DATA_DIRS using `fd`
# BUG: Lists empty directories as files

$env.XDG_DATA_DIRS
| split row ":"
| each { |dir|
	if ($dir | path exists) {
		cd $dir
		| ^fd "\\.desktop$"
		| split row "\n"
		| each { |file| $dir + "/" + $file } 
	}
}
| flatten

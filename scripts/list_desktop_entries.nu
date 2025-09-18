# List all `.desktop` files inside of XDG_DATA_DIRS

$env.XDG_DATA_DIRS
| split row ":"
| each { |dir| try { 
		$"($dir)/**/*.desktop" | into glob | ls $in
	}
}
| flatten


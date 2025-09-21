def main [name: string] {
	http get $"https://addons.mozilla.org/firefox/downloads/latest/($name)/latest.xpi" | save $"($name).xpi"
	^unzip $"($name).xpi" "-d" $name
	open $"($name)/manifest.json" | get browser_specific_settings.gecko.id | wl-copy
	rm -r $name
	rm $"($name).xpi"
}

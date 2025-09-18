# List all directories listed in XDG_DATA_DIRS that exist

$env.XDG_DATA_DIRS
| split row ":"
| filter { |file| $file | path exists }

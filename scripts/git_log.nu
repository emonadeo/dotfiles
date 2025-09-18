git log --pretty=%h»¦«%aN»¦«%s»¦«%aD
| lines
| split column "»¦«" sha1 committer desc merged_at
| first 10

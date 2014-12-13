# source other completions
if [ -d ~/.shell/profile.d ]; then
	for i in ~/.shell/profile.d/*.{z}sh(N); do
		if [ -r $i ]; then
			. $i
		fi
	done
	unset i
fi

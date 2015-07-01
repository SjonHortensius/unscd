#!/bin/bash
PREG='^<img src="[^"]+" alt="[^"]+"> <a href="([^"]+)">[^"]+</a> +([0-9][0-9]-[A-Z][a-z][a-z]-[0-9]+ [0-9:]+) +[0-9.]+K'
URL=http://busybox.net/~vda/unscd

curl $URL'/?C=M;O=A' | while read line; do
	[[ $line =~ $PREG ]] || continue

	echo -e ${BASH_REMATCH[1]}"\t"${BASH_REMATCH[2]}

	curl -O $URL/${BASH_REMATCH[1]}

	[[ ${BASH_REMATCH[1]} == nscd-0.*.1.* ]] && mv ${BASH_REMATCH[1]} ${BASH_REMATCH[1]/-0.??.1/}
	[[ ${BASH_REMATCH[1]} == nscd-0.* ]] && mv ${BASH_REMATCH[1]} ${BASH_REMATCH[1]/-0.??/}

	git add *
	GIT_AUTHOR_DATE=`date -d "${BASH_REMATCH[2]}" +%s +0100` git commit -a --author='Denys Vlasenko <dvlasenko1@gmail.com>' -m "Importing ${BASH_REMATCH[1]}"
done

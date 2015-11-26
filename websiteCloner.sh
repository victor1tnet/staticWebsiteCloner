#!/bin/bash
# bash script meant to mirror a website

DOMAIN="www.example.com"
NOWWW=${DOMAIN:4}
NOWWWREF="../$NOWWW/"
NEWDOMAIN="localhost/test/"$DOMAIN
MIRRORPATH=$DOMAIN

echo "Your domain is " $DOMAIN
echo ""
echo "Your domain without WWW is " $NOWWW
echo ""


# download website
mirrorWebsite () {
	echo " Mirroring website "
	echo ""
	wget -m -p -k --trust-server-names -e robots=off -rH -D$NOWWW http://$DOMAIN/
	# -m : mirrors website , as in downloading all file references recursevly
	# --trust-server-names : follows redirects and downloads pages as they appear in the browser (quick fix for permalinks in Wordpress : index.php?p=112 -> page-name.html )                  
	# -e robots=off : disregards the robots.txt the file (yes, wget automatically checks it)
	# -rH -D$NOWWW : downloads resources referenced by other linked domains ; in this case, domain would be www.example.com - this parameter will download pages referenced by example.com ; problem is that it downloads it in a separate folder
	echo ""
	echo " Copying the referenced own domain to common folder"
	cp -Rv $NOWWW/* $MIRRORPATH/
	echo ""
	echo " Delete downloaded extra ref folder"
	rm -r $NOWWW
}
# rewrite urls
rewriteDomain () {
	echo ""
	echo " Rewriting old url to new one "
	echo ""
	echo ''' 	find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|$DOMAIN|$NEWDOMAIN|g" '''
	find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|$DOMAIN|$NEWDOMAIN|g"
	echo ""
	echo "Rewriting the non-www version if any "
	echo ""
	echo ''' find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|$NOWWW|$NEWDOMAIN|g" '''
	find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|http://$NOWWW|$NEWDOMAIN|g"
	echo ""
	echo " Rewriting referenced non www domain "
	echo ""
	echo ''' find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|$NOWWWREF||g" '''
	# some links may of the form - ../example.com/blabla.css ; the following command will delete all occurences of "../example.com/" in referencing links, turning them into relative
	find $MIRRORPATH -type f -print0 | xargs -0 sed -i "s|$NOWWWREF||g"
	echo ""

}

# rewrite files
renameQueryFiles () {
	# css and js files are sometimes opened with a query string e.g. example.com/bla.js?ver=1.2.3 
	# there might be a way to fix it in wget directly (didn't found it yet)
	# function removes all query strings ("?" and everything following it) from js and css files 
	echo " Renaming query files"
	echo ""
	find $MIRRORPATH -iname "*.js?*" -exec rename 's/\?.*//' {} \;
	find $MIRRORPATH -iname "*.css?*" -exec rename 's/\?.*//' {} \;
}

if [ $1 = "mirror" ] #if the first parameter is X
then
	mirrorWebsite
	rewriteDomain
	renameQueryFiles
fi



#!/bin/bash
# -*- sh -*-

: << =cut

=head1 NAME

WP_versioncheck - finds installed wordPress and display version info.

=head1 CONFIGURATION

This plugin does not normally require configuration.
run as root.

=head1 AUTHOR

Original author ka7

Copyright (C) 2017 ka7 <ka7@la-evento.com>

=head1 LICENSE

GPLv2

=head1 MAGIC MARKERS

 #%# family=auto
 #%# capabilities=autoconf suggest

=cut

#. "${MUNIN_LIBDIR}/plugins/plugin.sh"
. /usr/share/munin/plugins/plugin.sh 

# loop over all the installed versions, fetch installed version-numbers
write_versions(){
  for FILE in $(locate wp-includes/version.php)
  do
    VERSTR=$(grep "\$wp_version" "$FILE" | sed 's/[^0-9.]*//g'| sed '/^$/d' | awk -F'.' '{print $1*10000 + $2*100 + $3*1'})
    WP_I2=$( echo "$FILE" | sed 's/wp-includes\/version.php//g' )
    WP_I="$(clean_fieldname \"$WP_I2\")";
  #  WP_I=$( ${FILE//wp-includes\/version.php/} ) # mightwork
#    WP_V=$( echo "$VERSTR"  )  

    echo "$WP_I.value $VERSTR";
  done
}

# detect the up-to-date lastest stable of WP, e.g via uscan
detect_latest_stable(){
}

case $1 in
    autoconf)
        if [ $(locate wp-includes/version.php | wc -l ) -gt 0 ]; then
            echo yes
            exit 0
        else
            echo "no WP-installations found"
            exit 0
        fi
        ;;
    suggest)

        exit 0
        ;;
    config)

        echo -n "graph_order "
  for FILE in $(locate wp-includes/version.php)
  do
       lab2=$( echo "$FILE" | sed 's/wp-includes\/version.php//g' )
        lab="$(clean_fieldname \"$lab2\")";
        echo -n " $lab"


  done
echo ""
        echo "graph_title WordPress version"
        echo 'graph_args --base 1000'
        echo 'graph_vlabel version (1.2.3 = 010203 )'
        echo 'graph_category system'
        echo "graph_info search for active WP installations (by locate wp-includes/version.php), grep the version, interprete."

  for FILE in $(locate wp-includes/version.php)
  do
       lab2=$( echo "$FILE" | sed 's/wp-includes\/version.php//g' )
        lab="$(clean_fieldname \"$lab2\")";
        echo "$lab.label $lab2"
        echo "$lab.type GAUGE"
        echo "$lab.units-exponent 0"
  done

        print_warning WPversion
        print_critical WPversion
         exit 0
         ;;
esac

        write_versions;



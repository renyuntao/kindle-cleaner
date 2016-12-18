#!/bin/bash 
# Function:
# 	Clean up the directory of Kindle, delete the unnecessary *.sdr file
# History:
# 	2016-12-04
# 		Create this program

# kindle dir: /media/i-renyuntao/Kindle/documents

# Set Fonts/Colors Control Sequences
NORMAL="\x1B[0m"
BOLD="\x1B[1m"
RED="\x1B[91m"
YELLOW="\x1B[93m"
BLUE="\x1B[94m"
MAGENTA="\x1B[95m"
CYAN="\x1B[96m"
CYAN_B="\x1B[106m"

# Temporary file
cmp_file='cmp_tmp'
sdr_file='sdr_tmp'

# Statistic the number of file that have been deleted
declare -i count_deleted_file=0

# The $cmp_file contain the name of file which the name is match *.azw or *.azw3 or *.mobi or *.txt 
ls | grep -E "\.azw$|\.azw3$|\.mobi$|\.txt$" > $cmp_file

# Write the name of *.sdr directory(don't include the suffix '.sdr') into file "$sdr_file"
#ls | grep "\.sdr" | grep -o ".*[^(.sdr)]" > $sdr_file
ls | grep "\.sdr" | sed -r 's/(.*)\.sdr/\1/' > $sdr_file

# Print help message
print_help()
{
	echo ""
	echo -e "${YELLOW}${BOLD}-h${NORMAL}\vShow this help message and exit"
	echo ""
	echo -e "${YELLOW}${BOLD}-n${NORMAL}\vNormal Mode(Default)"
	echo ""
	echo -e "${YELLOW}${BOLD}-s${NORMAL}\vStrict Mode"
	echo ""
}

# Normal Mode
normal()
{
	echo -e "${CYAN}In Normal Mode ...${NORMAL}"
	echo -e "${CYAN_B}                              ${NORMAL}"

	IFS=$'\n'
	for file in `cat $sdr_file`
	do
		if grep -Fq "$file" $cmp_file
		then
			# Do nothing
			:
		else
			# Delete a line that match $file in file $sdr_file
			sed -i "/$file/ d" $sdr_file

			# Delete unnecessary *sdr file of Kindle
			need_rm=$file".sdr"
			echo "Delete $need_rm"
			rm -r $need_rm
			let 'count_deleted_file=count_deleted_file+1'
		fi
	done

	if [ $count_deleted_file -eq 0 ]
	then
		echo "NULL"
	fi
	echo -e "${CYAN_B}                              ${NORMAL}"
}

# Strict Mode
strict()
{
	echo -e "${CYAN}In Strict Mode ...${NORMAL}"
	echo -e "${CYAN_B}                              ${NORMAL}"

	# Delete the filename extension   
	sed -i -r 's/(.*)\.((azw3)|(azw)|(mobi)|(txt))/\1/' $cmp_file 

	for file in `cat $sdr_file`
	do
		flag=0
		for line in `cat $cmp_file`
		do
			if [ "$file" == "$line" ]
			then
				flag=1
				break
			fi
		done

		if [ "$flag" == "0" ]
		then
			need_rm=$file".sdr"
			echo "Delete $need_rm"
			rm -r $need_rm
			let 'count_deleted_file=count_deleted_file+1'
		fi
	done

	if [ $count_deleted_file -eq 0 ]
	then
		echo "NULL"
	fi
	echo -e "${CYAN_B}                              ${NORMAL}"
}

h_option=0
n_option=0
s_option=0


while getopts ":nsh" opt
do
	case $opt in
		h)
			h_option=1
			;;
		n)
			n_option=1
			;;
		s)
			s_option=1
			;;
		\?)
			echo -e "${RED}Unrecognized option ${BOLD}-$OPTARG${NORMAL}"
			echo "Run the following command to see usage:"
			echo ""
			echo -e "${YELLOW}${BOLD}   $ kindle_clear -h${NORMAL}"
			echo ""
			exit 1
			;;
	esac
done

if [ "$h_option" == "1" ]
then
	print_help
	exit 0
fi

# Set default option
if [ "$s_option" == "0" -a "$n_option" == "0" ]
then
	n_option=1
# Deal with error situation
elif [ "$s_option" == "1" -a "$n_option" == "1" ]
then
	echo -e "${RED}Error! -e option can't together with -n option${NORMAL}"
fi
	
# Call different function according to different option user specify
if [ "$s_option" == "1" ]
then
	strict
else
	normal
fi

# remove temporary file
rm $cmp_file
rm $sdr_file

file="file"

if [ $count_deleted_file -gt 1 ]
then
	file=${file}s
fi

echo -e "${MAGENTA}$count_deleted_file $file have been deleted.${NORMAL}"
echo -e "${BLUE}SUCCESS!${NORMAL}"

exit 0

#!/bin/sh

tput clear
tput setaf 7
cat << "EOF"
   __
   \ \_____         *
###[==_____>   *
   /_/      __
            \ \_____
         ###[==_____>
    *      /_/

🚀 Dot Files Installation Wizard
EOF
tput sgr0


# Wizard Menu
# ----------------------------------------------------------------
tput cup 10 15
tput rev
echo " SELECT MODE "
tput sgr0

tput cup 12 2
echo "1. Baseline"

tput cup 13 2
echo "2. Dev"

# tput cup 14 2
# echo "3. Design"

# tput cup 15 2
# echo "4. Music"

# Set bold mode
tput bold
tput cup 15 2
read -p "Enter your choice [1-2] " choice

tput sgr0
tput rc


# Run selected option.
# ----------------------------------------------------------------
case $choice in
	1) sh ~/.dotfiles/baseline/.start # Run baseline setup
	;;
	2) sh ~/.dotfiles/dev/.start # Run dev setup
	;;
	# 3) sh ./design/.start # Run design setup
	# ;;
	# 4) sh ./music/.start # Run music setup
	# ;;
esac


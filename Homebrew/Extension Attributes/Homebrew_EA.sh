#!/bin/bash

####################################################################################################
#
# Copyright (c) 2022, JAMF Software, LLC.  All rights reserved.
#
#       Redistribution and use in source and binary forms, with or without
#       modification, are permitted provided that the following conditions are met:
#               * Redistributions of source code must retain the above copyright
#                 notice, this list of conditions and the following disclaimer.
#               * Redistributions in binary form must reproduce the above copyright
#                 notice, this list of conditions and the following disclaimer in the
#                 documentation and/or other materials provided with the distribution.
#               * Neither the name of the JAMF Software, LLC nor the
#                 names of its contributors may be used to endorse or promote products
#                 derived from this software without specific prior written permission.
#
#       THIS SOFTWARE IS PROVIDED BY JAMF SOFTWARE, LLC "AS IS" AND ANY
#       EXPRESSED OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED
#       WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
#       DISCLAIMED. IN NO EVENT SHALL JAMF SOFTWARE, LLC BE LIABLE FOR ANY
#       DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES
#       (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES;
#       LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND
#       ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT
#       (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS
#       SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
#
#   Author: Josh Harvey
#   Last Modified: 06/01/2022
#   Version: 0.1
#
#   Description: This is an Extension Attribute that will display the version of Homebrew
#   if it's installed. If not, it will return "Not Installed".
#
#   Usage: Extension Attribute in Jamf Pro
#
####################################################################################################

################# VARIABLES ######################
## currentUser: Grabs the username of the current logged in user **DO NOT CHANGE**
currentUser=$(echo "show State:/Users/ConsoleUser" | scutil | awk '/Name :/ && ! /loginwindow/ { print $3 }')
###################################################

## Lets see what architecture the system is..
macOSArch=$(/usr/bin/uname -m)

if [[ "$macOSArch" == "x86_64" ]]; then
    homebrewPath="/usr/local/bin/brew"
elif [[ "$macOSArch" == "arm64" ]]; then
    homebrewPath="/opt/homebrew/bin/brew"
fi

homebrewVersion=$(su -l $currentUser -c "$homebrewPath -v")

if [[ ! -z "$homebrewVersion" ]]; then
	echo "<result>$homebrewVersion</result>"
else
	## If Homebrew is not installed, this file will be empty, so lets change it to "Not Installed" so it's clear when looking at the EA
	echo "<result>Not Installed</result>"
fi
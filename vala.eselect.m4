# -*-eselect-*-  vim: ft=eselect
# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id: $

DESCRIPTION="Manage what version of Vala to be used by default"
MAINTAINER="Gavrilov Maksim <ulltor@gmail.com>"
VERSION=PV # set by m4 from Makefile

# Tools to manage symlinks to
TOOLS="vala valac vala-gen-introspect vapigen"

# Find a list of valac symlink targets
find_targets() {
	local f
	for f in "${EROOT}"/usr/bin/valac-[[:digit:]]* ; do
		[[ -f ${f} ]] && basename "${f}"
	done
}

# Remove symlink
remove_symlink() {
	local tool=${1}
	rm "${EROOT}/usr/bin/${tool}"
}

# Set symlink
set_symlink() {
	local tool=${1}
	local target=${2}
	if is_number "${target}" ; then
		local targets=( $(find_targets) )
		target=${targets[target - 1]}
	fi
	
	# Extract version number from whole string
	# Ex.: '0.12' from 'vala-0.12'
	target=${target##*-}
	
	if [[ -z ${target} ]] ; then
		die -q "Target \"${1}\" doesn't appear to be valid!"
		
	elif [[ -f ${EROOT}/usr/bin/${tool}-${target} ]] ; then
		ln -s "${EROOT}/usr/bin/${tool}-${target}" "${EROOT}/usr/bin/${tool}"
	else
		die -q "Target \"$1\" doesn't appear to be valid!"
	fi
}

### show action ###

describe_show() {
	echo "Show active valac version"
}

do_show() {
	write_list_start "Active valac version:"
	if [[ -L ${EROOT}/usr/bin/valac ]] ; then
		local version=$(canonicalise "${EROOT}/usr/bin/valac")
		write_kv_list_entry "${version%/}" ""
	else
		write_kv_list_entry "(unset)" ""
	fi
}

### list action ###

describe_list() {
	echo "List available valac versions"
}

do_list() {
	local i targets=( $(find_targets) )
	write_list_start "Available valac versions:"
	for (( i = 0; i < ${#targets[@]}; i++ )) ; do
		[[ ${targets[i]} = \
			$(basename "$(canonicalise "${EROOT}/usr/bin/valac")") ]] \
			&& targets[i]=$(highlight_marker "${targets[i]}")
	done
	write_numbered_list -m "(none found)" "${targets[@]}"
}

### set action ###

describe_set() {
	echo "Set an active version of valac"
}

describe_set_parameters() {
	echo "<target>"
}

describe_set_options() {
	echo "target : Target name, vesion or number (from 'list' action)"
}

do_set() {
	if [[ -z ${1} ]] ; then
		# no parameter
		die -q "You didn't tell me what version to use"
	else
		for tool in ${TOOLS}; do
			
			if [[ -L ${EROOT}/usr/bin/${tool} ]]; then
				if ! remove_symlink ${tool} ; then
					die -q "Couldn't remove existing symlinks"
				fi
		
			elif [[ -e ${EROOT}/usr/bin/${tool} ]] ; then
				# we have something strange
				die -q "${EROOT}/usr/bin/${tool} exists but is not a symlink"
			fi
					
			set_symlink ${tool} ${1} || die -q "Couldn't set new symlinks"
			
		done
	fi
}

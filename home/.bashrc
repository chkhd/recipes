export HISTSIZE=1000000
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export MY_HOST_NICKNAME='mbp'
export SHOW_AWS_PROFILE='true'
export CLICOLOR=1
export LSCOLORS=ExFxBxDxCxegedabagacad
export DOTNET_CLI_TELEMETRY_OPTOUT=1
export EDITOR=vim
export PATH="${PATH}:${HOME}/bin"

# Append to the Bash history file, rather than overwriting it
shopt -s histappend;

# Colors
Y="\033[1;33m"
C="\033[0;36m"
G="\033[1;32m"
R="\033[1;31m"
N="\033[0m"

function echo_color {
	echo -e "${1}${2}${N}"
}

function yellow {
	echo_color "${Y}" "${1}"
}

function cyan {
	echo_color "${C}" "${1}"
}

function green {
	echo_color "${G}" "${1}"
}

function red {
	echo_color "${R}" "${1}"
}

# Homebrew
alias b=brew
alias buc="brew update; brew upgrade; brew cleanup"
export PATH="${PATH}:/usr/local/bin:/usr/local/sbin"

# bash-completion
BASH_CMP_SCRIPT="/usr/local/etc/profile.d/bash_completion.sh"
[[ -r  ${BASH-CMP_SCRIPT} ]] && source ${BASH_CMP_SCRIPT}

# More completion
FILES=$({ find ~/.completion -type l & find ~/.completion -type f; })

for f in ${FILES}
do
	source "${f}"
done

# Quality of life
alias e=$(echo ${EDITOR})

alias i=egrep
complete -o default -F _longopt i

alias f=find
complete -F _find f

alias ll="ls -Gltrh"
alias la="ls -GlAtrh"

alias lock='pmset displaysleepnow'
alias tftpd-start='sudo launchctl load -F /System/Library/LaunchDaemons/tftp.plist; sudo launchctl start com.apple.tftpd'
alias tftpd-stop='sudo launchctl unload -F /System/Library/LaunchDaemons/tftp.plist'
alias dnsflush="sudo killall -HUP mDNSResponder"
alias wanip="dig +short myip.opendns.com @resolver1.opendns.com"
alias lanip="ipconfig getifaddr en0"
alias ifactive="ifconfig | pcregrep -M -o '^[^\t:]+:([^\n]|\n\t)*status: active'"
alias upgrade="sudo softwareupdate -i -a"
alias pubkey="more ~/.ssh/id_rsa.pub | pbcopy"

# Clean up LaunchServices to remove duplicates in the “Open With” menu
alias lscleanup="/System/Library/Frameworks/CoreServices.framework/Frameworks/LaunchServices.framework/Support/lsregister -kill -r -domain local -domain system -domain user && killall Finder"

# URL-encode strings
alias urlencode='python -c "import sys, urllib as ul; print ul.quote_plus(sys.argv[1]);"'

# Merge PDF files
# Usage: `mergepdf -o output.pdf input{1,2,3}.pdf`
alias mergepdf='/System/Library/Automator/Combine\ PDF\ Pages.action/Contents/Resources/join.py'

# Airport CLI alias
alias airport='/System/Library/PrivateFrameworks/Apple80211.framework/Versions/Current/Resources/airport'

# Print each PATH entry on a separate line
alias path='echo -e ${PATH//:/\\n}'

# Use newer nano from brew when available
nano=/usr/local/bin/nano
ls ${nano} &> /dev/null && alias nano=${nano}

# Better cat
export BAT_STYLE="plain"
alias bat='bat --paging=never --theme TwoDark'

# Games
alias wow='~/World\ of\ Warcraft\ Classic/WoW\ Classic.app/Contents/MacOS/World\ of\ Warcraft'

# Golang
export GOPATH=${HOME}/src/go
export GOROOT=/usr/local/opt/go/libexec

export PATH=${PATH}:/usr/local/opt/go/libexec/bin
export PATH=${PATH}:${GOPATH}/bin
export PATH=${PATH}:${GOROOT}/bin

complete -C ~/src/go/bin/gocomplete go

# Rust
export PATH="${HOME}/.cargo/bin:${PATH}"

# Kubernetes
alias kcl="kubectl"
complete -o default -o nospace -F __start_kubectl kcl

alias kcx="kubectx"
complete -F _kube_contexts kcx

alias kns="kubens"
complete -F _kube_namespaces kns

alias kg="kubectl get"
alias kd="kubectl delete"

alias kgp="kubectl get pods -o wide"
alias kga="kubectl get pods --all-namespaces -o wide"
alias kgk="kubectl get pods -n kube-system -o wide"
alias kgs="kubectl get svc -o wide"
alias kgr="kubectl get rc -o wide"
alias kgd="kubectl get deployments -o wide"
alias kgn="kubectl get namespaces -o wide"
alias kca="kubectl apply"
alias kgl="kubectl logs"
alias kgi="kubectl describe"

alias kgrs="kubectl get rs -o wide"

alias mk=minikube
complete -o default -o nospace -F __start_minikube mk

# Docker
alias di="docker images"
alias da="docker ps -a"

## Git
alias g=git
complete -o bashdefault -o default -o nospace -F __git_wrap__git_main g

alias gs="git s"
alias gl="git l"
alias gf="git fetch"
alias ga="git a"

alias gaa="git aa"
alias gdh="git d HEAD^"
alias gcm="git commit -m"
alias gll="git ll"
alias glll="git lll"

# AWS
function ap {
	# AWS Profile

	if ! test -z "$1"; then
		export AWS_PROFILE=$1
	else
		if ! test -z "$AWS_PROFILE"; then
			echo "${AWS_PROFILE}"
		fi
	fi
}

function apl {
	# AWS Profile List

	local profiles
	local profile
	local current_profile

	profiles="${HOME}/.aws/credentials"
	if ! test -f "${profiles}"; then
		echo "No profiles have been configured"
		return 1
	fi

	profiles=$(cat "${profiles}" | grep \\[ | tr -d "[]")
	current_profile=$(ap)

	for profile in ${profiles[@]}
	do
		if test "${current_profile}" == "${profile}"; then
			yellow "${profile}"
		else
			echo "${profile}"
		fi
	done
}

# Ruby
export PATH=~/.gem/ruby/2.3.0/bin:${PATH}

# Python
export PATH=${HOME}/Library/Python/`python3 --version | cut -d" " -f2 | cut -d. -f1,2`/bin:${PATH}

# This .bashrc will be symlinked, so adding auto-generated stuff here would be a bad idea
if [[ -f ~/.bashrc_local ]]; then
	source ~/.bashrc_local
fi

# Less generic stuff
if [[ -f ~/.dwim ]]; then
	source ~/.dwim
fi

# Company specific stuff that does not belong in public repo
if [[ -f ~/.companyrc ]]; then
	source ~/.companyrc
fi

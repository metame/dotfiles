for f in $(find $HOME/.bash_profile.d -type f | sort) ; do
  source "$f"
done

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

function gi() { curl -L -s https://www.gitignore.io/api/$@ ;}


## Dynamo
alias dynamo='java -Djava.library.path=~/Dynamo/DynamoDBLocal_lib -jar ~/Dynamo/DynamoDBLocal.jar -sharedDb'
gd=~/ce/glassd
PATH=$PATH:/usr/local/sbin
PATH=$PATH:~/.local/bin
alias tailapache='tail -f /Applications/MAMP/logs/apache_error.log'
alias tailphp='tail -f /Applications/MAMP/logs/php_error.log'
alias mergepdf='gs -dBATCH -dNOPAUSE -q -sDEVICE=pdfwrite -dPDFSETTINGS=/prepress -sOutputFile=out.pdf'
alias yTtoMP3='youtube-dl --extract-audio --audio-format mp3'

if [ -e /Users/me/.nix-profile/etc/profile.d/nix.sh ]; then . /Users/me/.nix-profile/etc/profile.d/nix.sh; fi # added by Nix installer


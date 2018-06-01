#!/usr/bin/zsh

trap 'exit -1;' ERR

while read d; do
    export FPATH=$d:$FPATH
done << EOF
/home/als3/acct/dpcuneo/hg_dot/oh-my-zsh/plugins/git
/home/als3/acct/dpcuneo/hg_dot/oh-my-zsh/plugins/vi-mode
/home/als3/acct/dpcuneo/hg_dot/oh-my-zsh/plugins/tmux
/home/als3/acct/dpcuneo/hg_dot/oh-my-zsh/functions
/home/als3/acct/dpcuneo/hg_dot/oh-my-zsh/completions
/usr/share/zsh/site-functions:/usr/share/zsh/5.0.2/functions
EOF

if [ $? -eq 0 ];the
    echo "FPATH patched for ZSH"
else
    echo "FPATH patching FAILED"
fi

exit 0

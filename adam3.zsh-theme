# adam3 prompt theme

prompt_adam3_help () {
  cat <<'EOF'
This prompt is color-scheme-able.  You can invoke it thus:

  prompt adam3 [<colorLine>]

where the colors are for the hyphens, current directory, user@host,
and user input bits respectively.  The default colors are cyan, green,
cyan, and white.  This theme works best with a dark background.

If you have either UTF-8 or the `nexus' or `vga' console fonts or similar,
you can specify the `8bit' option to use 8-bit replacements for the
7-bit characters.

And you probably thought adam1 was overkill ...
EOF
}

prompt_adam3_setup () {
  # Some can't be local
  local topLeftCorner  middleToBottomChar bottomLeftCorner

  topCornerChar='╭'
  bottomCornerChar='╰'
  middleToBottomChar='│'
  hyphenChar='─'
  lineEnd='─╌┄┈'

  # Color scheme
  lineColor=055
  pathColor=226 #237
  hostColor="$(printf %03d $(hostname | md5sum | sed -r 's/^.*(..)  -/0x\1/'))"

  colorLine="%b%{$FG[$lineColor]%}"
  colorPath="%b%{$FG[$pathColor]%}"
  colorUser="%b%{$FG[$hostColor]%}"

  topCorner="${colorLine}${topCornerChar}"
  middleToBottom=$'%{\e[A\r'"%}${colorLine}${middleToBottomChar}{"$'\e[B%}' # This is a cute hack. () Well I like it, anyway.
  bottomCorner="${colorLine}${bottomCornerChar}"

  vcsStatus="$(git_current_branch)"
  coloredPath="${colorPath}%~${colorLine}"
  lineTopLeft="${topCorner}${hyphenChar}┤${coloredPath}├"

  user_host="${colorUser}%n${colorLine}@${colorUser}%m${colorLine}"
  time="${colorUser}%*${colorLine}"
  lineTopRight="┤${user_host}│${time}├${lineEnd}"

  lineBottom="${bottomCorner}${hyphenChar}"

  setRoyalColorPrompt="%B%{%(?.$FG[226].$FG[196])%}"
  setPeasantColorPrompt="%B%(?.%F{white}.%F{red})"
  setColorPrompt="%(!.$setRoyalColorPrompt.$setPeasantColorPrompt)"
  promptChar="%(!.♛.▶)"
  prompt_opts=(cr subst percent)

  add-zsh-hook precmd prompt_adam3_precmd
}

prompt_adam3_precmd() {
  setopt noxtrace localoptions extendedglob
  local lineTop

  prompt_adam3_choose_prompt

  PS1="${lineTop}${lineBottom}${setColorPrompt}$promptChar %b%f%k"
  PS2="${lineBottom}${middleToBottom}${setColorPrompt}%_> %b%f%k"
  PS3="${lineBottom}${middleToBottom}${setColorPrompt}?# %b%f%k"
  zle_highlight[(r)default:*]="default:fg=white,bold"
}

prompt_adam3_git() {
  if [[ $(git log -1 >/dev/null 2>&1; echo $?) -eq 128 ]]; then
    lineTopMiddle=""
    return
  fi

  seconds_since_last_commit=$[ $(date +%s) - $(git log --pretty=format:'%at' -1 2> /dev/null) ]
  if [[ $seconds_since_last_commit -lt $[30 * 60] ]]; then
    setDirtyColor="%b%{$FG[046]%}"
  else if [[ $seconds_since_last_commit -lt $[2 * 60 * 60] ]]; then
    setDirtyColor="%b%{$FG[214]%}"
  else
    setDirtyColor="%b%{$FG[196]%}"
  fi; fi

  ZSH_THEME_GIT_PROMPT_PREFIX="┤<"
  ZSH_THEME_GIT_PROMPT_SUFFIX="├"
  DISABLE_UNTRACKED_FILES_DIRTY="true"
  ZSH_THEME_GIT_PROMPT_DIRTY="${setDirtyColor}⚒ ${colorLine}"
  ZSH_THEME_GIT_PROMPT_CLEAN=""
  ZSH_THEME_GIT_PROMPT_UNTRACKED="+ "
  # ZSH_THEME_GIT_PROMPT_STAGED="⊕ "
  ZSH_THEME_GIT_PROMPT_STASHED="⨄ "

  lineTopMiddle="┤$(parse_git_dirty)${colorPath}<$(git_current_branch)>${colorLine}$(git_prompt_status)├"
}

prompt_adam3_choose_prompt () {
  prompt_adam3_git

  local lineTopLeft_width=${#${(S%%)lineTopLeft//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  local lineTopMiddle_width=${#${(S%%)lineTopMiddle//(\%([KF1]|)\{*\}|\%[Bbkf])}}
  local lineTopRight_width=${#${(S%%)lineTopRight//(\%([KF1]|)\{*\}|\%[Bbkf])}}

  local padding_length=$[ COLUMNS - $lineTopLeft_width - $lineTopMiddle_width - $lineTopRight_width ]
  local padding_length_left=$[ $padding_length / 2 ]
  local padding_length_right=$[ $padding_length - $padding_length_left ]

  # Try to fit in long path, git and user@host.
  if [[ $padding_length -gt 0 ]]; then
    local prompt_padding_left
    local padding_right
    eval "padding_left=\${(l:${padding_length_left}::${hyphenChar}:)_empty_zz}"
    eval "padding_right=\${(l:${padding_length_right}::${hyphenChar}:)_empty_zz}"
    lineTop="${lineTopLeft}${padding_left}${lineTopMiddle}${padding_right}${lineTopRight}"
    return
  fi

  local padding_length=$[ COLUMNS - $lineTopLeft_width - $lineTopRight_width ]

  # Try to fit in long path and user@host.
  if [[ $padding_length -gt 0 ]]; then
    local padding
    eval "padding=\${(l:${padding_length}::${hyphenChar}:)_empty_zz}"
    lineTop="${lineTopLeft}${padding}${lineTopRight}"
    return
  fi

  padding_length=$(( COLUMNS - lineTopLeft_width ))

  # Didn't fit; try to fit in just long path.
  if [[ $padding_length -gt 0 ]]; then
    local padding
    eval "padding=\${(l:${padding_length}::${hyphenChar}:)_empty_zz}"
    lineTop="${lineTopLeft}${padding}"
    return
  fi

  # Still didn't fit; truncate
  local prompt_pwd_size=$[ COLUMNS - 7 ]
  # What does %${prompt_pwd_size}<...<%~%<< mean?
  lineTop="${topCorner}${hyphenChar}┤${colorPath}%${prompt_pwd_size}<…<%~%<<${colorLine}├${lineEnd}"
}

prompt_adam3_setup "$@"

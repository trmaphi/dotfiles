function enrich {
    local flag=$1
    local symbol=$2

    local color_on=${3:-$omg_default_color_on}

    if [[ $flag != true && $omg_use_color_off == false ]]; then symbol=' '; fi
    if [[ $flag == true ]]; then local color=$color_on; else local color=$omg_default_color_off; fi    

    echo -n "${prompt}${color}${symbol}${reset} "
}

function get_current_action () {
    local info="$(git rev-parse --git-dir 2>/dev/null)"
    if [ -n "$info" ]; then
        local action
        if [ -f "$info/rebase-merge/interactive" ]
        then
            action=${is_rebasing_interactively:-"rebase -i"}
        elif [ -d "$info/rebase-merge" ]
        then
            action=${is_rebasing_merge:-"rebase -m"}
        else
            if [ -d "$info/rebase-apply" ]
            then
                if [ -f "$info/rebase-apply/rebasing" ]
                then
                    action=${is_rebasing:-"rebase"}
                elif [ -f "$info/rebase-apply/applying" ]
                then
                    action=${is_applying_mailbox_patches:-"am"}
                else
                    action=${is_rebasing_mailbox_patches:-"am/rebase"}
                fi
            elif [ -f "$info/MERGE_HEAD" ]
            then
                action=${is_merging:-"merge"}
            elif [ -f "$info/CHERRY_PICK_HEAD" ]
            then
                action=${is_cherry_picking:-"cherry-pick"}
            elif [ -f "$info/BISECT_LOG" ]
            then
                action=${is_bisecting:-"bisect"}
            fi
        fi

        if [[ -n $action ]]; then printf "%s" "${1-}$action${2-}"; fi
    fi
}

function build_prompt {
    local enabled=`git config --get oh-my-git.enabled`
    if [[ ${enabled} == false ]]; then
        echo "${PSORG}"
        exit;
    fi

    local prompt=""
    
    # Git info
    local current_commit_hash=$(git rev-parse HEAD 2> /dev/null)
    if [[ -n $current_commit_hash ]]; then local is_a_git_repo=true; fi
    
    if [[ $is_a_git_repo == true ]]; then
        local current_branch=$(git rev-parse --abbrev-ref HEAD 2> /dev/null)
        if [[ $current_branch == 'HEAD' ]]; then local detached=true; fi

        local number_of_logs="$(git log --pretty=oneline -n1 2> /dev/null | wc -l)"
        if [[ $number_of_logs -eq 0 ]]; then
            local just_init=true
        else
            local upstream=$(git rev-parse --symbolic-full-name --abbrev-ref @{upstream} 2> /dev/null)
            if [[ -n "${upstream}" && "${upstream}" != "@{upstream}" ]]; then local has_upstream=true; fi

            local git_status="$(git status --porcelain 2> /dev/null)"
            local action="$(get_current_action)"

            if [[ $git_status =~ ($'\n'|^).M ]]; then local has_modifications=true; fi
            if [[ $git_status =~ ($'\n'|^)M ]]; then local has_modifications_cached=true; fi
            if [[ $git_status =~ ($'\n'|^)A ]]; then local has_adds=true; fi
            if [[ $git_status =~ ($'\n'|^).D ]]; then local has_deletions=true; fi
            if [[ $git_status =~ ($'\n'|^)D ]]; then local has_deletions_cached=true; fi
            if [[ $git_status =~ ($'\n'|^)[MAD] && ! $git_status =~ ($'\n'|^).[MAD\?] ]]; then local ready_to_commit=true; fi

            local number_of_untracked_files=$(\grep -c "^??" <<< "${git_status}")
            if [[ $number_of_untracked_files -gt 0 ]]; then local has_untracked_files=true; fi
        
            local tag_at_current_commit=$(git describe --exact-match --tags $current_commit_hash 2> /dev/null)
            if [[ -n $tag_at_current_commit ]]; then local is_on_a_tag=true; fi
        
            if [[ $has_upstream == true ]]; then
                local commits_diff="$(git log --pretty=oneline --topo-order --left-right ${current_commit_hash}...${upstream} 2> /dev/null)"
                local commits_ahead=$(\grep -c "^<" <<< "$commits_diff")
                local commits_behind=$(\grep -c "^>" <<< "$commits_diff")
            fi

            if [[ $commits_ahead -gt 0 && $commits_behind -gt 0 ]]; then local has_diverged=true; fi
            if [[ $has_diverged == false && $commits_ahead -gt 0 ]]; then local should_push=true; fi
        
            local will_rebase=$(git config --get branch.${current_branch}.rebase 2> /dev/null)
        
            local number_of_stashes="$(git stash list -n1 2> /dev/null | wc -l)"
            if [[ $number_of_stashes -gt 0 ]]; then local has_stashes=true; fi
        fi
    fi
    
    echo "$(custom_build_prompt ${enabled:-true} ${current_commit_hash:-""} ${is_a_git_repo:-false} ${current_branch:-""} ${detached:-false} ${just_init:-false} ${has_upstream:-false} ${has_modifications:-false} ${has_modifications_cached:-false} ${has_adds:-false} ${has_deletions:-false} ${has_deletions_cached:-false} ${has_untracked_files:-false} ${ready_to_commit:-false} ${tag_at_current_commit:-""} ${is_on_a_tag:-false} ${has_upstream:-false} ${commits_ahead:-false} ${commits_behind:-false} ${has_diverged:-false} ${should_push:-false} ${will_rebase:-false} ${has_stashes:-false} ${action})"
    
}

function_exists() {
    declare -f -F $1 > /dev/null
    return $?
}

function eval_prompt_callback_if_present {
        function_exists omg_prompt_callback && echo "$(omg_prompt_callback)"
}

function node_version {
    if ! command -v node >/dev/null 2>&1; then
        echo "NODE NOT EXITS"
    else
        local br
        br=$(node -v)
        test -n "$br" && printf %s "$br" || :
    fi
}

function yarn_version {
    if ! command -v node >/dev/null 2>&1; then
        echo "NODE NOT EXITS"
    elif ! command -v yarn >/dev/null 2>&1; then
        echo "YARN NOT EXITS"
    else
        local br
        br=$(yarn -v)
        test -n "$br" && printf %s "$br" || :
    fi
}

# Set PS1 PROMPT_COMMAND to empty
PS1=""
PROMPT_COMMAND=""
PSORG=$PS1;
PROMPT_COMMAND_ORG=$PROMPT_COMMAND;

if [ -n "${BASH_VERSION}" ]; then
    DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

    : ${omg_ungit_prompt:=$PS1}
    : ${omg_second_line:=$PS1}

    # Symbols
    : ${omg_is_a_git_repo_symbol:='❤'}
    : ${omg_has_untracked_files_symbol:='∿'}
    : ${omg_has_adds_symbol:='+'}
    : ${omg_has_deletions_symbol:='-'}
    : ${omg_has_cached_deletions_symbol:='✖'}
    : ${omg_has_modifications_symbol:='✎'}
    : ${omg_has_cached_modifications_symbol:='☲'}
    : ${omg_ready_to_commit_symbol:='→'}
    : ${omg_is_on_a_tag_symbol:='⌫'}
    : ${omg_needs_to_merge_symbol:='ᄉ'}
    : ${omg_has_upstream_symbol:='⇅'}
    : ${omg_detached_symbol:='⚯ '}
    : ${omg_can_fast_forward_symbol:='»'}
    : ${omg_has_diverged_symbol:='Ⴤ'}
    : ${omg_rebase_tracking_branch_symbol:='↶'}
    : ${omg_merge_tracking_branch_symbol:='ᄉ'}
    : ${omg_should_push_symbol:='↑'}
    : ${omg_has_stashes_symbol:='★'}

    : ${omg_default_color_on:='\[\033[1;37m\]'}
    : ${omg_default_color_off:='\[\033[0m\]'}
    : ${omg_last_symbol_color:='\e[0;31m\e[40m'}
    
    # Flags
    : ${omg_display_has_upstream:=false}
    : ${omg_display_tag:=false}
    : ${omg_display_tag_name:=true}
    : ${omg_two_lines:=false}
    : ${omg_finally:=''}
    : ${omg_use_color_off:=false}

    PROMPT='$(build_prompt)'
    RPROMPT='%{$reset_color%}%T %{$fg_bold[white]%} %n@%m%{$reset_color%}'
    function enrich_append {
        local flag=$1
        local symbol=$2
        local color=${3:-$omg_default_color_on}
        if [[ $flag == false ]]; then symbol=' '; fi

        echo -n "${color}${symbol}  "
    }

    function custom_build_prompt {
        local enabled=${1}
        local current_commit_hash=${2}
        local is_a_git_repo=${3}
        local current_branch=$4
        local detached=${5}
        local just_init=${6}
        local has_upstream=${7}
        local has_modifications=${8}
        local has_modifications_cached=${9}
        local has_adds=${10}
        local has_deletions=${11}
        local has_deletions_cached=${12}
        local has_untracked_files=${13}
        local ready_to_commit=${14}
        local tag_at_current_commit=${15}
        local is_on_a_tag=${16}
        local has_upstream=${17}
        local commits_ahead=${18}
        local commits_behind=${19}
        local has_diverged=${20}
        local should_push=${21}
        local will_rebase=${22}
        local has_stashes=${23}

        local prompt=""
        local original_prompt=$PS1


        # foreground
        local black='\e[0;30m'
        local red='\e[0;31m'
        local green='\e[0;32m'
        local yellow='\e[0;33m'
        local blue='\e[0;34m'
        local purple='\e[0;35m'
        local cyan='\e[0;36m'
        local white='\e[0;37m'

        #background
        local background_black='\e[40m'
        local background_red='\e[41m'
        local background_green='\e[42m'
        local background_yellow='\e[43m'
        local background_blue='\e[44m'
        local background_purple='\e[45m'
        local background_cyan='\e[46m'
        local background_white='\e[47m'
        
        local reset='\e[0m'     # Text Reset]'

        local black_on_white="${black}${background_white}"
        local yellow_on_white="${yellow}${background_white}"
        local red_on_white="${red}${background_white}"
        local red_on_black="${red}${background_black}"
        local black_on_red="${black}${background_red}"
        local white_on_red="${white}${background_red}"
        local yellow_on_red="${yellow}${background_red}"


        # Flags
        local omg_default_color_on="${black_on_white}"

        if [[ $is_a_git_repo == true ]]; then
            # on filesystem
            prompt="${black_on_white} "
            prompt+=$(enrich_append $is_a_git_repo $omg_is_a_git_repo_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_stashes $omg_has_stashes_symbol "${yellow_on_white}")

            prompt+=$(enrich_append $has_untracked_files $omg_has_untracked_files_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_modifications $omg_has_modifications_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_deletions $omg_has_deletions_symbol "${black_on_white}")
            

            # ready
            prompt+=$(enrich_append $has_adds $omg_has_adds_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_modifications_cached $omg_has_cached_modifications_symbol "${black_on_white}")
            prompt+=$(enrich_append $has_deletions_cached $omg_has_cached_deletions_symbol "${black_on_white}")
            
            # next operation

            prompt+=$(enrich_append $ready_to_commit $omg_ready_to_commit_symbol "${black_on_white}")

            # where

            prompt="${prompt} ${white_on_red} ${black_on_red}"
            if [[ $detached == true ]]; then
                prompt+=$(enrich_append $detached $omg_detached_symbol "${white_on_red}")
                prompt+=$(enrich_append $detached "(${current_commit_hash:0:7})" "${black_on_red}")
            else            
                if [[ $has_upstream == false ]]; then
                    prompt+=$(enrich_append true "-- ${omg_not_tracked_branch_symbol}  --  (${current_branch})" "${black_on_red}")
                else
                    if [[ $will_rebase == true ]]; then
                        local type_of_upstream=$omg_rebase_tracking_branch_symbol
                    else
                        local type_of_upstream=$omg_merge_tracking_branch_symbol
                    fi

                    if [[ $has_diverged == true ]]; then
                        prompt+=$(enrich_append true "-${commits_behind} ${omg_has_diverged_symbol} +${commits_ahead}" "${white_on_red}")
                    else
                        if [[ $commits_behind -gt 0 ]]; then
                            prompt+=$(enrich_append true "-${commits_behind} ${white_on_red}${omg_can_fast_forward_symbol}${black_on_red} --" "${black_on_red}")
                        fi
                        if [[ $commits_ahead -gt 0 ]]; then
                            prompt+=$(enrich_append true "-- ${white_on_red}${omg_should_push_symbol}${black_on_red}  +${commits_ahead}" "${black_on_red}")
                        fi
                        if [[ $commits_ahead == 0 && $commits_behind == 0 ]]; then
                            prompt+=$(enrich_append true " --   -- " "${black_on_red}")
                        fi
                        
                    fi
                    prompt+=$(enrich_append true "(${current_branch} ${type_of_upstream} ${upstream//\/$current_branch/})" "${black_on_red}")
                fi
            fi
            prompt+=$(enrich_append ${is_on_a_tag} "${omg_is_on_a_tag_symbol} ${tag_at_current_commit}" "${black_on_red}")
            prompt+="${omg_last_symbol_color}${reset}\n"
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_second_line}"
        else
            prompt+="$(eval_prompt_callback_if_present)"
            prompt+="${omg_ungit_prompt}"
        fi

        echo "${prompt}"
    }
    PS2="${yellow}→${reset} "

    function bash_prompt() {
        ### START TO BUILD PROMPT
        PS1="$(build_prompt)"
        PS1="${PS1}[\w] [\t] [${AWS_DEFAULT_PROFILE}] [node $(node_version)] [yarn $(yarn_version)]\n";
    }
    PROMPT_COMMAND="bash_prompt; $PROMPT_COMMAND_ORG"

fi

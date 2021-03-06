eval (direnv hook fish)

function __direnv_on_cd --on-event fish_cd;
  echo
  __direnv_export_eval
end


function cd --description 'Change directory'
  # Skip history in subshells
  if status --is-command-substitution
    builtin cd $argv
    return $status
  end

  # Avoid set completions
  set -l previous $PWD

  if test $argv[1] = - ^/dev/null
    if test "$__fish_cd_direction" = next ^/dev/null
      nextd
    else
      prevd
    end
    return $status
  end

  builtin cd $argv[1]
  set -l cd_status $status

  if test $cd_status = 0 -a "$PWD" != "$previous"
    set -g dirprev $dirprev $previous
    set -e dirnext
    set -g __fish_cd_direction prev
  end

  emit fish_cd $argv

  return $cd_status
end

function __fish_move_last --description 'Move the last element of a directory history from src to dest'
  set -l src $argv[1]
  set -l dest $argv[2]

  set -l size_src (count $$src)

  if test $size_src = 0
    # Cannot make this step
    printf (_ "Hit end of history...\n")
    return 1
  end

  # Append current dir to the end of the destination
  set -g (echo $dest) $$dest (command pwd)

  set ssrc $$src

  # Change dir to the last entry in the source dir-hist
  builtin cd $ssrc[$size_src]

  # Keep all but the last from the source dir-hist
  set -e (echo $src)\[$size_src]

  emit fish_cd $argv

  # All ok, return success
  return 0
end

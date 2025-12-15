use chezmoi/constants.nu *
use chezmoi/helpers.nu *

export def main [
    ...file_filters: string
    --dry-run --verbose
    --auto
    --new-files
  ] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    mut state = load-state

    let workables = get-workables $file_filters $verbose
    if ($workables | is-empty) {
      print 'Already up-to-date'
      return 
    }

    let cancellables_changes = $workables
      | where ($it.status in $CANCELLABLE_TARGET_CHANGES)
      | select status target 

    let is_addition = $workables
      | where ($it.status in $CANCELLABLE_TARGET_ADDITIONS)
      | select status target 

    if not $auto {
      if ($cancellables_changes | is-not-empty) {
        print "The following target changes will be cancelled:"
        print ($cancellables_changes | table -t default -i false)
      }

      if ($is_addition | is-not-empty) {
        print "Deletion new files can be handled automatically for the following files:"
        if (not $new_files) {
          print $"(ansi yellow)--new-files not supplied, deletion will be skipped(ansi reset)"
        }
        print ($is_addition | table -t default -i false)
      }

      let answer = [no yes] | input list "Would you like to proceed?"
      if ($answer != yes) {
        return
      }
    }
    
    for workable in $workables {
      match $workable.status {
        'target-deleted' => {
          try {
            print $"(ansi purple)(ansi reset) Applying target ($workable.target) \(recently deleted)"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.target_hash
          }
        },
        'target-changed' => {
          try {
            print $"(ansi purple)(ansi reset) Applying target ($workable.target) \(recently changed)"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'both-changed-identical' => {
          try {
            print $"(ansi blue)(ansi reset) Files changed & identical, update cache. ($workable.target)"
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'untracked-source-missing' => {
          let deletion_string = if not $new_files { " Use --new-files to handle it automatically."} else { "" }
          print $"(ansi red)󰆴(ansi reset) New target ($workable.target).($deletion_string)"
          if $new_files {
            print $"(ansi red)󰆴(ansi reset) Deleting target ($workable.target)."
            if (not $dry_run) {
              rm $workable.target
            }
            $state = $state | reject $workable.target
          }
        }
      }
    }    

    save-state $state

    let dry_run_message = if ($dry_run) { "(DRY_RUN)" } else { "" }

    print $"(ansi green)✓(ansi reset) Made myself chezmoi (ansi yellow)($dry_run_message)(ansi reset)"

  }
}

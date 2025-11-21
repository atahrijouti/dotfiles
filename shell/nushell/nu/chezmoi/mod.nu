use ./constants.nu *
use ./helpers.nu *

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def magic [] {
  do-magic
}

export def status [...file_filters: string --table --verbose] {
  mut workables = get-workables $file_filters $verbose

  if not $verbose {
    $workables = $workables | where {|f| $f.status != 'up-to-date' } | select status target
  }

  if (not $table and ($workables | is-empty)) {
    'Up to date'
  } else {
    $workables
  }
}
 
export def sync [
    ...file_filters: string
    --dry-run --verbose
    --auto
    --delete
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

    let auto_syncable = $workables
      | where ($it.status in $AUTO_RESOLVED_STATUSES)
      | select status target

    let is_deletable = $workables
      | where ($it.status in $AUTO_DELETE_STATUSES)
      | select status target

    let is_in_conflict = $workables
      | where ($it.status in $CONFLICT_STATUSES)
      | select status target

    if not $auto {
      if ($auto_syncable | is-not-empty) {
        print "The following files will be synced automatically:"
        print ($auto_syncable | table -t default -i false)
      }

      if ($is_deletable | is-not-empty) {
        print "Deletion can be handled automatically for the following files:"
        if (not $delete) {
          print $"(ansi yellow)--delete not supplied, deletion will be skipped(ansi reset)"
        }
        print ($is_deletable | table -t default -i false)
      }
    
      if ($is_in_conflict | is-not-empty) {
        print "The following files are in conflict. Use resolve-conflicts to handle them:"
        print ($is_in_conflict| table -t default -i false)
      }

      let answer = [no yes] | input list "Would you like to proceed?"
      if ($answer != yes) {
        return
      }
    }
    
    for workable in $workables {
      match $workable.status {
        'untracked-both-missing' => {
          print $"(ansi yellow)(ansi reset) Missing source and target for mapping ($workable.target)"
        },
        'untracked-source-missing' => {
          try {
            print $"(ansi purple)(ansi reset) Pulling target ($workable.target) for the first time"
            copy-file $workable.target $workable.source
            $state = update-state-for-target $state $workable.target $workable.target_hash
          }
        },
        'untracked-target-missing' => {
          try {
            print $"(ansi purple)(ansi reset) Applying target ($workable.target) for the first time"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'untracked-identical' => {
          try {
            print $"(ansi blue)(ansi reset) Files in place, missing cache entry. ($workable.target)"
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'both-deleted' => {
          print $"(ansi blue)(ansi reset) Files deleted. ($workable.target)"
          $state = $state | reject $workable.target
        },
        'source-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"(ansi red)󰆴(ansi reset) Source deleted for ($workable.target).($delete_string)"
            if $delete {
              print $"(ansi red)󰆴(ansi reset) Deleting target ($workable.target)."
              rm $workable.target
              $state = $state | reject $workable.target
            }
          }
        },
        'target-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"(ansi red)󰆴(ansi reset) Target deleted ($workable.target).($delete_string)"
            if $delete {
              print $"(ansi red)󰆴(ansi reset) Deleting source ($workable.source)."
              rm $workable.source
              $state = $state | reject $workable.target
            }
          }
        },
        'source-changed' => {
          try {
            print $"(ansi cyan)(ansi reset) Applying ($workable.target)"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'target-changed' => {
          try {
            print $"(ansi cyan)(ansi reset) Pulling ($workable.target)"
            copy-file $workable.target $workable.source
            $state = update-state-for-target $state $workable.target $workable.target_hash
          }
        },
        'both-changed-identical' => {
          try {
            print $"(ansi blue)(ansi reset) Files changed & identical, update cache. ($workable.target)"
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'up-to-date' => {
          print $"(ansi green)(ansi reset) Up to date. ($workable.target)"
        }
      }
    }    

    save-state $state

    let dry_run_message = if ($dry_run) { "(DRY_RUN)" } else { "" }

    print $"(ansi green)✓(ansi reset) Made myself chezmoi (ansi yellow)($dry_run_message)(ansi reset)"

  }
}

export def resolve-conflicts [] {
  
}

export def diff [...file_filters: string] {
  let diffable_workables = (get-workables $file_filters) | where ($DIFFABLE_STATUSES has $it.status)

  for workable in $diffable_workables {
    match $workable.status {
      'untracked-different' | 'target-changed' | 'both-changed-different' => {
        display-diff $workable.source $workable.target $workable.status $workable.target
      }
      'source-changed' => {
        display-diff $workable.target $workable.source $workable.status $workable.target
      }
      'untracked-source-missing' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi blue)(ansi reset) New target\n"
      }
      'untracked-target-missing' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi blue)(ansi reset) New source\n"
      }
      'source-deleted' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi red)󰆴(ansi reset) Source deleted\n"
      }
      'source-deleted-target-changed' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi yellow)(ansi reset) Source deleted, but the target has changed\n"
      }
      'target-deleted' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi red)󰆴(ansi reset) Target deleted\n"
      }
      'target-deleted-source-changed' => {
        print-diff-header $workable.status $workable.target
        print $"(ansi yellow)(ansi reset) Target deleted, but the source has changed\n"
      }   
    }
  }
}

use ./helpers.nu *

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def status [...file_filters: string --table --verbose] {
  mut workables = get-workables $file_filters

  if not $verbose {
    $workables = $workables | where {|f| $f.status != 'up-to-date' } | select target status
  }

  if (not $table and ($workables | is-empty)) {
    'Up to date'
  } else {
    $workables
  }
}

export def diff [...file_filters: string] {
  for workable in (get-workables $file_filters) {
    match $workable.status {
      'untracked-different' | 'target-changed' | 'both-changed-different' => {
        display-diff $workable.source $workable.target $workable.status $workable.target
      }
      'source-changed' => {
        display-diff $workable.target $workable.source $workable.status $workable.target
      }
      _ => {}
    }
  }
}

export def sync [
    ...file_filters: string
    --dry-run --verbose
    --prefer-source
    --prefer-target
    --merge
    --interactive
    --delete
  ] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    mut state = load-state
    for workable in (get-workables $file_filters) {
      match $workable.status {
        'untracked-both-missing' => {
          print $" Missing source and target for mapping ($workable.target)"
        },
        'untracked-source-missing' => {
          try {
            print $" Pulling target ($workable.target) for the first time"
            copy-file $workable.target $workable.source
            $state = update-state-for-target $state $workable.target $workable.target_hash
          }
        },
        'untracked-target-missing' => {
          try {
            print $" Applying target ($workable.target) for the first time"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'untracked-identical' => {
          try {
            print $" Files in place, missing cache entry. ($workable.target)"
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'untracked-different' => {
          print $" Untracked files are in conflict and require manual intervention. ($workable.target)"
          if $prefer_source {
            print $"cp ($workable.source) ($workable.target)"
          } else if $prefer_target {
            print $"cp ($workable.target) ($workable.source)"
          } else if $merge {
            print $"nvim -d ($workable.source) ($workable.target)"
          }
        },
        'both-deleted' => {
          print $" Files deleted. ($workable.target)"
          $state = $state | reject $workable.target
        },
        'source-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"󰆴 Source deleted for ($workable.target).($delete_string)"
            if $delete {
              print $"󰆴 Deleting target ($workable.target)."
              rm $workable.target
              $state = $state | reject $workable.target
            }
          }
        },
        'target-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"󰆴 Target deleted ($workable.target).($delete_string)"
            if $delete {
              print $"󰆴 Deleting source ($workable.source)."
              rm $workable.source
              $state = $state | reject $workable.target
            }
          }
        },
        'source-deleted-target-changed' => {
          print $" Source deleted & target changed. ($workable.target)"
          if $prefer_source {
            print $"rm ($workable.target)"
          } else if $prefer_target {
            print $"cp ($workable.target) ($workable.source)"
          }
        },
        'target-deleted-source-changed' => {
          print $" Target deleted & source changed. ($workable.target)"
          if $prefer_source {
            print $"cp ($workable.source) ($workable.target)"
          } else if $prefer_target {
            print $"rm ($workable.source)"
          }
        },
        'source-changed' => {
          try {
            print $" Applying ($workable.target)"
            copy-file $workable.source $workable.target
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'target-changed' => {
          try {
            print $" Pulling ($workable.target)"
            copy-file $workable.target $workable.source
            $state = update-state-for-target $state $workable.target $workable.target_hash
          }
        },
        'both-changed-identical' => {
          try {
            print $" Files changed & identical, update cache. ($workable.target)"
            $state = update-state-for-target $state $workable.target $workable.source_hash
          }
        },
        'both-changed-different' => {
          print $" Files are in conflict and require manual intervention. ($workable.target)"
          if $prefer_source {
            print $"cp ($workable.source) ($workable.target)"
          } else if $prefer_target {
            print $"cp ($workable.target) ($workable.source)"
          } else if $merge {
            print $"nvim -d ($workable.source) ($workable.target)"
          }
        },
        'up-to-date' => {
          if $env.VERBOSE? {
            print $" Up to date. ($workable.target)"
          }
        }
      }
    }    

    save-state $state

    print $"\n✓ Made myself chezmoi"

  }
}

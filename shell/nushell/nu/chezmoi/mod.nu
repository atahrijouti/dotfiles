use ./helpers.nu *

const POSSIBLE_DIRECTIONS = ['apply', 'pull']

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def status [--table --verbose] {
  mut status_data = workable-file-mappings

  if not $verbose {
    $status_data = $status_data | where {|f| $f.status != 'up-to-date' } | select target status
  }

  if (not $table and ($status_data | is-empty)) {
    'Up to date'
  } else {
    $status_data
  }
}

export def sync [--dry-run --verbose --delete] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    mut state = load-state
    for $mapping in (workable-file-mappings) {
      match $mapping.status {
        'untracked-both-missing' => {
          print $" Missing source and target for mapping ($mapping.target)"
        },
        'untracked-source-missing' => {
          try {
            print $" Pulling target ($mapping.target) for the first time"
            copy-file $mapping.target $mapping.source
            $state = update-state-for-target $state $mapping.target $mapping.target
          }
        },
        'untracked-target-missing' => {
          try {
            print $" Applying target ($mapping.target) for the first time"
            copy-file $mapping.source $mapping.target
            $state = update-state-for-target $state $mapping.target $mapping.source_hash
          }
        },
        'untracked-identical' => {
          try {
            print $" Files in place, missing cache entry. ($mapping.target)"
            $state = update-state-for-target $state $mapping.target $mapping.source_hash
          }
        },
        'untracked-different' => {
          print $" Untracked files are in conflict and require manual intervention. ($mapping.target)"
          # --prefer-target: should this flag just pull target on source?
          # --prefer-source: should this flag just apply the source onto the target?
          # --merge should this flag open some kind of mechanism that offers interactive merge?
        },
        'both-deleted' => {
          print $" Files deleted. ($mapping.target)"
          $state = $state | reject $mapping.target
        },
        'source-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"󰆴 Source deleted for ($mapping.target).($delete_string)"
            if $delete {
              try {
                print $"󰆴 Deleting target for ($mapping.target)."
                rm $mapping.target
              }
            }
          }
        },
        'target-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"󰆴 Target deleted for ($mapping.target).($delete_string)"
            if $delete {
              try {
                print $"󰆴 Deleting source for ($mapping.target)."
                rm $mapping.source
              }
            }
          }
        },
        'source-deleted-target-changed' => {
          print $" Source deleted & target changed. ($mapping.target)"
          # --prefer-target: should this flag pull target on source?
          # --prefer-source: should this flag delete changed target?
          # --merge should this flag open some kind of mechanism that offers interactive merge?
        },
        'target-deleted-source-changed' => {
          print $" Target deleted & source changed. ($mapping.target)"
          # --prefer-target: should this flag apply source on target?
          # --prefer-source: should this flag delete changed source?
          # --merge should this flag open some kind of mechanism that offers interactive merge?
        },
        'source-changed' => {
          try {
            print $" Applying ($mapping.target)"
            copy-file $mapping.source $mapping.target
            $state = update-state-for-target $state $mapping.target $mapping.source_hash
          }
        },
        'target-changed' => {
          try {
            print $" Pulling ($mapping.target)"
            copy-file $mapping.target $mapping.source
            $state = update-state-for-target $state $mapping.target $mapping.target_hash
          }
        },
        'both-changed-identical' => {
          try {
            print $" Files changed & identical, update cache. ($mapping.target)"
            $state = update-state-for-target $state $mapping.target $mapping.source_hash
          }
        },
        'both-changed-different' => {
          print $" Files are in conflict and require manual intervention. ($mapping.target)"
          # --prefer-target: should this flag apply source on target?
          # --prefer-source: should this flag delete changed source?
          # --merge should this flag open some kind of mechanism that offers interactive merge?
        },
        'up-to-date' => {
          if $env.VERBOSE? {
            print $" Up to date. ($mapping.target)"
          }
        }
      }
    }    

    save-state $state

    print $"\n✓ Made myself chezmoi"

  }
}

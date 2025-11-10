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

export def magic [...files_filter: string] {
  workable-file-mappings $files_filter 
}

export def sync [--dry-run --verbose --prefer-source --prefer-target --merge --interactive --delete] {
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
            $state = update-state-for-target $state $mapping.target $mapping.target_hash
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
          if $prefer_source {
            print $"cp ($mapping.source) ($mapping.target)"
          } else if $prefer_target {
            print $"cp ($mapping.target) ($mapping.source)"
          } else if $merge {
            print $"nvim -d ($mapping.source) ($mapping.target)"
          }
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
              print $"󰆴 Deleting target ($mapping.target)."
              rm $mapping.target
              $state = $state | reject $mapping.target
            }
          }
        },
        'target-deleted' => {
          try {
            let delete_string = if not $delete { " use --delete to handle it automatically." } else { ""  }
            print $"󰆴 Target deleted ($mapping.target).($delete_string)"
            if $delete {
              print $"󰆴 Deleting source ($mapping.source)."
              rm $mapping.source
              $state = $state | reject $mapping.target
            }
          }
        },
        'source-deleted-target-changed' => {
          print $" Source deleted & target changed. ($mapping.target)"
          if $prefer_source {
            print $"rm ($mapping.target)"
          } else if $prefer_target {
            print $"cp ($mapping.target) ($mapping.source)"
          }
        },
        'target-deleted-source-changed' => {
          print $" Target deleted & source changed. ($mapping.target)"
          if $prefer_source {
            print $"cp ($mapping.source) ($mapping.target)"
          } else if $prefer_target {
            print $"rm ($mapping.source)"
          }
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
          if $prefer_source {
            print $"cp ($mapping.source) ($mapping.target)"
          } else if $prefer_target {
            print $"cp ($mapping.target) ($mapping.source)"
          } else if $merge {
            print $"nvim -d ($mapping.source) ($mapping.target)"
          }
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

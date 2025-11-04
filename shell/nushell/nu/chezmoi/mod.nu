use ./helpers.nu *

const POSSIBLE_DIRECTIONS = ['apply', 'pull']

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def apply [--dry-run --verbose] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    sync apply
  }
}

export def pull [--dry-run --verbose] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    sync pull
  }
}

export def sync [direction: string] {
  if not ($direction in $POSSIBLE_DIRECTIONS) {
    print $"direction takes ($POSSIBLE_DIRECTIONS), received ($direction)"
    return 
  }

  let is_apply = $direction == 'apply'
  mut state = load-state

  for $f in (workable-file-mappings) {
    let from = if $is_apply { $f.source } else { $f.target }
    let to = if $is_apply { $f.target } else { $f.source }

    let from_locale = if $is_apply {'source'} else {'local'}
    let to_locale = if $is_apply {'local'} else {'source'}

    let from_hash = if $is_apply { $f.source_hash } else { $f.target_hash }
    let to_hash = if $is_apply { $f.target_hash } else { $f.source_hash }

    let last_applied_hash = $state | get -o $f.target

    let from_missing = $from_hash == null
    let to_missing = $to_hash == null
    let from_matches_to = $from_hash == $to_hash
    let to_changed_only = (
      $from_hash == $last_applied_hash and $to_hash != $last_applied_hash
    )
    let from_changed_only = (
      $from_hash != $last_applied_hash and $to_hash == $last_applied_hash
    )
    let both_changed = (
      $from_hash != $last_applied_hash
      and $to_hash != $last_applied_hash
    )

    # TODO treat deletion cases
    if $to_missing {
      let to_dir = $to | path dirname
      if not ($to_dir | path exists) {
        if not $env.DRY_RUN? {
          mkdir $to_dir
        }
        print $" mkdir ($to_dir)"
      }

      if not $env.DRY_RUN? {
        cp $from $to
        $state = ($state | upsert $f.target $from_hash)
      }
      print $" cp ($from) ($to)"
      continue
    }

    # TODO treat deletion cases
    if $from_missing {
      print $"⚠ SKIP : ($from_locale) file missing for ($to_locale) file : ($from)"  
      continue
    }

    if $from_matches_to {
      if $from_hash != $last_applied_hash {
        if not $env.DRY_RUN? {
          $state = ($state | upsert $f.target $from_hash)
        }
      }
      if $env.VERBOSE? {
        print $"✓ ($to) - up to date"
      }
      continue
   }

    if $from_changed_only {
      let to_dir = $to | path dirname
      if not ($to_dir | path exists) {
        if not $env.DRY_RUN? {
          mkdir $to_dir
        }
        print $" mkdir ($to_dir)"
      }

      if not $env.DRY_RUN? {
        cp $from $to
        $state = ($state | upsert $f.target $from_hash)
      }
      print $" cp ($from) ($to)"
      continue
    }

    if $to_changed_only {
      if $is_apply {
        print $"⚠ SKIP ($to) - local changes detected \(run 'pull' to save)"
      } else {
        print $"⚠ SKIP ($to) - source changes detected \(run 'apply' to update)"
      }
      continue
    }

    if $both_changed {
      if $from_hash == $to_hash {
        if not $env.DRY_RUN? {
          $state = ($state | upsert $f.target $from_hash)
        }
        if $env.VERBOSE? {
          print $"✓ ($to) - identical after changes"
        }
      } else {
        print $"⚠ CONFLICT ($to) - both source and local files changed \(resolve manually)"
      }
      continue
    }
  }

  save-state $state

  print $"\n✓ ($direction | str capitalize) complete"
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

export def magic [--dry-run --verbose] {
  with-env {
    DRY_RUN: $dry_run,
    VERBOSE: $verbose
  } {
    mut state = load-state
    for $mapping in (workable-file-mappings) {
      match $mapping.status {
        'untracked-both-missing' => {
          print $" Mapping exists, missing source and target. ($mapping.target)"
        },
        'untracked-source-missing' => {
          print $" Mapping exists, missing source. ($mapping.target)"
        },
        'untracked-target-missing' => {
          try {
            print $" Applying target ($mapping.target) for the first time"
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
        },
        'both-deleted' => {
          print $" Files deleted. ($mapping.target)"
          $state = $state | reject $mapping.target
        },
        'source-deleted' => {
          try {
            print $"󰆴 Delete target using --delete. ($mapping.target)"
          }
        },
        'source-deleted-target-changed' => {
          print $" Source deleted & target changed. ($mapping.target)"
        },
        'target-deleted' => {
          print $"󰆴 Delete source using --delete. ($mapping.target)"
        },
        'target-deleted-source-changed' => {
          print $" Target deleted & source changed. ($mapping.target)"
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

use ./helpers.nu *

const POSSIBLE_DIRECTIONS = ['apply', 'pull']

# Manage dotfiles à la chezmoi, with extra features to handle multiple OS setups
# 
# chezmoi est chez toi
export def main [] {
}

export def apply [--dry-run --verbose] {
  sync apply --dry-run=$dry_run --verbose=$verbose
}

export def pull [--dry-run --verbose] {
  sync pull --dry-run=$dry_run --verbose=$verbose
}

export def sync [direction: string --dry-run --verbose] {
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
        if not $dry_run {
          mkdir $to_dir
        }
        print $" mkdir ($to_dir)"
      }

      if not $dry_run {
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
        if not $dry_run {
          $state = ($state | upsert $f.target $from_hash)
        }
      }
      if $verbose {
        print $"✓ ($to) - up to date"
      }
      continue
    }

    if $from_changed_only {
      let to_dir = $to | path dirname
      if not ($to_dir | path exists) {
        if not $dry_run {
          mkdir $to_dir
        }
        print $" mkdir ($to_dir)"
      }

      if not $dry_run {
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
        if not $dry_run {
          $state = ($state | upsert $f.target $from_hash)
        }
        if $verbose {
          print $"✓ ($to) - identical after changes"
        }
      } else {
        print $"⚠ CONFLICT ($to) - both source and local files changed \(resolve manually)"
      }
      continue
    }
  }

  if not $dry_run {
    save-state $state
  }

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


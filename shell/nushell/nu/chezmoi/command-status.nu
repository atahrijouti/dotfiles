use helpers.nu *

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

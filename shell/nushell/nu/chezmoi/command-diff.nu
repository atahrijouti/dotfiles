use constants.nu *
use helpers.nu *

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

export const DOTFILES_ROOT = '~/source/dotfiles'
export const STATE_FILE = $"($nu.cache-dir)/chezmoi-state.nuon" | path expand
export const MAPPINGS_FILE = path self ./mappings.nuon
export const OS = $nu.os-info.name

export const STATUSES = [
  'untracked-both-missing',
  'untracked-source-missing',
  'untracked-target-missing',
  'untracked-identical',
  'untracked-different',
  'both-deleted',
  'source-deleted',
  'source-deleted-target-changed',
  'target-deleted',
  'target-deleted-source-changed',
  'source-changed',
  'target-changed',
  'both-changed-identical',
  'both-changed-different',
  'up-to-date' 
]

export const DIFFABLE_STATUSES = [
  'untracked-source-missing',
  'untracked-target-missing',
  'untracked-different',
  'source-deleted',
  'source-deleted-target-changed',
  'target-deleted',
  'target-deleted-source-changed',
  'source-changed',
  'target-changed',
  'both-changed-different',
]

export const AUTO_RESOLVED_STATUSES = [
  'untracked-both-missing',
  'untracked-source-missing',
  'untracked-target-missing',
  'untracked-identical',
  'both-deleted',
  'source-changed',
  'target-changed',
  'both-changed-identical',
  'up-to-date' 
]

export const AUTO_DELETE_STATUSES = [
  'source-deleted',
  'target-deleted',
]

export const CONFLICT_STATUSES = [
  'untracked-different',
  'source-deleted-target-changed',
  'target-deleted-source-changed',
  'both-changed-different',
]



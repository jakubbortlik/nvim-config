return {
  "tpope/vim-eunuch",
  event = "InsertEnter",
  cmd = {
    "Cfind", -- Run find and load the results into the quickfix list.
    "Chmod", -- Change the permissions of the current file.
    "Clocate", -- Run locate and load the results into the quickfix list.
    "Copy", -- Small wrapper around |:saveas|. Parent directories automatically created.
    "Delete", -- Delete file from disk and the buffer too.
    "Duplicate", -- Like |:Copy|, but the argument is taken as relative to current file's parent dir.
    "Lfind", -- Like above, but use the location list.
    "Llocate", -- Like above.
    "Mkdir", -- Create a directory, defaulting to the parent of the current file.
    "Move", -- Rename a buffer and the file on disk simultaneously. See also :Rename, :Copy, and :Duplicate.
    "Remove", -- Delete file from disk, reload buffer, without E211: File no longer available (restore buffer with 'u').
    "Rename", -- Like |:Move|, but the argument is taken as relative to current file's parent dir.
    "SudoEdit", -- Edit a privileged file with sudo.
    "SudoWrite", -- Write a privileged file with sudo.
    "Unlink", -- Like |:Remove|.
    "Wall", -- Write every open window. Handy for kicking off tools like guard.
  },
}

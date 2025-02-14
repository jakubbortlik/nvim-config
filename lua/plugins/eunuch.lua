return {
  "tpope/vim-eunuch",
  event = "InsertEnter",
  cmd = {
    "Remove", -- Delete a file on disk without E211: File no longer available.
    "Delete", -- Delete a file on disk and the buffer too.
    "Move", -- Rename a buffer and the file on disk simultaneously. See also :Rename, :Copy, and :Duplicate.
    "Chmod", -- Change the permissions of the current file.
    "Mkdir", -- Create a directory, defaulting to the parent of the current file.
    "Cfind", -- Run find and load the results into the quickfix list.
    "Clocate", -- Run locate and load the results into the quickfix list.
    "Lfind", -- Like above, but use the location list.
    "Llocate", -- Like above.
    "Wall", -- Write every open window. Handy for kicking off tools like guard.
    "SudoWrite", -- Write a privileged file with sudo.
    "SudoEdit", -- Edit a privileged file with sudo.
  }
}

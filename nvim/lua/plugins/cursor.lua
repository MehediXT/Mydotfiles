return {
  {
    "sphamba/smear-cursor.nvim",
    lazy = false,
    priority = 1000,

    opts = {
      -- Smooth physics
      stiffness = 0.55,
      trailing_stiffness = 0.35,
      damping = 0.95,

      -- Cursor behavior
      smear_between_buffers = true,
      smear_between_neighbor_lines = true,
      smear_insert_mode = true,
      scroll_buffer_space = true,

      -- Smooth animation
      time_interval = 16,
      distance_stop_animating = 0.3,

      -- Less fade / cleaner look
      gamma = 3.0,

      -- Avoid double cursor
      hide_target_hack = true,
    },
  },
}

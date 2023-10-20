return {
  {
    "nvim-neotest/neotest-plenary",
    dependencies = { "nvim-neotest/neotest", "marilari88/neotest-vitest", "rouge8/neotest-rust" },
  },
  {
    "nvim-neotest/neotest",
    opts = { adapters = { "neotest-plenary", "neotest-vitest", "neotest-rust" } },
  },
}

-- Playwright adapter for neotest
return {
  {
    "nvim-neotest/neotest",
    dependencies = {
      "thenbe/neotest-playwright",
    },
    opts = {
      adapters = {
        ["neotest-playwright"] = {
          options = {
            persist_project_selection = true,
            enable_dynamic_test_discovery = true,
          },
        },
      },
    },
  },
}

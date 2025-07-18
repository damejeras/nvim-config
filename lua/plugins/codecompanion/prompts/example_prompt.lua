return {
  strategy = "chat",
  description = "Some cool custom prompt you can do",
  prompts = {
    {
      role = "system",
      content = "You are an experienced developer with Lua and Neovim",
    },
    {
      role = "user",
      content = "Can you explain why ..."
    }
  },
}
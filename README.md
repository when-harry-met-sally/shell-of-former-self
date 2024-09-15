# Shell of Former Self

This is my workflow for managing sessions in the terminal. I found myself struggling with tabs, because I would continuously add them. I didn't like the fact that I had to remember which tabs had what. I know that tabs have file paths in their description, but I felt it wasn't working that well for me.

This is far from perfect, and I continue to struggle with the same thing: opening sessions that I already have. But I prefer this for a few reasons, and I can expand on it.

This workflow depends on two sessions for all my work. I have a session with preloaded shells, and the session where I actually work in.

I'm sure there are better ways to improve load time when starting a new terminal window/tab, but this is the solution I've been using. My .zshrc is probably bloated.

By sourcing index.zsh, and binding the new-tab script to a tmux binding, I can have a preloaded window that I swap to when I need to create a new session.

I'll improve documentation as I tweak this.

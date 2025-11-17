# CalcMCP
A simple test MCP server with the following tools:
- Add
- Subtract
- List Files
- Flip Coin

### How to build/install
1.) Install Docker Desktop (with WSL Integration)</br>
2.) Install Claude Desktop</br>
3.) *[OPTIONAL]:* Make a backup of your Claude Desktop config (`Settings` > `Developer` > `Edit Config` to show it in Windows Explorer)</br>
4.) Clone repository and run `install.ps1`</br>

### How to use
1.) Make sure the Docker Desktop service is running (and MCP Toolkit is enabled)</br>
2.) Run Claude Desktop</br>
3.) In Claude Desktop, click the `Search and tools` button > `MCP_DOCKER` and enable/disable the tools you want</br>
4.) Execute a chat. For example:</br>
  - "Add 1234 + 5678"
  - "Subtract 8765 - 4321"
  - "List all files in the `/app` directory"
  - "Flip a coin for me"
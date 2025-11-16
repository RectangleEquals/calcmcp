import os
from mcp.server.fastmcp import FastMCP

host = os.environ.get("MCP_HOST", "127.0.0.1")
port = int(os.environ.get("MCP_PORT", "8080"))
mcp = FastMCP(name="calcmcp", host=host, port=port)

@mcp.tool()
def add(a: float, b: float) -> float:
    """Return a + b."""
    return a + b

@mcp.tool()
def subtract(a: float, b: float) -> float:
    """Return a - b."""
    return a - b

if __name__ == "__main__":
    mcp.run(transport="stdio")
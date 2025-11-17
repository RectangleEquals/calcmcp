import os
import logging
import random
from mcp.server.fastmcp import FastMCP

logging.basicConfig(level=logging.INFO)
logger=logging.getLogger("calcmcp [server]")

host = os.environ.get("MCP_HOST", "127.0.0.1")
port = int(os.environ.get("MCP_PORT", "8080"))
mcp = FastMCP(name="calcmcp", host=host, port=port)

@mcp.tool()
def add(a: float, b: float) -> float:
    """Return the sum of two numbers (a + b)."""
    logger.info(f"Adding {a} + {b}...")
    return a + b

@mcp.tool()
def subtract(a: float, b: float) -> float:
    """Return the difference of two numbers (a - b)."""
    logger.info(f"Subtracting {a} - {b}...")
    return a - b

@mcp.tool()
def list_files(path: str) -> list[str]:
    """List all files in the given directory path."""
    logger.info(f"Listing files in directory: {path}")
    try:
        files = os.listdir(path)
        return files
    except Exception as e:
        logger.error(f"Error listing files in {path}: {e}")
        return []

@mcp.tool()
def flip_coin() -> str:
    """Flip a coin and return 'heads' or 'tails'."""
    result = random.choice(["heads", "tails"])
    logger.info(f"Flipped a coin: {result}")
    return result

if __name__ == "__main__":
    logger.info(f"Starting Calculator MCP Server on {host}:{port}")
    mcp.run(transport="stdio")
    logger.info("Calculator MCP Server stopped")
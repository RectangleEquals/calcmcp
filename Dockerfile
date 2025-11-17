FROM python:3.11-slim

# Install build requirements
RUN apt-get update && apt-get install -y --no-install-recommends build-essential

# Set working directory
WORKDIR /app

# Copy all files
COPY . /app

# Install Python dependencies
RUN pip install --upgrade pip \
    && pip install --no-cache-dir .

# Expose port if needed (MCP uses stdio, so not required)
# EXPOSE 8080

# Run the MCP server
CMD ["python", "-m", "calc_mcp_server.server"]
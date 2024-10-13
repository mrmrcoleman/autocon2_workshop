# Use a specific, recent version of Ubuntu
FROM ubuntu:22.04

# Set environment variable to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

# Update the package list and install Python, pip, and networking tools
RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    iproute2 \
    iputils-ping \
    traceroute \
    && apt-get clean

# Install Flask using pip
RUN pip3 install Flask

# Set the working directory in the container
WORKDIR /app

# Copy the Flask app file into the container
COPY app.py /app/

# Copy the entrypoint script
COPY entrypoint.sh /app/

# Ensure the entrypoint script has executable permissions
RUN chmod +x /app/entrypoint.sh

# Expose port 8080 to the outside world
EXPOSE 8080

# Set the entrypoint to the script that will configure the network and start Flask
ENTRYPOINT ["/app/entrypoint.sh"]